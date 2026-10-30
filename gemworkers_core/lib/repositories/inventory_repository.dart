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

  /// The seller's most recently added item of [productType] (remembered
  /// defaults on Add stone). Null when they have none yet.
  Future<InventoryItem?> getLastItemOfType(String sellerId, String productType) async {
    final row = await supabase
        .from('inventory_items')
        .select('*, suppliers(name)')
        .eq('seller_id', sellerId)
        .eq('product_type', productType)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row == null ? null : InventoryItem.fromMap(row);
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
    final map = item.toMap();
    // A general save never clears the seller: a missing sellerId on the model
    // must not orphan the stone (it would vanish from the store).
    if (map['seller_id'] == null) map.remove('seller_id');
    await supabase
        .from('inventory_items')
        .update(map)
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
  /// Owner only (DB trigger refuses anyone else). null = unknown / none.
  /// Protected materials answers (sql/protected_materials.sql). Nulls clear them.
  Future<void> setItemCompliance(String id, {
    String? cites, String? permitNo, String? diamond, String? kimberleyNo,
  }) async {
    await supabase.rpc('set_item_compliance', params: {
      'p_item_id': id,
      'p_cites': cites,
      'p_permit': permitNo,
      'p_diamond': diamond,
      'p_kimberley': kimberleyNo,
    });
  }

  Future<void> setItemMaker(String id, String? makerId) async {
    await supabase
        .from('inventory_items')
        .update({'maker_id': makerId})
        .eq('id', id);
  }

  // Owner only (trigger inventory_featured_owner_only keeps the old value for others).
  Future<void> setItemFeatured(String id, bool featured) async {
    await supabase
        .from('inventory_items')
        .update({'is_featured': featured})
        .eq('id', id);
  }

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

  /// Sets is_listed=true and records the sale method, selling price, listed_at,
  /// and optional shipping details. sellingPrice may be null for accept_offers stones.
  /// For a seller (not owner) the DB turns a new listing into a request that
  /// waits for owner approval (sql/listing_approval.sql); the details are saved.
  /// Shipping params are named optional — caller passes only what the user filled in.
  Future<void> listItem(
    String id,
    double? sellingPrice,
    String saleMethod, {
    String? courier,
    double? shippingCost,
    int? deliveryDaysMin,
    int? deliveryDaysMax,
    int? prepDays,
    String? videoUrl,
  }) async {
    await supabase.from('inventory_items').update({
      'is_listed': true,
      // Sending (again) for approval or listing clears an old rejection note.
      'listing_review_note': null,
      'selling_price': sellingPrice,
      'sale_method': saleMethod,
      'listed_at': DateTime.now().toIso8601String(),
      'courier': courier,
      'shipping_cost': shippingCost,
      'delivery_days_min': deliveryDaysMin,
      'delivery_days_max': deliveryDaysMax,
      'prep_days': prepDays,
      'video_url': videoUrl,
    }).eq('id', id);
  }

  /// Clears is_listed (and any pending listing request); keeps selling_price
  /// so it can be reused next time.
  Future<void> unlistItem(String id) async {
    await supabase.from('inventory_items').update({
      'is_listed': false,
      'listed_at': null,
      'listing_requested_at': null,
    }).eq('id', id);
  }

  /// Owner approves a seller's listing request: the stone goes live. The DB
  /// trigger clears listing_requested_at once is_listed is true.
  Future<void> approveListing(String id) async {
    await supabase.from('inventory_items').update({
      'is_listed': true,
      'listed_at': DateTime.now().toIso8601String(),
      'listing_review_note': null,
    }).eq('id', id);
  }

  /// Owner rejects, or the seller withdraws, a listing request. The stone
  /// stays a draft. [note] is the owner's optional reason, shown to the
  /// seller in the admin and in their email (sql/listing_decision_emails.sql).
  Future<void> clearListingRequest(String id, {String? note}) async {
    final text = note?.trim() ?? '';
    await supabase.from('inventory_items').update({
      'listing_requested_at': null,
      'listing_review_note': text.isEmpty ? null : text,
    }).eq('id', id);
  }

  /// Seller listing requests waiting for the owner.
  Future<int> getAwaitingApprovalCount() async {
    final response = await supabase
        .from('inventory_items')
        .select('id')
        .eq('is_listed', false)
        .eq('status', 'available')
        .not('listing_requested_at', 'is', null);
    return response.length;
  }

  /// Marks a batch of items as sold and removes them from the marketplace.
  /// "Sold elsewhere" (Etsy, Instagram, in person): off GemWorkers, status
  /// sold — NOT a GemWorkers sale (no order, invoice or fee). Only while the
  /// stone is available (never while a GemWorkers buyer is paying for it).
  /// Returns false when the stone was not available.
  Future<bool> markSoldElsewhere(String id, String notes) async {
    final rows = await supabase
        .from('inventory_items')
        .update({'status': 'sold', 'is_listed': false, 'notes': notes})
        .eq('id', id)
        .eq('status', 'available')
        .select('id');
    return (rows as List).isNotEmpty;
  }

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

  // ── Video (Etsy-style upload, sql/storage_inventory_videos.sql) ─────────────

  static const String _videoBucket = 'inventory-videos';
  static const String _videoFragment =
      '/storage/v1/object/public/$_videoBucket/';

  /// True for a video uploaded to our storage (vs an old YouTube/Vimeo link).
  static bool isUploadedVideo(String? url) =>
      url != null && url.contains(_videoFragment);

  /// Uploads into the item's own folder (sellers may only upload into their
  /// own stones' folders) and returns the public URL.
  Future<String> uploadVideo(
    String itemId,
    Uint8List bytes,
    String originalName,
  ) async {
    final ext = originalName.contains('.')
        ? originalName.split('.').last.toLowerCase()
        : 'mp4';
    final path = '$itemId/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await supabase.storage.from(_videoBucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: switch (ext) {
              'mov' => 'video/quicktime',
              'webm' => 'video/webm',
              _ => 'video/mp4',
            },
          ),
        );
    return supabase.storage.from(_videoBucket).getPublicUrl(path);
  }

  /// Deletes an uploaded video file; ignores old YouTube/Vimeo links.
  Future<void> deleteUploadedVideo(String? url) async {
    if (!isUploadedVideo(url)) return;
    final idx = url!.indexOf(_videoFragment);
    final path = Uri.decodeFull(url.substring(idx + _videoFragment.length));
    await supabase.storage.from(_videoBucket).remove([path]);
  }

  Future<void> updateItemVideo(String id, String? videoUrl) async {
    await supabase
        .from('inventory_items')
        .update({'video_url': videoUrl})
        .eq('id', id);
  }

  static String _mimeType(String ext) => switch (ext) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        'heic' || 'heif' => 'image/heic',
        _ => 'image/jpeg',
      };
}
