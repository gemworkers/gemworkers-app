import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Inserts the item and returns the server-created row (with assigned id).
  Future<InventoryItem> addItem(InventoryItem item) async {
    final response = await supabase
        .from('inventory_items')
        .insert(item.toMap())
        .select()
        .single();
    return InventoryItem.fromMap(response);
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
