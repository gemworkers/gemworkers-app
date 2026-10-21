import 'package:intl/intl.dart';

final _eurWhole =
    NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 0);
final _eurCents =
    NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2);

/// Real money amounts: whole euros when the amount is a whole number (€55),
/// otherwise exactly 2 decimals (€49.80) — never rounds cents away. Same rule
/// as the store's lib/money.ts and the offer-notify Edge Function.
/// Not for compact chart labels (€1.2k), which stay as they are.
String formatEur(num v) {
  // Snap to cents first so float noise from sums (54.99999999) doesn't show
  // as €55.00 instead of €55.
  final cents = (v * 100).round();
  return cents % 100 == 0
      ? _eurWhole.format(cents ~/ 100)
      : _eurCents.format(cents / 100);
}
