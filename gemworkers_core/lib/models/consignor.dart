import '../core/utils/commission.dart';

/// public.consignors — people whose stones GemWorkers holds and sells from NL
/// (a brother, or someone not on the platform). sql/consignment_setup.sql.
/// Owner only; never shown to buyers or sellers.
class Consignor {
  final String? id;
  final String name;
  final String country;
  final String email;
  final String phone;
  final String payoutMethod;
  final String payoutDetails;
  final String notes;
  final String? sellerId; // set when this owner is also a seller (a brother)
  final double defaultShare; // owner's share of the profit, 0.5 = 50%
  final bool active;

  const Consignor({
    this.id,
    required this.name,
    this.country = '',
    this.email = '',
    this.phone = '',
    this.payoutMethod = '',
    this.payoutDetails = '',
    this.notes = '',
    this.sellerId,
    this.defaultShare = 0.5,
    this.active = true,
  });

  factory Consignor.fromMap(Map<String, dynamic> m) => Consignor(
        id: m['id']?.toString(),
        name: m['name']?.toString() ?? '',
        country: m['country']?.toString() ?? '',
        email: m['email']?.toString() ?? '',
        phone: m['phone']?.toString() ?? '',
        payoutMethod: m['payout_method']?.toString() ?? '',
        payoutDetails: m['payout_details']?.toString() ?? '',
        notes: m['notes']?.toString() ?? '',
        sellerId: m['seller_id']?.toString(),
        defaultShare: parseNumeric(m['default_share']) ?? 0.5,
        active: m['active'] != false,
      );

  Map<String, dynamic> toMap() {
    String? orNull(String s) => s.trim().isEmpty ? null : s.trim();
    return {
      'name': name.trim(),
      'country': orNull(country.toUpperCase()),
      'email': orNull(email),
      'phone': orNull(phone),
      'payout_method': orNull(payoutMethod),
      'payout_details': orNull(payoutDetails),
      'notes': orNull(notes),
      'seller_id': sellerId,
      'default_share': defaultShare,
      'active': active,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
