import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/supabase_service.dart';
import '../core/utils/photo_jpeg/photo_jpeg.dart';

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

  /// [before] = the stone as it was when the Edit page opened: stock, status
  /// and listed are only saved when the user changed them, so a sale made
  /// meanwhile (sql/quantity_listings.sql) is never overwritten.
  Future<void> updateItem(String id, InventoryItem item, {InventoryItem? before}) async {
    final map = item.toMap();
    // A general save never clears the seller: a missing sellerId on the model
    // must not orphan the stone (it would vanish from the store).
    if (map['seller_id'] == null) map.remove('seller_id');
    if (before != null) {
      if (item.quantity == before.quantity) map.remove('quantity');
      if (item.status == before.status) map.remove('status');
      if (item.isListed == before.isListed) map.remove('is_listed');
    }
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
  ///
  /// Listings with several in stock (sql/quantity_listings.sql): [units] sold
  /// elsewhere come off the stock; the listing is sold only when none are left.
  /// The update only applies if the stock is still what the screen showed.
  Future<bool> markSoldElsewhere(String id, String notes, {int units = 1, int inStock = 1}) async {
    final left = inStock - units;
    final rows = await supabase
        .from('inventory_items')
        .update(left > 0
            ? {'quantity': left, 'notes': notes}
            : {'status': 'sold', 'is_listed': false, 'notes': notes})
        .eq('id', id)
        .eq('status', 'available')
        .eq('quantity', inStock)
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
  // Photos live on Bunny (media.gemworkers.com, sql/media_bunny.sql) and go
  // through the Edge Function `media`, which checks the stone is the caller's.
  // Older photos may still be Supabase Storage URLs until they are moved.

  static const String mediaHost = 'https://media.gemworkers.com';
  static const String _streamHost = 'https://vz-192edce1-fc4.b-cdn.net';

  Future<Map<String, String>> _authHeaders() async {
    final token = supabase.auth.currentSession?.accessToken;
    if (token == null) throw Exception('Please log in again');
    return {'Authorization': 'Bearer $token', 'apikey': SupabaseService.supabaseKey};
  }

  Uri get _mediaFn => Uri.parse('${SupabaseService.supabaseUrl}/functions/v1/media');

  Future<Map<String, dynamic>> _media(Map<String, dynamic> body) async {
    final res = await http.post(_mediaFn,
        headers: {...await _authHeaders(), 'Content-Type': 'application/json'},
        body: jsonEncode(body));
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) throw Exception(data['error'] ?? 'Media error ${res.statusCode}');
    return data;
  }

  /// Uploads the photo (full + small card copy, both JPEG) and returns its URL.
  Future<String> uploadImage(
    String itemId,
    Uint8List bytes,
    String originalName,
  ) async {
    final jpegs = await photoJpegs(bytes);
    final req = http.MultipartRequest('POST', _mediaFn)
      ..headers.addAll(await _authHeaders())
      ..fields['action'] = 'photo'
      ..fields['item_id'] = itemId
      ..files.add(http.MultipartFile.fromBytes('file', jpegs.full, filename: 'photo.jpg'))
      ..files.add(http.MultipartFile.fromBytes('card', jpegs.card, filename: 'card.jpg'));
    final res = await http.Response.fromStream(await req.send());
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200) throw Exception(data['error'] ?? 'Photo upload failed');
    return data['url'] as String;
  }

  Future<void> updateItemImages(String id, List<String> imageUrls) async {
    await supabase
        .from('inventory_items')
        .update({'image_urls': imageUrls})
        .eq('id', id);
  }

  /// Removes the file (Bunny or old Supabase Storage) and the URL from the
  /// item's image list.
  Future<void> deleteImageByUrl(
      String id, String url, List<String> currentUrls) async {
    if (url.startsWith('$mediaHost/')) {
      await _media({'action': 'photo_delete', 'item_id': id, 'url': url});
    } else {
      const fragment = '/storage/v1/object/public/$_bucket/';
      final idx = url.indexOf(fragment);
      if (idx != -1) {
        final path = Uri.decodeFull(url.substring(idx + fragment.length));
        await supabase.storage.from(_bucket).remove([path]);
      }
    }

    final updated = currentUrls.where((u) => u != url).toList();
    await updateItemImages(id, updated);
  }

  // ── Video (Bunny Stream, sql/media_bunny.sql) ─────────────────────────────
  // The admin uploads straight to Bunny (TUS, 5 MB pieces) with a pass from
  // the `media` function. Bunny then encodes for a few minutes; meanwhile the
  // stone has video_pending, and the store keeps showing photos only.

  static const String _videoBucket = 'inventory-videos';
  static const String _videoFragment =
      '/storage/v1/object/public/$_videoBucket/';

  /// True for a video uploaded by us (Bunny, or an older Supabase one) —
  /// not an old YouTube/Vimeo link.
  static bool isUploadedVideo(String? url) =>
      url != null && (url.startsWith('$_streamHost/') || url.contains(_videoFragment));

  /// Uploads the video to Bunny. Returns null: the playable address is set on
  /// the stone by the `media` function once Bunny has finished encoding.
  Future<String?> uploadVideo(
    String itemId,
    Uint8List bytes,
    String originalName, {
    void Function(double progress)? onProgress,
  }) async {
    final pass = await _media({'action': 'video_create', 'item_id': itemId});
    final ext = originalName.contains('.') ? originalName.split('.').last.toLowerCase() : 'mp4';
    final type = switch (ext) { 'mov' => 'video/quicktime', 'webm' => 'video/webm', _ => 'video/mp4' };
    final auth = {
      'AuthorizationSignature': pass['signature'] as String,
      'AuthorizationExpire': '${pass['expire']}',
      'VideoId': pass['video_id'] as String,
      'LibraryId': pass['library_id'] as String,
      'Tus-Resumable': '1.0.0',
    };
    final endpoint = Uri.parse('https://video.bunnycdn.com/tusupload');
    final create = await http.post(endpoint, headers: {
      ...auth,
      'Upload-Length': '${bytes.length}',
      'Upload-Metadata': 'filetype ${base64Encode(utf8.encode(type))},title ${base64Encode(utf8.encode(itemId))}',
    });
    final location = create.headers['location'];
    if (create.statusCode != 201 || location == null) {
      throw Exception('Video upload could not start (${create.statusCode})');
    }
    final target = endpoint.resolve(location);
    const piece = 5 * 1024 * 1024;
    var offset = 0;
    var retries = 0;
    while (offset < bytes.length) {
      final end = (offset + piece < bytes.length) ? offset + piece : bytes.length;
      try {
        final res = await http.patch(target,
            headers: {...auth, 'Upload-Offset': '$offset', 'Content-Type': 'application/offset+octet-stream'},
            body: bytes.sublist(offset, end));
        if (res.statusCode != 204) throw Exception('Video upload stopped (${res.statusCode})');
        offset = int.tryParse(res.headers['upload-offset'] ?? '') ?? end;
        retries = 0;
        onProgress?.call(offset / bytes.length);
      } catch (e) {
        // Weak connection: ask Bunny how far it got and carry on from there.
        if (++retries > 3) rethrow;
        await Future<void>.delayed(Duration(seconds: 2 * retries));
        final head = await http.head(target, headers: auth);
        offset = int.tryParse(head.headers['upload-offset'] ?? '') ?? offset;
      }
    }
    return null;
  }

  /// Asks Bunny whether the stone's pending video is ready; returns its
  /// playable URL once it is ('processing' / 'failed' / 'none' otherwise).
  Future<({String status, String? videoUrl})> checkVideo(String itemId) async {
    final r = await _media({'action': 'video_check', 'item_id': itemId});
    return (status: r['status'] as String, videoUrl: r['video_url'] as String?);
  }

  /// Deletes an uploaded video (Bunny or older Supabase file) and any video
  /// still encoding; ignores old YouTube/Vimeo links.
  Future<void> deleteUploadedVideo(String? url, {String? itemId}) async {
    if (itemId != null && (url == null || url.startsWith('$_streamHost/'))) {
      await _media({'action': 'video_delete', 'item_id': itemId, 'url': url});
      return;
    }
    if (url == null || !url.contains(_videoFragment)) return;
    final idx = url.indexOf(_videoFragment);
    final path = Uri.decodeFull(url.substring(idx + _videoFragment.length));
    await supabase.storage.from(_videoBucket).remove([path]);
  }

  Future<void> updateItemVideo(String id, String? videoUrl) async {
    await supabase
        .from('inventory_items')
        .update({'video_url': videoUrl})
        .eq('id', id);
  }
}
