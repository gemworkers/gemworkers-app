import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/branch_service.dart';
import '../models/purchase.dart';

class PurchaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// List view — joins supplier name but does NOT load purchase_items.
  Future<List<Purchase>> getPurchases({String? supplierId}) async {
    final query = _supabase.from('purchases').select(
        'id, purchase_number, purchase_date, gem_cost, shipping_cost, '
        'customs_cost, other_fees, total_cost, notes, supplier_id, '
        'created_at, suppliers(name)');

    final response = supplierId != null
        ? await query
            .eq('supplier_id', supplierId)
            .order('created_at', ascending: false)
        : await query.order('created_at', ascending: false);

    return response.map<Purchase>((row) => Purchase.fromMap(row)).toList();
  }

  /// Full detail — joins supplier AND purchase_items.
  Future<Purchase> getPurchaseDetail(String id) async {
    final response = await _supabase
        .from('purchases')
        .select('*, suppliers(name), purchase_items(*)')
        .eq('id', id)
        .single();
    return Purchase.fromMap(response);
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// Creates the purchase and its line items, then optionally creates one draft
  /// inventory item per gem (quantity × lines).
  /// branch_id defaults to kCurrentBranchId (see branch_service.dart) when not set.
  Future<Purchase> addPurchase(
    Purchase purchase, {
    bool createInventoryItems = true,
    String? destinationLocationId,
  }) async {
    // 1. Insert purchase header. Default branch to kCurrentBranchId if not set.
    final purchaseMap = purchase.toMap();
    purchaseMap['branch_id'] ??= kCurrentBranchId;
    final branchId = purchaseMap['branch_id'] as String;

    final row = await _supabase
        .from('purchases')
        .insert(purchaseMap)
        .select()
        .single();
    final purchaseId = row['id'] as String;

    // 2. Compute per-line landed-cost allocation and insert purchase_items.
    final itemsWithCosts = _allocateCosts(purchase);
    for (final item in itemsWithCosts) {
      await _supabase
          .from('purchase_items')
          .insert({...item.toMap(), 'purchase_id': purchaseId});
    }

    // 3. Optionally create one draft inventory item per gem.
    if (createInventoryItems && itemsWithCosts.isNotEmpty) {
      await _createInventoryItems(
        purchaseId: purchaseId,
        supplierId: purchase.supplierId,
        branchId: branchId,
        items: itemsWithCosts,
        destinationLocationId: destinationLocationId,
      );
    }

    return getPurchaseDetail(purchaseId);
  }

  /// Updates the purchase header and replaces all line items.
  /// Does NOT re-run inventory auto-creation.
  Future<void> updatePurchase(String id, Purchase purchase) async {
    await _supabase.from('purchases').update(purchase.toMap()).eq('id', id);
    await _supabase.from('purchase_items').delete().eq('purchase_id', id);

    final itemsWithCosts = _allocateCosts(purchase);
    for (final item in itemsWithCosts) {
      await _supabase
          .from('purchase_items')
          .insert({...item.toMap(), 'purchase_id': id});
    }
  }

  Future<void> deletePurchase(String id) async {
    await _supabase.from('purchases').delete().eq('id', id);
  }

  // ── Landed-cost allocation ────────────────────────────────────────────────

  /// Divides the total landed cost equally across every gem in the lot.
  /// Each line's allocatedCost = line.quantity × costPerGem.
  List<PurchaseItem> _allocateCosts(Purchase purchase) {
    final items = purchase.items;
    if (items.isEmpty) return [];

    final totalQty = items.fold(0, (sum, i) => sum + i.quantity);
    if (totalQty == 0) {
      return items.map((i) => i.copyWith(allocatedCost: 0)).toList();
    }

    final costPerGem = purchase.totalCost / totalQty;
    return items
        .map((item) =>
            item.copyWith(allocatedCost: item.quantity * costPerGem))
        .toList();
  }

  // ── Auto-create inventory ─────────────────────────────────────────────────

  /// Creates one draft inventory_item per gem — i.e. `item.quantity` items
  /// per purchase line. Each item gets cost_price = costPerGem, is linked
  /// back to this purchase via inventory_items.purchase_id, and is placed
  /// at destinationLocationId (typically the branch's Intake zone).
  Future<void> _createInventoryItems({
    required String purchaseId,
    required String? supplierId,
    required String branchId,
    required List<PurchaseItem> items,
    String? destinationLocationId,
  }) async {
    final totalQty = items.fold(0, (sum, i) => sum + i.quantity);
    final totalLandedCost =
        items.fold(0.0, (sum, i) => sum + i.allocatedCost);
    final costPerGem =
        totalQty > 0 ? totalLandedCost / totalQty : 0.0;

    for (final item in items) {
      for (int g = 0; g < item.quantity; g++) {
        final insertedRow = await _supabase
            .from('inventory_items')
            .insert({
              'title': item.gemType.isNotEmpty ? item.gemType : 'Unnamed Gem',
              'gem_type': item.gemType,
              'status': 'draft',
              'supplier_id': supplierId,
              'cost_price': costPerGem,
              'sale_price': 0.0,
              'purchase_id': purchaseId,
              'branch_id': branchId,
              'location_id': destinationLocationId,
              'sku': '',
              'variety': '',
              'origin_country': '',
              'origin_region': '',
              'shape': '',
              'cut_type': '',
              'weight_value': 0.0,
              'weight_unit': 'ct',
              'quantity': 1,
              'barcode': '',
              'qr_code': '',
              'notes': item.notes,
              'image_urls': [],
            })
            .select('id')
            .single();

        // Record initial placement movement (null → destination).
        if (destinationLocationId != null) {
          await _supabase.from('item_movements').insert({
            'inventory_item_id': insertedRow['id'],
            'from_location_id': null,
            'to_location_id': destinationLocationId,
            'reason': 'Initial placement from purchase',
          });
        }
      }
    }
  }

  // ── Dashboard stats ───────────────────────────────────────────────────────

  /// Returns the sum of total_cost across all purchases.
  Future<double> getTotalSpent() async {
    final response =
        await _supabase.from('purchases').select('total_cost');
    return (response as List).fold<double>(
      0.0,
      (sum, row) =>
          sum + ((row['total_cost'] as num?) ?? 0).toDouble(),
    );
  }
}
