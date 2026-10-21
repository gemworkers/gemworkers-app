import '../core/utils/commission.dart';

/// One message in a conversation (public.messages).
class Message {
  final String id;
  final String conversationId;
  final String senderRole; // 'buyer' | 'seller' | 'owner'
  final String body;
  final String? linkedInventoryItemId;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderRole,
    required this.body,
    this.linkedInventoryItemId,
    required this.createdAt,
  });

  bool get isFromBuyer => senderRole == 'buyer';

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id:                    map['id'].toString(),
      conversationId:        map['conversation_id'].toString(),
      senderRole:            map['sender_role']?.toString() ?? 'buyer',
      body:                  map['body']?.toString() ?? '',
      linkedInventoryItemId: map['linked_inventory_item_id']?.toString(),
      createdAt: DateTime.tryParse(map['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

/// Card data for a stone shown in a thread (message_stone_cards RPC).
/// [status] is 'available' | 'reserved' | 'unavailable'; [price] is null when
/// unavailable.
class MessageStoneCard {
  final String id;
  final String title;
  final String? imageUrl;
  final double? price;
  final String productType;
  final String status;

  const MessageStoneCard({
    required this.id,
    required this.title,
    this.imageUrl,
    this.price,
    this.productType = '',
    required this.status,
  });

  factory MessageStoneCard.fromMap(Map<String, dynamic> map) {
    final image = map['image_url']?.toString();
    return MessageStoneCard(
      id:          map['id'].toString(),
      title:       map['title']?.toString() ?? '',
      imageUrl:    (image?.isNotEmpty ?? false) ? image : null,
      price:       parseNumeric(map['selling_price']),
      productType: map['product_type']?.toString() ?? '',
      status:      map['status']?.toString() ?? 'unavailable',
    );
  }
}

/// A listed + available stone that staff can attach to a reply.
class AttachableStone {
  final String id;
  final String title;
  final String sku;
  final String? imageUrl;
  final double? price;

  const AttachableStone({
    required this.id,
    required this.title,
    required this.sku,
    this.imageUrl,
    this.price,
  });

  factory AttachableStone.fromMap(Map<String, dynamic> map) {
    final images = map['image_urls'];
    final firstImage =
        images is List && images.isNotEmpty ? images.first?.toString() : null;
    return AttachableStone(
      id:       map['id'].toString(),
      title:    map['title']?.toString() ?? '',
      sku:      map['sku']?.toString() ?? '',
      imageUrl: (firstImage?.isNotEmpty ?? false) ? firstImage : null,
      price:    parseNumeric(map['selling_price']),
    );
  }
}
