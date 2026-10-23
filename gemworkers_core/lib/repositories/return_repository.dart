import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/return_request.dart';

/// Owner-only returns (sql/returns_setup.sql). Decisions go through the SQL
/// functions; the refund goes through the store, which holds the Stripe key
/// (gemworkers_store/app/api/admin/refund/route.ts).
class ReturnRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  static const _refundUrl = 'https://www.gemworkers.com/api/admin/refund';

  Future<List<ReturnRequest>> getReturns() async {
    final rows = await supabase
        .from('returns')
        .select('*, orders(order_number, order_total, tax_amount, customer_type, buyer_company, '
            'payout_status, order_items(inventory_items(title, sku)))')
        .order('requested_at', ascending: false)
        .limit(500);
    return rows.map<ReturnRequest>((r) => ReturnRequest.fromMap(r)).toList();
  }

  Future<int> getOpenCount() async {
    final rows = await supabase.from('returns').select('id').inFilter('status', ['requested', 'received']);
    return rows.length;
  }

  Future<void> approve(String id, String note) =>
      supabase.rpc('approve_return', params: {'p_return_id': id, 'p_note': note});

  Future<void> reject(String id, String note) =>
      supabase.rpc('reject_return', params: {'p_return_id': id, 'p_note': note});

  Future<void> markReceived(String id, String conditionNote) =>
      supabase.rpc('mark_return_received', params: {'p_return_id': id, 'p_condition_note': conditionNote});

  /// Refunds paid − [deduction] through Stripe. Returns the refunded amount.
  Future<double> refund(String id, double deduction, String deductionReason) async {
    final token = supabase.auth.currentSession?.accessToken;
    if (token == null) throw Exception('Please log in again.');
    final res = await http.post(
      Uri.parse(_refundUrl),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'return_id': id, 'deduction': deduction, 'deduction_reason': deductionReason}),
    );
    final body = jsonDecode(res.body.isEmpty ? '{}' : res.body) as Map<String, dynamic>;
    if (res.statusCode != 200 || body['ok'] != true) {
      throw Exception(body['error']?.toString() ?? 'Refund failed (${res.statusCode})');
    }
    return (body['amount'] as num).toDouble();
  }

  Future<String> getReturnAddress() async {
    final row = await supabase.from('store_settings').select('value').eq('key', 'return_address').maybeSingle();
    return row?['value']?.toString() ?? '';
  }

  Future<void> setReturnAddress(String address) async {
    await supabase.from('store_settings').upsert({
      'key': 'return_address',
      'value': address.trim(),
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'key');
  }
}
