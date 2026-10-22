import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/storefront_offer.dart';

class OffersRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetches pending + countered + accepted + declined + expired offers for the logged-in
  /// user, with the item (title, SKU, photo, price), the buyer, and the order
  /// created on acceptance (orders.offer_id).
  /// RLS (offers_seller_select) already scopes sellers to their own rows at
  /// the DB level; the app layer applies shouldFilterBySeller on top for
  /// consistency with orders/purchases pages.
  /// Withdrawn offers are excluded: the buyer took them back.
  Future<List<StorefrontOffer>> fetchOffers() async {
    final response = await supabase
        .from('storefront_offers')
        .select('*, '
            'inventory_items(title, sku, image_urls, selling_price, sale_price), '
            'buyers(email, display_name), '
            'orders(id, status, payment_due_at)')
        .inFilter('status', ['pending', 'countered', 'accepted', 'declined', 'expired'])
        .order('created_at', ascending: false);

    final offers = response
        .map<StorefrontOffer>((row) => StorefrontOffer.fromMap(row))
        .toList();

    // Pending offers first, then countered (waiting on the buyer), then most recent.
    int rank(StorefrontOffer o) => switch (o.status) {
          'pending' => 0,
          'countered' => 1,
          _ => 2,
        };
    offers.sort((a, b) {
      final byRank = rank(a).compareTo(rank(b));
      if (byRank != 0) return byRank;
      return b.createdAt.compareTo(a.createdAt);
    });

    return offers;
  }

  /// Number of offers awaiting a response. Pass [sellerId] to scope to a
  /// single seller.
  Future<int> getPendingCount({String? sellerId}) async {
    var query = supabase
        .from('storefront_offers')
        .select('id')
        .eq('status', 'pending');
    if (sellerId != null) query = query.eq('seller_id', sellerId);
    final response = await query;
    return response.length;
  }

  /// Calls respond_to_offer with 'accepted' or 'declined'.
  /// Returns the RPC's JSON result: { offer_id, order_id }.
  /// Throws PostgrestException on RPC errors (e.g. stone already reserved).
  Future<Map<String, dynamic>> respondToOffer(
    String offerId,
    String action, {
    String sellerNote = '',
  }) async {
    final result = await supabase.rpc('respond_to_offer', params: {
      'p_offer_id':    offerId,
      'p_action':      action,
      'p_seller_note': sellerNote,
    });
    return Map<String, dynamic>.from(result as Map);
  }

  /// Calls counter_offer. [counterCents] is the exact amount in cents, so
  /// the amount sent is never float-rounded (1550 → 15.5).
  /// Returns { offer_id, counter_price, counter_expires_at }.
  /// Throws PostgrestException with a readable message when a rule refuses it
  /// (not above the buyer's offer, not below the listed price, already countered…).
  Future<Map<String, dynamic>> counterOffer(String offerId, int counterCents) async {
    final result = await supabase.rpc('counter_offer', params: {
      'p_offer_id':      offerId,
      'p_counter_price': counterCents / 100,
    });
    return Map<String, dynamic>.from(result as Map);
  }
}
