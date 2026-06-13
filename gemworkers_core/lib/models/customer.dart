/// Tier thresholds matching the sell-engine auto_tier computation.
class CustomerTiers {
  static const double goldThreshold      = 5000.0;
  static const double premiumThreshold   = 15000.0;
  static const double collectorThreshold = 50000.0;

  static const List<String?> manualOptions = [
    null,
    'Silver',
    'Gold',
    'Premium',
    'Collector',
  ];

  /// Silver < 5 000 · Gold 5 000–14 999.99 · Premium 15 000–49 999.99
  /// · Collector >= 50 000
  static String compute(double totalSpent) {
    if (totalSpent >= collectorThreshold) return 'Collector';
    if (totalSpent >= premiumThreshold)   return 'Premium';
    if (totalSpent >= goldThreshold)      return 'Gold';
    return 'Silver';
  }

  static const Map<String, int> _tierOrder = {
    'Silver':    0,
    'Gold':      1,
    'Premium':   2,
    'Collector': 3,
  };

  static int rank(String tier) => _tierOrder[tier] ?? 0;
}

class Customer {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String country;

  /// 'individual' or 'business'
  final String type;

  /// Manual override: null | 'Silver' | 'Gold' | 'Premium' | 'Collector'
  final String? manualTier;

  final String notes;
  final DateTime? createdAt;

  // ── Owner-side intelligence (auto-populated by sell engine) ──────────────
  final double totalSpent;
  final int orderCount;
  final DateTime? firstOrderDate;
  final DateTime? lastOrderDate;

  /// Computed by sell engine and stored in DB. Reflects thresholds above.
  final String? autoTier;

  const Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.type,
    this.manualTier,
    required this.notes,
    this.createdAt,
    this.totalSpent = 0,
    this.orderCount = 0,
    this.firstOrderDate,
    this.lastOrderDate,
    this.autoTier,
  });

  /// Manual tier wins → auto_tier from DB → computed from stored spend.
  String get effectiveTier =>
      manualTier ?? autoTier ?? CustomerTiers.compute(totalSpent);

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      country: map['country'] ?? '',
      type: map['type'] ?? 'individual',
      manualTier: map['manual_tier']?.toString(),
      notes: map['notes'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      totalSpent: (map['total_spent'] as num?)?.toDouble() ?? 0,
      orderCount: (map['order_count'] as num?)?.toInt() ?? 0,
      firstOrderDate: map['first_order_date'] != null
          ? DateTime.parse(map['first_order_date'].toString())
          : null,
      lastOrderDate: map['last_order_date'] != null
          ? DateTime.parse(map['last_order_date'].toString())
          : null,
      autoTier: map['auto_tier']?.toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name':       name,
        'email':      email,
        'phone':      phone,
        'country':    country,
        'type':       type,
        'manual_tier': manualTier,
        'notes':      notes,
      };

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? type,
    Object? manualTier = _omitted,
    String? notes,
    DateTime? createdAt,
    double? totalSpent,
    int? orderCount,
    Object? firstOrderDate = _omitted,
    Object? lastOrderDate  = _omitted,
    Object? autoTier       = _omitted,
  }) {
    return Customer(
      id:       id       ?? this.id,
      name:     name     ?? this.name,
      email:    email    ?? this.email,
      phone:    phone    ?? this.phone,
      country:  country  ?? this.country,
      type:     type     ?? this.type,
      manualTier: identical(manualTier, _omitted)
          ? this.manualTier
          : manualTier as String?,
      notes:    notes    ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      totalSpent:  totalSpent  ?? this.totalSpent,
      orderCount:  orderCount  ?? this.orderCount,
      firstOrderDate: identical(firstOrderDate, _omitted)
          ? this.firstOrderDate
          : firstOrderDate as DateTime?,
      lastOrderDate: identical(lastOrderDate, _omitted)
          ? this.lastOrderDate
          : lastOrderDate as DateTime?,
      autoTier: identical(autoTier, _omitted)
          ? this.autoTier
          : autoTier as String?,
    );
  }
}

const _omitted = Object();
