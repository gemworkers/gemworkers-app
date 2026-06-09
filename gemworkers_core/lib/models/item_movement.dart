class ItemMovement {
  final String? id;
  final String inventoryItemId;
  final String? fromLocationId;
  final String? toLocationId;

  // Join-derived — populated when queried with location joins.
  final String fromLocationName;
  final String toLocationName;

  final DateTime movedAt;
  final String reason;
  final String note;

  const ItemMovement({
    this.id,
    required this.inventoryItemId,
    this.fromLocationId,
    this.toLocationId,
    this.fromLocationName = '',
    this.toLocationName = '',
    required this.movedAt,
    this.reason = '',
    this.note = '',
  });

  factory ItemMovement.fromMap(Map<String, dynamic> map) {
    final fromLoc = map['from_location'] as Map<String, dynamic>?;
    final toLoc = map['to_location'] as Map<String, dynamic>?;
    return ItemMovement(
      id: map['id']?.toString(),
      inventoryItemId: map['inventory_item_id']?.toString() ?? '',
      fromLocationId: map['from_location_id']?.toString(),
      toLocationId: map['to_location_id']?.toString(),
      fromLocationName: fromLoc?['name']?.toString() ?? '',
      toLocationName: toLoc?['name']?.toString() ?? '',
      movedAt: map['moved_at'] != null
          ? DateTime.parse(map['moved_at'])
          : DateTime.now(),
      reason: map['reason'] ?? '',
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'inventory_item_id': inventoryItemId,
        'from_location_id': fromLocationId,
        'to_location_id': toLocationId,
        'reason': reason,
        'note': note,
      };
}
