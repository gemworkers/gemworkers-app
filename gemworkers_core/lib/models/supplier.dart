class Supplier {
  final String? id;

  final String name;
  final String country;

  final String contactName;
  final String email;
  final String phone;

  /// 0.0 – 5.0 in 0.5 steps.
  final double reliabilityScore;

  final String notes;

  final DateTime? createdAt;

  const Supplier({
    this.id,
    required this.name,
    required this.country,
    required this.contactName,
    required this.email,
    required this.phone,
    required this.reliabilityScore,
    required this.notes,
    this.createdAt,
  });

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      contactName: map['contact_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      reliabilityScore: (map['reliability_score'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'contact_name': contactName,
      'email': email,
      'phone': phone,
      'reliability_score': reliabilityScore,
      'notes': notes,
    };
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? country,
    String? contactName,
    String? email,
    String? phone,
    double? reliabilityScore,
    String? notes,
    DateTime? createdAt,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      contactName: contactName ?? this.contactName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      reliabilityScore: reliabilityScore ?? this.reliabilityScore,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
