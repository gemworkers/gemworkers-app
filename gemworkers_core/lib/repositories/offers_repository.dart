import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/storefront_offer.dart';

class OffersRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  /// Fetches pending + accepted + declined offers for the logged-in seller.
  /// RLS (offers_seller_select) scopes the query to this seller automatically —
  /// no manual seller_id filter is needed.
  /// Withdrawn and expired offers are excluded: they need no action.
  Future<List<StorefrontOffer>> fetchOffers() async {
    final response = await supabase
        .from('storefront_offers')
        .select('*, inventory_items(title), buyers(email)')
        .inFilter('status', ['pending', 'accepted', 'declined'])
        .order('created_at', ascending: false);

    final offers = response
        .map<StorefrontOffer>((row) => StorefrontOffer.fromMap(row))
        .toList();

    // Pending offers first, then most recent.
    offers.sort((a, b) {
      if (a.status == 'pending' && b.status != 'pending') return -1;
      if (b.status == 'pending' && a.status != 'pending') return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return offers;
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
}
