class Location {
  final String? id;
  final String sellerId;
  final String name;
  final String code;
  final String? parentId;
  final String type;
  final bool isStatusZone;
  final String managerNote;
  final int? slotCount;
  final DateTime? createdAt;

  // Tree support — populated by LocationRepository, not stored in DB.
  final List<Location> children;
  // Human-readable path from root, e.g. "Shop › Storage › Shelf A".
  // Populated by LocationRepository.getBreadcrumb().
  final String breadcrumb;

  const Location({
    this.id,
    required this.sellerId,
    required this.name,
    required this.code,
    this.parentId,
    this.type = 'other',
    this.isStatusZone = false,
    this.managerNote = '',
    this.slotCount,
    this.createdAt,
    this.children = const [],
    this.breadcrumb = '',
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id']?.toString(),
      sellerId: map['seller_id']?.toString() ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      parentId: map['parent_id']?.toString(),
      type: map['type'] ?? 'other',
      isStatusZone: (map['is_status_zone'] ?? false) as bool,
      managerNote: map['manager_note'] ?? '',
      slotCount: map['slot_count'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'seller_id': sellerId,
        'name': name,
        'code': code,
        'parent_id': parentId,
        'type': type,
        'is_status_zone': isStatusZone,
        'manager_note': managerNote,
        'slot_count': slotCount,
      };

  Location copyWith({
    String? id,
    String? sellerId,
    String? name,
    String? code,
    Object? parentId = _omitted,
    String? type,
    bool? isStatusZone,
    String? managerNote,
    Object? slotCount = _omitted,
    DateTime? createdAt,
    List<Location>? children,
    String? breadcrumb,
  }) {
    return Location(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      name: name ?? this.name,
      code: code ?? this.code,
      parentId:
          identical(parentId, _omitted) ? this.parentId : parentId as String?,
      type: type ?? this.type,
      isStatusZone: isStatusZone ?? this.isStatusZone,
      managerNote: managerNote ?? this.managerNote,
      slotCount:
          identical(slotCount, _omitted) ? this.slotCount : slotCount as int?,
      createdAt: createdAt ?? this.createdAt,
      children: children ?? this.children,
      breadcrumb: breadcrumb ?? this.breadcrumb,
    );
  }
}

const _omitted = Object();
