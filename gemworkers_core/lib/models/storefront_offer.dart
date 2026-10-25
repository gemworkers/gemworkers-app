import '../core/utils/commission.dart';

class StorefrontOffer {
  final String id;
  final String inventoryItemId;
  final String sellerId;
  final String stoneTitle;   // from inventory_items join
  final String stoneSku;     // from inventory_items join
  final String? stoneImageUrl; // first of inventory_items.image_urls
  final double? listedPrice; // inventory_items.selling_price (fallback sale_price)
  final double offeredPrice;
  final String status;       // 'pending' | 'countered' | 'accepted' | 'declined' | 'expired'
  /// Staff counter-offer (one per offer); null if never countered.
  final double? counterPrice;
  final DateTime? counterExpiresAt;
  /// US / UK / AU / CA buyers offer in their own currency (the euro amounts
  /// above stay the basis): currency + what the buyer sees.
  final String offerCurrency;
  final double? localOffered;
  final double? localCounter;
  final String buyerNote;
  final String sellerNote;
  final String buyerEmail;   // from buyers join; '' if RLS blocks
  final String buyerName;    // buyers.display_name; '' if unset
  final DateTime createdAt;
  final DateTime? respondedAt;

  /// Order created when the offer was accepted (orders.offer_id); null if none.
  final String? orderId;
  final String? orderStatus;
  final DateTime? orderPaymentDueAt;

  const StorefrontOffer({
    required this.id,
    required this.inventoryItemId,
    required this.sellerId,
    required this.stoneTitle,
    this.stoneSku = '',
    this.stoneImageUrl,
    this.listedPrice,
    required this.offeredPrice,
    required this.status,
    this.counterPrice,
    this.counterExpiresAt,
    this.offerCurrency = 'EUR',
    this.localOffered,
    this.localCounter,
    required this.buyerNote,
    required this.sellerNote,
    required this.buyerEmail,
    this.buyerName = '',
    required this.createdAt,
    this.respondedAt,
    this.orderId,
    this.orderStatus,
    this.orderPaymentDueAt,
  });

  /// "$300" / "£49.50" — the buyer's own amount, or null for euro offers.
  static String? localLabel(String currency, double? amount) {
    if (currency == 'EUR' || amount == null) return null;
    const symbols = {'USD': r'$', 'GBP': '£', 'AUD': r'A$', 'CAD': r'C$'};
    final n = amount == amount.roundToDouble() ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
    return '${symbols[currency] ?? '$currency '}$n';
  }

  factory StorefrontOffer.fromMap(Map<String, dynamic> map) {
    final item  = map['inventory_items'] as Map<String, dynamic>?;
    final buyer = map['buyers']          as Map<String, dynamic>?;

    final images = item?['image_urls'];
    final firstImage = images is List && images.isNotEmpty
        ? images.first?.toString()
        : null;
    final listed = (item?['selling_price'] ?? item?['sale_price']) as num?;

    // Reverse embed (orders.offer_id) comes back as a list; prefer the
    // non-cancelled order if there is more than one.
    final orders = (map['orders'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        const <Map<String, dynamic>>[];
    final order = orders.isEmpty
        ? null
        : orders.firstWhere((o) => o['status'] != 'cancelled',
            orElse: () => orders.first);

    return StorefrontOffer(
      id:               map['id'].toString(),
      inventoryItemId:  map['inventory_item_id'].toString(),
      sellerId:         map['seller_id'].toString(),
      stoneTitle:       item?['title']?.toString() ?? '',
      stoneSku:         item?['sku']?.toString() ?? '',
      stoneImageUrl:    (firstImage?.isNotEmpty ?? false) ? firstImage : null,
      listedPrice:      listed != null && listed > 0 ? listed.toDouble() : null,
      offeredPrice:     (map['offered_price'] as num).toDouble(),
      status:           map['status']?.toString() ?? 'pending',
      counterPrice:     parseNumeric(map['counter_price']),
      counterExpiresAt: map['counter_expires_at'] != null
                            ? DateTime.parse(map['counter_expires_at'].toString())
                            : null,
      offerCurrency:    map['offer_currency']?.toString() ?? 'EUR',
      localOffered:     parseNumeric(map['local_offered']),
      localCounter:     parseNumeric(map['local_counter']),
      buyerNote:        map['buyer_note']?.toString() ?? '',
      sellerNote:       map['seller_note']?.toString() ?? '',
      buyerEmail:       buyer?['email']?.toString() ?? '',
      buyerName:        buyer?['display_name']?.toString() ?? '',
      createdAt:        DateTime.parse(map['created_at'].toString()),
      respondedAt:      map['responded_at'] != null
                            ? DateTime.parse(map['responded_at'].toString())
                            : null,
      orderId:          order?['id']?.toString(),
      orderStatus:      order?['status']?.toString(),
      orderPaymentDueAt: order?['payment_due_at'] != null
                            ? DateTime.parse(order!['payment_due_at'].toString())
                            : null,
    );
  }
}
