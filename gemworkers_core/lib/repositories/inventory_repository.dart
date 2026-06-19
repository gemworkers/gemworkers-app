import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/user_profile_service.dart';
import '../models/inventory_item.dart';

class InventoryRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  static const String _bucket = 'inventory-images';

  // ── Inventory CRUD ────────────────────────────────────────────────────────

  Future<List<InventoryItem>> getItems() async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .order('created_at', ascending: false);

    return response
        .map<InventoryItem>((row) => InventoryItem.fromMap(row))
        .toList();
  }

  Future<List<InventoryItem>> getItemsBySupplier(String supplierId) async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .eq('supplier_id', supplierId)
        .order('created_at', ascending: false);

    return response
        .map<InventoryItem>((row) => InventoryItem.fromMap(row))
        .toList();
  }

  Future<InventoryItem> getItem(String id) async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .eq('id', id)
        .single();
    return InventoryItem.fromMap(response);
  }

  Future<List<InventoryItem>> getItemsByPurchase(String purchaseId) async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .eq('purchase_id', purchaseId)
        .order('created_at');
    return response
        .map<InventoryItem>((row) => InventoryItem.fromMap(row))
        .toList();
  }

  /// Inserts the item and returns the server-created row (with assigned id).
  /// seller_id defaults to kCurrentSellerId (see seller_service.dart) when not set.
  Future<InventoryItem> addItem(InventoryItem item) async {
    final map = item.toMap();
    map['seller_id'] ??= UserProfileService.instance.effectiveSellerId;
    final response = await supabase
        .from('inventory_items')
        .insert(map)
        .select()
        .single();
    return InventoryItem.fromMap(response);
  }

  /// Items in a given location and all its descendants.
  /// Pass [locationIds] as the pre-computed set from LocationRepository.getDescendantIds().
  Future<List<InventoryItem>> getItemsByLocations(
      List<String> locationIds) async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .inFilter('location_id', locationIds)
        .order('created_at', ascending: false);
    return response
        .map<InventoryItem>((row) => InventoryItem.fromMap(row))
        .toList();
  }

  Future<void> updateItem(String id, InventoryItem item) async {
    await supabase
        .from('inventory_items')
        .update(item.toMap())
        .eq('id', id);
  }

  Future<void> deleteItem(String id) async {
    await supabase.from('inventory_items').delete().eq('id', id);
  }

  // ── Lot sorting ───────────────────────────────────────────────────────────

  /// All stones sorted from a given lot, oldest first.
  Future<List<InventoryItem>> getLotChildren(String lotId) async {
    final response = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .eq('parent_lot_id', lotId)
        .order('created_at');
    return response
        .map<InventoryItem>((r) => InventoryItem.fromMap(r))
        .toList();
  }

  /// Creates a child stone from a lot and decrements the lot's stone count by 1.
  Future<InventoryItem> addLotStone({
    required InventoryItem stone,
    required String lotId,
    required int lotRemainingCount,
  }) async {
    final created = await addItem(stone);
    await supabase
        .from('inventory_items')
        .update({
          'lot_remaining_count':
              (lotRemainingCount - 1).clamp(0, lotRemainingCount),
        })
        .eq('id', lotId);
    return created;
  }

  /// Deletes a child stone and restores one stone to the lot's remaining count.
  Future<void> removeLotStone({
    required String stoneId,
    required String lotId,
    required int lotRemainingCount,
  }) async {
    await deleteItem(stoneId);
    await supabase
        .from('inventory_items')
        .update({'lot_remaining_count': lotRemainingCount + 1})
        .eq('id', lotId);
  }

  /// Patches only the cost_price field of an item.
  Future<void> updateItemCost(String id, double costPrice) async {
    await supabase
        .from('inventory_items')
        .update({'cost_price': costPrice})
        .eq('id', id);
  }

  /// Marks an unsorted lot as fully sorted (status = 'sorted').
  Future<void> markLotSorted(String lotId) async {
    await supabase
        .from('inventory_items')
        .update({'status': 'sorted'})
        .eq('id', lotId);
  }

  /// Batch-assigns a new location (or clears it) for a list of item IDs.
  Future<void> batchSetLocation(
      List<String> itemIds, String? locationId) async {
    if (itemIds.isEmpty) return;
    await supabase
        .from('inventory_items')
        .update({'location_id': locationId})
        .inFilter('id', itemIds);
  }

  /// Sets is_listed=true and records the sale method, selling price, and listed_at.
  /// sellingPrice may be null for accept_offers-only stones (no fixed price).
  Future<void> listItem(String id, double? sellingPrice, String saleMethod) async {
    await supabase.from('inventory_items').update({
      'is_listed': true,
      'selling_price': sellingPrice,
      'sale_method': saleMethod,
      'listed_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }

  /// Clears is_listed; keeps selling_price so it can be reused next time.
  Future<void> unlistItem(String id) async {
    await supabase.from('inventory_items').update({
      'is_listed': false,
      'listed_at': null,
    }).eq('id', id);
  }

  /// Marks a batch of items as sold and removes them from the marketplace.
  Future<void> markSold(List<String> ids) async {
    if (ids.isEmpty) return;
    await supabase
        .from('inventory_items')
        .update({'status': 'sold', 'is_listed': false})
        .inFilter('id', ids);
  }

  // ── Image management ──────────────────────────────────────────────────────

  Future<String> uploadImage(
    String itemId,
    Uint8List bytes,
    String originalName,
  ) async {
    final ext = originalName.contains('.')
        ? originalName.split('.').last.toLowerCase()
        : 'jpg';
    final path = '$itemId/${DateTime.now().millisecondsSinceEpoch}.$ext';

    await supabase.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: _mimeType(ext)),
        );

    return supabase.storage.from(_bucket).getPublicUrl(path);
  }

  Future<void> updateItemImages(String id, List<String> imageUrls) async {
    await supabase
        .from('inventory_items')
        .update({'image_urls': imageUrls})
        .eq('id', id);
  }

  /// Removes the file from Storage and the URL from the item's image list.
  Future<void> deleteImageByUrl(
      String id, String url, List<String> currentUrls) async {
    const fragment = '/storage/v1/object/public/$_bucket/';
    final idx = url.indexOf(fragment);
    if (idx != -1) {
      final path = Uri.decodeFull(url.substring(idx + fragment.length));
      await supabase.storage.from(_bucket).remove([path]);
    }

    final updated = currentUrls.where((u) => u != url).toList();
    await updateItemImages(id, updated);
  }

  static String _mimeType(String ext) => switch (ext) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' || 'heif' => 'image/heic',
        _ => 'image/jpeg',
      };
}
