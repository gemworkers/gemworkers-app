import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/tax_rule.dart';

/// Owner-only editing of the tax & duties tables (sql/tax_rules.sql,
/// sql/shipping_countries.sql). RLS: everyone reads, only the owner writes.
class TaxRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<ShipCountry>> getCountries() async {
    final rows = await supabase
        .from('shipping_countries')
        .select('code, name, region, enabled')
        .order('sort_order')
        .order('name');
    return rows.map<ShipCountry>((r) => ShipCountry.fromMap(r)).toList();
  }

  Future<void> setCountryEnabled(String code, bool enabled) async {
    await supabase.from('shipping_countries').update({
      'enabled': enabled,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('code', code);
  }

  Future<Map<String, TaxRule>> getRules() async {
    final rows = await supabase.from('tax_rules').select();
    return {
      for (final r in rows) r['country_code'].toString(): TaxRule.fromMap(r),
    };
  }

  Future<void> saveRule(TaxRule rule) async {
    await supabase.from('tax_rules').upsert(rule.toMap(), onConflict: 'country_code');
  }

  Future<void> deleteRule(String countryCode) async {
    await supabase.from('tax_rules').delete().eq('country_code', countryCode);
  }

  Future<List<OriginDuty>> getOriginDuties() async {
    final rows = await supabase
        .from('origin_duties')
        .select()
        .order('dest_code')
        .order('origin_code');
    return rows.map<OriginDuty>((r) => OriginDuty.fromMap(r)).toList();
  }

  Future<void> saveOriginDuty(OriginDuty d) async {
    await supabase
        .from('origin_duties')
        .upsert(d.toMap(), onConflict: 'dest_code,origin_code');
  }

  Future<void> deleteOriginDuty(String dest, String origin) async {
    await supabase
        .from('origin_duties')
        .delete()
        .eq('dest_code', dest)
        .eq('origin_code', origin);
  }

  Future<List<ShippingRoute>> getRoutes() async {
    final rows = await supabase
        .from('shipping_routes')
        .select()
        .order('origin_code');
    return rows.map<ShippingRoute>((r) => ShippingRoute.fromMap(r)).toList();
  }

  Future<void> saveRoute(ShippingRoute r) async {
    if (r.id == null) {
      await supabase.from('shipping_routes').insert(r.toMap());
    } else {
      await supabase.from('shipping_routes').update(r.toMap()).eq('id', r.id!);
    }
  }

  Future<void> deleteRoute(String id) async {
    await supabase.from('shipping_routes').delete().eq('id', id);
  }
}
