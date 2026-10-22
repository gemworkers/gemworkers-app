import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/maker.dart';

/// Owner-managed maker list (sql/makers_setup.sql). Everyone may read; RLS
/// lets only the owner insert / update / delete.
class MakerRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // Maker photos live next to stone photos, under makers/.
  static const String _bucket = 'inventory-images';

  Future<List<Maker>> getMakers() async {
    final response = await supabase.from('makers').select().order('name');
    return response.map<Maker>((row) => Maker.fromMap(row)).toList();
  }

  Future<Maker> addMaker(Maker maker) async {
    final response =
        await supabase.from('makers').insert(maker.toMap()).select().single();
    return Maker.fromMap(response);
  }

  Future<void> updateMaker(String id, Maker maker) async {
    await supabase.from('makers').update(maker.toMap()).eq('id', id);
  }

  /// Stones credited to this maker keep existing; their maker becomes empty.
  Future<void> deleteMaker(String id) async {
    await supabase.from('makers').delete().eq('id', id);
  }

  /// Number of stones credited to [id] (owner sees all stones).
  Future<int> countStones(String id) async {
    final response =
        await supabase.from('inventory_items').select('id').eq('maker_id', id);
    return response.length;
  }

  Future<String> uploadPhoto(Uint8List bytes, String originalName) async {
    final ext = originalName.contains('.')
        ? originalName.split('.').last.toLowerCase()
        : 'jpg';
    final path = 'makers/${DateTime.now().millisecondsSinceEpoch}.$ext';
    await supabase.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: ext == 'png'
                ? 'image/png'
                : ext == 'webp'
                    ? 'image/webp'
                    : 'image/jpeg',
          ),
        );
    return supabase.storage.from(_bucket).getPublicUrl(path);
  }
}
