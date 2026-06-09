/// Tier thresholds in one place — change here to affect the whole app.
class CustomerTiers {
  static const double silverThreshold = 250.0;
  static const double goldThreshold = 1000.0;
  static const double premiumThreshold = 5000.0;

  static const List<String?> manualOptions = [
    null,
    'Silver',
    'Gold',
    'Premium',
    'Collector',
  ];

  /// Computes the tier from total spend. Collector is only assignable manually.
  static String compute(double totalSpent) {
    if (totalSpent >= premiumThreshold) return 'Premium';
    if (totalSpent >= goldThreshold) return 'Gold';
    if (totalSpent >= silverThreshold) return 'Silver';
    return 'Bronze';
  }

  static const Map<String, int> _tierOrder = {
    'Bronze': 0,
    'Silver': 1,
    'Gold': 2,
    'Premium': 3,
    'Collector': 4,
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
  });

  /// Effective display tier: manual override wins, otherwise computed from spend.
  String effectiveTier(double totalSpent) =>
      manualTier ?? CustomerTiers.compute(totalSpent);

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
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'country': country,
        'type': type,
        'manual_tier': manualTier,
        'notes': notes,
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
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      type: type ?? this.type,
      manualTier: identical(manualTier, _omitted)
          ? this.manualTier
          : manualTier as String?,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

const _omitted = Object();
