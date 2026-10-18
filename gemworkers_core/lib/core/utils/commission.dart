import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// There is NO default commission: a NULL commission_rate (or an item without
/// a seller) means 0%. Mirrors COALESCE(rate, 0) in create_platform_order /
/// respond_to_offer (see sql/commission_default_zero.sql).
const kDefaultCommissionRate = 0.0;

/// Parses a Postgres numeric as returned by Supabase — a JSON number or a
/// numeric string such as "0.0000". Returns null for NULL / unparseable.
/// Never throws (a plain `as num?` cast throws on a String).
double? parseNumeric(dynamic v) => switch (v) {
      null => null,
      num n => n.toDouble(),
      String s => double.tryParse(s.trim()),
      _ => null,
    };

/// sellers.commission_rate → decimal fraction (0.0100 = 1%). Null only when
/// the value is genuinely NULL (or unparseable).
double? parseCommissionRate(dynamic v) => parseNumeric(v);

/// Where a resolved rate came from.
enum CommissionRateSource {
  /// Seller's own stored rate (may be 0).
  seller,

  /// Seller exists but commission_rate is NULL → 0%.
  nullRate,

  /// No seller on the item → 0%.
  noSeller,

  /// Lookup failed (network/RLS/not found) → 0% shown, flagged to the user.
  failed,
}

typedef CommissionRate = ({double rate, CommissionRateSource source});

/// Loads the commission rate for [sellerId] — pass the ITEM's seller
/// (inventory_items.seller_id), not the logged-in user.
/// Only selects commission_rate so unrelated seller columns can't break it.
Future<CommissionRate> loadSellerCommissionRate(String? sellerId) async {
  if (sellerId == null) {
    return (rate: kDefaultCommissionRate, source: CommissionRateSource.noSeller);
  }
  try {
    final row = await Supabase.instance.client
        .from('sellers')
        .select('commission_rate')
        .eq('id', sellerId)
        .maybeSingle();
    if (row == null) {
      debugPrint('Commission: seller $sellerId not found/visible — default');
      return (rate: kDefaultCommissionRate, source: CommissionRateSource.failed);
    }
    final rate = parseCommissionRate(row['commission_rate']);
    return rate != null
        ? (rate: rate, source: CommissionRateSource.seller)
        : (rate: kDefaultCommissionRate, source: CommissionRateSource.nullRate);
  } catch (e) {
    debugPrint('Commission: rate lookup for $sellerId failed — $e');
    return (rate: kDefaultCommissionRate, source: CommissionRateSource.failed);
  }
}

/// Commission on a buyer price — mirrors deployed order math:
/// ROUND(item_price × rate, 2).
double commissionFee(double price, double rate) =>
    double.parse((price * rate).toStringAsFixed(2));

/// What the seller receives for a buyer price.
double payoutAfterCommission(double price, double rate) =>
    price - commissionFee(price, rate);

/// "10%" / "1%" / "12.5%".
String commissionLabel(double rate) {
  final pct = double.parse((rate * 100).toStringAsFixed(2));
  return pct % 1 == 0 ? '${pct.toInt()}%' : '${pct.toStringAsFixed(1)}%';
}

/// Muted warning for a real lookup failure; null otherwise (NULL rate and
/// no seller are legitimately 0%).
String? commissionRateNote(CommissionRateSource source) => switch (source) {
      CommissionRateSource.failed => "Couldn't load the seller's commission.",
      _ => null,
    };
