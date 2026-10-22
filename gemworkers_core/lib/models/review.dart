/// A buyer review (public.reviews) as the owner sees it in admin.
class Review {
  final String id;
  final String orderId;
  final String orderNumber;
  final String stoneTitle;
  final String stoneSku;
  final int rating;
  final String body;
  final String? photoUrl;
  final String reviewerName;
  final String reviewerCountry;
  final String status; // 'pending' | 'approved' | 'hidden'
  final String ownerReply;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.stoneTitle,
    required this.stoneSku,
    required this.rating,
    required this.body,
    this.photoUrl,
    required this.reviewerName,
    required this.reviewerCountry,
    required this.status,
    required this.ownerReply,
    required this.createdAt,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    final item = map['inventory_items'] as Map<String, dynamic>?;
    final order = map['orders'] as Map<String, dynamic>?;
    final photo = map['photo_url']?.toString();
    return Review(
      id: map['id'].toString(),
      orderId: map['order_id'].toString(),
      orderNumber: order?['order_number']?.toString() ?? '',
      stoneTitle: item?['title']?.toString() ?? '',
      stoneSku: item?['sku']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      body: map['body']?.toString() ?? '',
      photoUrl: (photo?.isNotEmpty ?? false) ? photo : null,
      reviewerName: map['reviewer_name']?.toString() ?? '',
      reviewerCountry: map['reviewer_country']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      ownerReply: map['owner_reply']?.toString() ?? '',
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
