import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/commission.dart';

/// A refund made without a return (order_refunds) or a charge to the stone's
/// owner (owner_charges) — sql/refund_owner_costs.sql. Owner only.
class OrderMoneyEvent {
  final String label;
  final double amount;
  final DateTime at;
  const OrderMoneyEvent(this.label, this.amount, this.at);
}

class RefundRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  static const _refundOrderUrl = 'https://www.gemworkers.com/api/admin/refund-order';

  Future<double> refundable(String orderId) async {
    final v = await supabase.rpc('order_refundable', params: {'p_order_id': orderId});
    return parseNumeric(v) ?? 0;
  }

  /// Refunds [amount] through Stripe (store endpoint, holds the Stripe key).
  /// [stoneFate]: 'lost' | 'kept' | 'other'.
  Future<double> refundOrder(String orderId, double amount, String reason, String stoneFate) async {
    final token = supabase.auth.currentSession?.accessToken;
    if (token == null) throw Exception('Please log in again.');
    final res = await http.post(
      Uri.parse(_refundOrderUrl),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'order_id': orderId, 'amount': amount, 'reason': reason, 'stone_fate': stoneFate}),
    );
    final body = jsonDecode(res.body.isEmpty ? '{}' : res.body) as Map<String, dynamic>;
    if (res.statusCode != 200 || body['ok'] != true) {
      throw Exception(body['error']?.toString() ?? 'Refund failed (${res.statusCode})');
    }
    return (body['amount'] as num).toDouble();
  }

  /// Refunds and owner charges for one order, oldest first.
  Future<({List<OrderMoneyEvent> refunds, List<OrderMoneyEvent> charges})> getForOrder(String orderId) async {
    final r = await supabase.from('order_refunds').select('amount, reason, stone_fate, created_at').eq('order_id', orderId).order('created_at');
    final c = await supabase.from('owner_charges').select('amount, reason, created_at, settled_at').eq('order_id', orderId).order('created_at');
    const fates = {'lost': 'stone lost', 'kept': 'buyer keeps the stone', 'other': ''};
    return (
      refunds: [
        for (final x in r)
          OrderMoneyEvent(
            [x['reason'], fates[x['stone_fate']] ?? ''].where((s) => s.toString().isNotEmpty).join(' · '),
            parseNumeric(x['amount']) ?? 0,
            DateTime.parse(x['created_at'].toString()),
          ),
      ],
      charges: [
        for (final x in c)
          OrderMoneyEvent(
            '${x['reason']}${x['settled_at'] != null ? ' (settled)' : ''}',
            parseNumeric(x['amount']) ?? 0,
            DateTime.parse(x['created_at'].toString()),
          ),
      ],
    );
  }
}
