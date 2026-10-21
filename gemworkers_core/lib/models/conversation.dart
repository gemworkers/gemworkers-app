import '../core/utils/commission.dart';

/// A buyer ↔ staff conversation about one stone (public.conversations).
/// The buyer is only ever known by the [buyerFirstName] snapshot — the buyers
/// table is never queried from the admin.
class Conversation {
  final String id;
  final String? inventoryItemId; // null if the stone was deleted
  final String sellerId;
  final String? buyerFirstName;
  final String status; // 'open' | 'closed' | 'blocked'
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final DateTime? sellerLastReadAt;
  final DateTime? ownerLastReadAt;

  // From the inventory_items embed.
  final String stoneTitle;
  final String stoneSku;
  final String? stoneImageUrl;
  final double? stonePrice; // selling_price
  final String? stoneStatus; // inventory_items.status
  final bool stoneIsListed;

  /// sellers.name — only fetched for the owner; '' otherwise.
  final String sellerName;

  // Latest message (any side) and latest buyer message, from aliased embeds.
  final String lastMessagePreview;
  final String? lastMessageRole;
  final DateTime? lastBuyerMessageAt;

  const Conversation({
    required this.id,
    this.inventoryItemId,
    required this.sellerId,
    this.buyerFirstName,
    required this.status,
    required this.createdAt,
    required this.lastMessageAt,
    this.sellerLastReadAt,
    this.ownerLastReadAt,
    this.stoneTitle = '',
    this.stoneSku = '',
    this.stoneImageUrl,
    this.stonePrice,
    this.stoneStatus,
    this.stoneIsListed = false,
    this.sellerName = '',
    this.lastMessagePreview = '',
    this.lastMessageRole,
    this.lastBuyerMessageAt,
  });

  bool get isOpen => status == 'open';

  /// "Customer" when no first name was captured.
  String get buyerLabel {
    final name = buyerFirstName?.trim() ?? '';
    return name.isNotEmpty ? name : 'Customer';
  }

  /// True when the buyer wrote after this staff side last read the thread.
  bool isUnreadFor({required bool isOwner}) {
    final lastBuyer = lastBuyerMessageAt;
    if (lastBuyer == null) return false;
    final readAt = isOwner ? ownerLastReadAt : sellerLastReadAt;
    return readAt == null || lastBuyer.isAfter(readAt);
  }

  /// Human label for the stone's shop status, e.g. 'Listed', 'Sold'.
  String get stoneStatusLabel {
    if (inventoryItemId == null) return 'Removed';
    return switch (stoneStatus) {
      'sold' => 'Sold',
      'reserved' => 'Reserved',
      'available' => stoneIsListed ? 'Listed' : 'Not listed',
      final s? when s.isNotEmpty => s[0].toUpperCase() + s.substring(1),
      _ => '',
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final item = map['inventory_items'] as Map<String, dynamic>?;
    final seller = map['sellers'] as Map<String, dynamic>?;

    final images = item?['image_urls'];
    final firstImage =
        images is List && images.isNotEmpty ? images.first?.toString() : null;
    final price = parseNumeric(item?['selling_price']);

    Map<String, dynamic>? firstOf(dynamic list) =>
        list is List && list.isNotEmpty && list.first is Map<String, dynamic>
            ? list.first as Map<String, dynamic>
            : null;
    final last = firstOf(map['last_message']);
    final lastBuyer = firstOf(map['last_buyer_message']);

    return Conversation(
      id:               map['id'].toString(),
      inventoryItemId:  map['inventory_item_id']?.toString(),
      sellerId:         map['seller_id']?.toString() ?? '',
      buyerFirstName:   map['buyer_first_name']?.toString(),
      status:           map['status']?.toString() ?? 'open',
      createdAt:        _date(map['created_at']) ?? DateTime.now(),
      lastMessageAt:    _date(map['last_message_at']) ?? DateTime.now(),
      sellerLastReadAt: _date(map['seller_last_read_at']),
      ownerLastReadAt:  _date(map['owner_last_read_at']),
      stoneTitle:       item?['title']?.toString() ?? '',
      stoneSku:         item?['sku']?.toString() ?? '',
      stoneImageUrl:    (firstImage?.isNotEmpty ?? false) ? firstImage : null,
      stonePrice:       price != null && price > 0 ? price : null,
      stoneStatus:      item?['status']?.toString(),
      stoneIsListed:    item?['is_listed'] == true,
      sellerName:       seller?['name']?.toString() ?? '',
      lastMessagePreview: last?['body']?.toString() ?? '',
      lastMessageRole:  last?['sender_role']?.toString(),
      lastBuyerMessageAt: _date(lastBuyer?['created_at']),
    );
  }

  static DateTime? _date(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());
}
