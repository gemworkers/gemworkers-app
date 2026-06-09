import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/item_movement.dart';

class ItemMovementRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Movement history for one item, oldest first.
  Future<List<ItemMovement>> getMovementsForItem(String itemId) async {
    final response = await _supabase
        .from('item_movements')
        .select(
          '*, '
          'from_location:from_location_id(name), '
          'to_location:to_location_id(name)',
        )
        .eq('inventory_item_id', itemId)
        .order('moved_at');
    return response
        .map<ItemMovement>((row) => ItemMovement.fromMap(row))
        .toList();
  }

  /// Appends a new movement record. Pass null for from/to to represent
  /// "no previous location" or "removed from inventory".
  Future<void> recordMovement({
    required String inventoryItemId,
    String? fromLocationId,
    String? toLocationId,
    required String reason,
    String note = '',
  }) async {
    await _supabase.from('item_movements').insert({
      'inventory_item_id': inventoryItemId,
      'from_location_id': fromLocationId,
      'to_location_id': toLocationId,
      'reason': reason,
      'note': note,
    });
  }
}
