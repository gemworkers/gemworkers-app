class StorefrontOffer {
  final String id;
  final String inventoryItemId;
  final String stoneTitle;   // from inventory_items join
  final double offeredPrice;
  final String status;       // 'pending' | 'accepted' | 'declined'
  final String buyerNote;
  final String sellerNote;
  final String buyerEmail;   // from buyers join; '' if RLS blocks
  final DateTime createdAt;
  final DateTime? respondedAt;

  const StorefrontOffer({
    required this.id,
    required this.inventoryItemId,
    required this.stoneTitle,
    required this.offeredPrice,
    required this.status,
    required this.buyerNote,
    required this.sellerNote,
    required this.buyerEmail,
    required this.createdAt,
    this.respondedAt,
  });

  factory StorefrontOffer.fromMap(Map<String, dynamic> map) {
    final item  = map['inventory_items'] as Map<String, dynamic>?;
    final buyer = map['buyers']          as Map<String, dynamic>?;
    return StorefrontOffer(
      id:               map['id'].toString(),
      inventoryItemId:  map['inventory_item_id'].toString(),
      stoneTitle:       item?['title']?.toString() ?? '',
      offeredPrice:     (map['offered_price'] as num).toDouble(),
      status:           map['status']?.toString() ?? 'pending',
      buyerNote:        map['buyer_note']?.toString() ?? '',
      sellerNote:       map['seller_note']?.toString() ?? '',
      buyerEmail:       buyer?['email']?.toString() ?? '',
      createdAt:        DateTime.parse(map['created_at'].toString()),
      respondedAt:      map['responded_at'] != null
                            ? DateTime.parse(map['responded_at'].toString())
                            : null,
    );
  }
}
