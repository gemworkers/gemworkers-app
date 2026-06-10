class _Omitted {
  const _Omitted();
}

const _omitted = _Omitted();

class Seller {
  final String? id;
  final String name;
  final String country;
  final String contactName;
  final String email;
  final String phone;
  final String notes;

  /// Stored as a decimal, e.g. 0.05 = 5 %.
  final double? commissionRate;
  final double? userFee;
  final String? userFeePeriod; // 'monthly' | 'annual' | 'weekly'
  final double? startingFee;
  final DateTime? joinedDate;

  /// 'active' | 'pending' | 'suspended'
  final String status;
  final DateTime? createdAt;

  // Rollup stats — loaded separately, not from sellers table.
  final int inventoryCount;
  final int listedCount;
  final int salesCount;
  final double revenue;

  const Seller({
    this.id,
    required this.name,
    this.country = '',
    this.contactName = '',
    this.email = '',
    this.phone = '',
    this.notes = '',
    this.commissionRate,
    this.userFee,
    this.userFeePeriod,
    this.startingFee,
    this.joinedDate,
    this.status = 'active',
    this.createdAt,
    this.inventoryCount = 0,
    this.listedCount = 0,
    this.salesCount = 0,
    this.revenue = 0,
  });

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      contactName: map['contact_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      notes: map['notes'] ?? '',
      commissionRate: (map['commission_rate'] as num?)?.toDouble(),
      userFee: (map['user_fee'] as num?)?.toDouble(),
      userFeePeriod: map['user_fee_period']?.toString(),
      startingFee: (map['starting_fee'] as num?)?.toDouble(),
      joinedDate: map['joined_date'] != null
          ? DateTime.parse(map['joined_date'].toString())
          : null,
      status: map['status'] ?? 'active',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'country': country,
        'contact_name': contactName,
        'email': email,
        'phone': phone,
        'notes': notes,
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
      };

  Seller copyWith({
    String? id,
    String? name,
    String? country,
    String? contactName,
    String? email,
    String? phone,
    String? notes,
    Object? commissionRate = _omitted,
    Object? userFee = _omitted,
    Object? userFeePeriod = _omitted,
    Object? startingFee = _omitted,
    Object? joinedDate = _omitted,
    String? status,
    DateTime? createdAt,
    int? inventoryCount,
    int? listedCount,
    int? salesCount,
    double? revenue,
  }) {
    return Seller(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      commissionRate: identical(commissionRate, _omitted)
          ? this.commissionRate
          : commissionRate as double?,
      userFee: identical(userFee, _omitted) ? this.userFee : userFee as double?,
      userFeePeriod: identical(userFeePeriod, _omitted)
          ? this.userFeePeriod
          : userFeePeriod as String?,
      startingFee: identical(startingFee, _omitted)
          ? this.startingFee
          : startingFee as double?,
      joinedDate: identical(joinedDate, _omitted)
          ? this.joinedDate
          : joinedDate as DateTime?,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      inventoryCount: inventoryCount ?? this.inventoryCount,
      listedCount: listedCount ?? this.listedCount,
      salesCount: salesCount ?? this.salesCount,
      revenue: revenue ?? this.revenue,
    );
  }
}
