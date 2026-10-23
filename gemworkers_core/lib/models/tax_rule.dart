import '../core/utils/commission.dart';

/// public.shipping_countries — where the store ships.
class ShipCountry {
  final String code;
  final String name;
  final String region;
  final bool enabled;

  const ShipCountry({
    required this.code,
    required this.name,
    required this.region,
    required this.enabled,
  });

  factory ShipCountry.fromMap(Map<String, dynamic> m) => ShipCountry(
        code: m['code'].toString(),
        name: m['name']?.toString() ?? '',
        region: m['region']?.toString() ?? '',
        enabled: m['enabled'] == true,
      );
}

/// public.tax_rules — one row per destination (sql/tax_rules.sql).
/// Rates are fractions (0.21 = 21%); null = unknown.
class TaxRule {
  final String countryCode;
  final String mode; // 'collect' | 'buyer_pays' | 'none'
  final String taxName;
  final double? taxRate;
  final double? dutyLoose;
  final double? dutyJewelry;
  final double? dutySpecimen;
  final double? freeBelowEur;
  final String customsUnion;
  final String notes;
  final bool verified;

  const TaxRule({
    required this.countryCode,
    this.mode = 'buyer_pays',
    this.taxName = '',
    this.taxRate,
    this.dutyLoose,
    this.dutyJewelry,
    this.dutySpecimen,
    this.freeBelowEur,
    this.customsUnion = '',
    this.notes = '',
    this.verified = false,
  });

  factory TaxRule.fromMap(Map<String, dynamic> m) => TaxRule(
        countryCode: m['country_code'].toString(),
        mode: m['mode']?.toString() ?? 'buyer_pays',
        taxName: m['tax_name']?.toString() ?? '',
        taxRate: parseNumeric(m['tax_rate']),
        dutyLoose: parseNumeric(m['duty_loose']),
        dutyJewelry: parseNumeric(m['duty_jewelry']),
        dutySpecimen: parseNumeric(m['duty_specimen']),
        freeBelowEur: parseNumeric(m['free_below_eur']),
        customsUnion: m['customs_union']?.toString() ?? '',
        notes: m['notes']?.toString() ?? '',
        verified: m['verified'] == true,
      );

  Map<String, dynamic> toMap() => {
        'country_code': countryCode,
        'mode': mode,
        'tax_name': taxName.isEmpty ? null : taxName,
        'tax_rate': taxRate,
        'duty_loose': dutyLoose,
        'duty_jewelry': dutyJewelry,
        'duty_specimen': dutySpecimen,
        'free_below_eur': freeBelowEur,
        'customs_union': customsUnion.isEmpty ? null : customsUnion,
        'notes': notes.isEmpty ? null : notes,
        'verified': verified,
        'updated_at': DateTime.now().toIso8601String(),
      };
}

/// public.origin_duties — extra duty for (destination, origin).
class OriginDuty {
  final String destCode;
  final String originCode;
  final double extraDuty;
  final String notes;
  final bool verified;

  const OriginDuty({
    required this.destCode,
    required this.originCode,
    required this.extraDuty,
    this.notes = '',
    this.verified = false,
  });

  factory OriginDuty.fromMap(Map<String, dynamic> m) => OriginDuty(
        destCode: m['dest_code'].toString(),
        originCode: m['origin_code'].toString(),
        extraDuty: parseNumeric(m['extra_duty']) ?? 0,
        notes: m['notes']?.toString() ?? '',
        verified: m['verified'] == true,
      );

  Map<String, dynamic> toMap() => {
        'dest_code': destCode,
        'origin_code': originCode,
        'extra_duty': extraDuty,
        'notes': notes.isEmpty ? null : notes,
        'verified': verified,
        'updated_at': DateTime.now().toIso8601String(),
      };
}

/// public.shipping_routes — price per (origin, destination region or country).
class ShippingRoute {
  final String? id;
  final String originCode;
  final String? destRegion;
  final String? destCode;
  final double priceEur;
  final int? daysMin;
  final int? daysMax;
  final String courier;

  const ShippingRoute({
    this.id,
    required this.originCode,
    this.destRegion,
    this.destCode,
    required this.priceEur,
    this.daysMin,
    this.daysMax,
    this.courier = '',
  });

  factory ShippingRoute.fromMap(Map<String, dynamic> m) => ShippingRoute(
        id: m['id']?.toString(),
        originCode: m['origin_code'].toString(),
        destRegion: m['dest_region']?.toString(),
        destCode: m['dest_code']?.toString(),
        priceEur: parseNumeric(m['price_eur']) ?? 0,
        daysMin: (m['days_min'] as num?)?.toInt(),
        daysMax: (m['days_max'] as num?)?.toInt(),
        courier: m['courier']?.toString() ?? '',
      );

  Map<String, dynamic> toMap() => {
        'origin_code': originCode,
        'dest_region': destRegion,
        'dest_code': destCode,
        'price_eur': priceEur,
        'days_min': daysMin,
        'days_max': daysMax,
        'courier': courier.isEmpty ? null : courier,
        'updated_at': DateTime.now().toIso8601String(),
      };
}
