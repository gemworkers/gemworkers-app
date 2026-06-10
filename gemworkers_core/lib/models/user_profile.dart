class UserProfile {
  final String id;
  final String role; // 'owner' | 'seller'
  final String? sellerId;
  final String? displayName;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.role,
    this.sellerId,
    this.displayName,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        role: map['role'] as String,
        sellerId: map['seller_id']?.toString(),
        displayName: map['display_name']?.toString(),
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
