class Branch {
  final String? id;
  final String name;
  final String country;
  final String contactNote;
  final String status; // 'active' | 'suspended'
  final double? commissionRate; // stored as decimal, e.g. 0.05 = 5 %
  final double? userFee;
  final String? userFeePeriod; // 'monthly' | 'annual' | 'weekly'
  final double? startingFee;
  final DateTime? joinedDate;
  final String notes;
  final DateTime? createdAt;

  // Rollup counts — loaded separately by repository, not from branches table.
  final int inventoryCount;
  final int salesCount;

  const Branch({
    this.id,
    required this.name,
    required this.country,
    this.contactNote = '',
    this.status = 'active',
    this.commissionRate,
    this.userFee,
    this.userFeePeriod,
    this.startingFee,
    this.joinedDate,
    this.notes = '',
    this.createdAt,
    this.inventoryCount = 0,
    this.salesCount = 0,
  });

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      contactNote: map['contact_note'] ?? '',
      status: map['status'] ?? 'active',
      commissionRate: (map['commission_rate'] as num?)?.toDouble(),
      userFee: (map['user_fee'] as num?)?.toDouble(),
      userFeePeriod: map['user_fee_period']?.toString(),
      startingFee: (map['starting_fee'] as num?)?.toDouble(),
      joinedDate: map['joined_date'] != null
          ? DateTime.parse(map['joined_date'].toString())
          : null,
      notes: map['notes'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'country': country,
        'contact_note': contactNote,
        'status': status,
        'commission_rate': commissionRate,
        'user_fee': userFee,
        'user_fee_period': userFeePeriod,
        'starting_fee': startingFee,
        'joined_date': joinedDate != null
            ? '${joinedDate!.year.toString().padLeft(4, '0')}-'
                '${joinedDate!.month.toString().padLeft(2, '0')}-'
                '${joinedDate!.day.toString().padLeft(2, '0')}'
            : null,
        'notes': notes,
      };

  Branch copyWith({
    String? id,
    String? name,
    String? country,
    String? contactNote,
    String? status,
    Object? commissionRate = _omitted,
    Object? userFee = _omitted,
    Object? userFeePeriod = _omitted,
    Object? startingFee = _omitted,
    Object? joinedDate = _omitted,
    String? notes,
    DateTime? createdAt,
    int? inventoryCount,
    int? salesCount,
  }) {
    return Branch(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      contactNote: contactNote ?? this.contactNote,
      status: status ?? this.status,
      commissionRate: identical(commissionRate, _omitted)
          ? this.commissionRate
          : commissionRate as double?,
      userFee: identical(userFee, _omitted)
          ? this.userFee
          : userFee as double?,
      userFeePeriod: identical(userFeePeriod, _omitted)
          ? this.userFeePeriod
          : userFeePeriod as String?,
      startingFee: identical(startingFee, _omitted)
          ? this.startingFee
          : startingFee as double?,
      joinedDate: identical(joinedDate, _omitted)
          ? this.joinedDate
          : joinedDate as DateTime?,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      inventoryCount: inventoryCount ?? this.inventoryCount,
      salesCount: salesCount ?? this.salesCount,
    );
  }
}

const _omitted = Object();
