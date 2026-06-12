import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/user_profile_service.dart';
import '../models/purchase.dart';

class PurchaseRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// List view — joins supplier name but does NOT load purchase_items.
  Future<List<Purchase>> getPurchases({String? supplierId}) async {
    final query = _supabase.from('purchases').select(
        'id, purchase_number, purchase_date, gem_cost, shipping_cost, '
        'customs_cost, other_fees, total_cost, notes, supplier_id, seller_id, '
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
  /// inventory item per line (see _createInventoryItems for per-type behaviour).
  Future<Purchase> addPurchase(
    Purchase purchase, {
    bool createInventoryItems = true,
    String? destinationLocationId,
  }) async {
    final purchaseMap = purchase.toMap();
    purchaseMap['seller_id'] ??= UserProfileService.instance.effectiveSellerId;
    final sellerId = purchaseMap['seller_id'] as String;

    final row = await _supabase
        .from('purchases')
        .insert(purchaseMap)
        .select()
        .single();
    final purchaseId = row['id'] as String;

    final itemsWithCosts = _allocateCosts(purchase);
    for (final item in itemsWithCosts) {
      await _supabase
          .from('purchase_items')
          .insert({...item.toMap(), 'purchase_id': purchaseId});
    }

    if (createInventoryItems && itemsWithCosts.isNotEmpty) {
      await _createInventoryItems(
        purchaseId: purchaseId,
        supplierId: purchase.supplierId,
        sellerId: sellerId,
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

  /// Divides the total landed cost equally across every unit in the purchase.
  /// Each line's allocatedCost = line.quantity × costPerUnit.
  /// For lots, quantity = approxCount — so stones share the cost proportionally.
  List<PurchaseItem> _allocateCosts(Purchase purchase) {
    final items = purchase.items;
    if (items.isEmpty) return [];

    final totalQty = items.fold(0, (sum, i) => sum + i.quantity);
    if (totalQty == 0) {
      return items.map((i) => i.copyWith(allocatedCost: 0)).toList();
    }

    final costPerUnit = purchase.totalCost / totalQty;
    return items
        .map((item) =>
            item.copyWith(allocatedCost: item.quantity * costPerUnit))
        .toList();
  }

  // ── Auto-create inventory ─────────────────────────────────────────────────

  /// Creates one draft inventory_item per purchase line.
  ///
  /// - individual → 1 item, quantity=1, full gem details, cost=allocatedCost
  /// - multiple   → 1 item, quantity=count, title=itemName, cost=allocatedCost/count
  /// - lot        → 1 placeholder item, is_unsorted_lot=true, lot_remaining_count=approxCount
  Future<void> _createInventoryItems({
    required String purchaseId,
    required String? supplierId,
    required String sellerId,
    required List<PurchaseItem> items,
    String? destinationLocationId,
  }) async {
    for (final item in items) {
      final Map<String, dynamic> row;

      if (item.lineType == 'individual') {
        row = {
          'title': item.gemType.isNotEmpty ? item.gemType : 'Unnamed Gem',
          'gem_type': item.gemType,
          'variety': item.variety,
          'weight_value': item.weightValue ?? 0.0,
          'weight_unit': item.weightUnit,
          'origin_country': item.originCountry,
          'origin_region': '',
          'quantity': 1,
          'cost_price': item.allocatedCost,
          'is_unsorted_lot': false,
          'lot_remaining_count': null,
        };
      } else if (item.lineType == 'multiple') {
        row = {
          'title': item.itemName.isNotEmpty ? item.itemName : 'Unnamed Item',
          'gem_type': item.gemType,
          'variety': '',
          'weight_value': 0.0,
          'weight_unit': 'ct',
          'origin_country': '',
          'origin_region': '',
          'quantity': item.quantity,
          'cost_price':
              item.quantity > 0 ? item.allocatedCost / item.quantity : 0.0,
          'is_unsorted_lot': false,
          'lot_remaining_count': null,
        };
      } else {
        // lot
        final title = item.itemName.isNotEmpty
            ? item.itemName
            : (item.gemType.isNotEmpty
                ? 'Mixed ${item.gemType} Lot'
                : 'Unsorted Lot');
        row = {
          'title': title,
          'gem_type': item.gemType,
          'variety': '',
          'weight_value': 0.0,
          'weight_unit': 'ct',
          'origin_country': '',
          'origin_region': '',
          'quantity': 1,
          'cost_price': item.allocatedCost,
          'is_unsorted_lot': true,
          'lot_remaining_count': item.approxCount,
        };
      }

      final insertedRow = await _supabase
          .from('inventory_items')
          .insert({
            ...row,
            'status': 'draft',
            'supplier_id': supplierId,
            'purchase_id': purchaseId,
            'seller_id': sellerId,
            'location_id': destinationLocationId,
            'sku': '',
            'shape': '',
            'cut_type': '',
            'sale_price': 0.0,
            'barcode': '',
            'qr_code': '',
            'notes': item.notes,
            'image_urls': [],
          })
          .select('id')
          .single();

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

  // ── Dashboard stats ───────────────────────────────────────────────────────

  /// Returns the sum of total_cost across all purchases.
  /// Pass [sellerId] to scope to a single seller.
  Future<double> getTotalSpent({String? sellerId}) async {
    final query = _supabase.from('purchases').select('total_cost');
    final response = sellerId != null
        ? await query.eq('seller_id', sellerId)
        : await query;
    return (response as List).fold<double>(
      0.0,
      (sum, row) =>
          sum + ((row['total_cost'] as num?) ?? 0).toDouble(),
    );
  }
}
