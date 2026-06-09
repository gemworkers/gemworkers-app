class Location {
  final String? id;
  final String branchId;
  final String name;
  final String code; // Short label used for QR codes
  final String? parentId; // Self-reference for tree structure
  final String type; // 'country'|'shop'|'zone'|'unit'|'slot'|'other'
  final bool isStatusZone; // true = this location represents a workflow stage
  final String managerNote;
  final DateTime? createdAt;

  // Tree support — populated by LocationRepository, not stored in DB.
  final List<Location> children;
  // Human-readable path from root, e.g. "Shop › Storage › Shelf A".
  // Populated by LocationRepository.getBreadcrumb().
  final String breadcrumb;

  const Location({
    this.id,
    required this.branchId,
    required this.name,
    required this.code,
    this.parentId,
    this.type = 'other',
    this.isStatusZone = false,
    this.managerNote = '',
    this.createdAt,
    this.children = const [],
    this.breadcrumb = '',
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id']?.toString(),
      branchId: map['branch_id']?.toString() ?? '',
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      parentId: map['parent_id']?.toString(),
      type: map['type'] ?? 'other',
      isStatusZone: (map['is_status_zone'] ?? false) as bool,
      managerNote: map['manager_note'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'branch_id': branchId,
        'name': name,
        'code': code,
        'parent_id': parentId,
        'type': type,
        'is_status_zone': isStatusZone,
        'manager_note': managerNote,
      };

  Location copyWith({
    String? id,
    String? branchId,
    String? name,
    String? code,
    Object? parentId = _omitted,
    String? type,
    bool? isStatusZone,
    String? managerNote,
    DateTime? createdAt,
    List<Location>? children,
    String? breadcrumb,
  }) {
    return Location(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      name: name ?? this.name,
      code: code ?? this.code,
      parentId:
          identical(parentId, _omitted) ? this.parentId : parentId as String?,
      type: type ?? this.type,
      isStatusZone: isStatusZone ?? this.isStatusZone,
      managerNote: managerNote ?? this.managerNote,
      createdAt: createdAt ?? this.createdAt,
      children: children ?? this.children,
      breadcrumb: breadcrumb ?? this.breadcrumb,
    );
  }
}

const _omitted = Object();
