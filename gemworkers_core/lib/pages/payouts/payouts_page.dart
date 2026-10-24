import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/utils/commission.dart';
import '../../core/utils/money.dart';
import '../../core/utils/open_url/open_url.dart';
import '../../theme/app_theme.dart';

/// Payout balances and statements (sql/payouts_setup.sql).
/// Owner: every brother / owner with what is owed, pay them (sales − open
/// charges) and keep a numbered statement. Seller: their own sales waiting,
/// their charges and their statements.
class PayoutsPage extends StatefulWidget {
  const PayoutsPage({super.key});

  @override
  State<PayoutsPage> createState() => _PayoutsPageState();
}

class _Payee {
  final String? sellerId;
  final String? consignorId;
  String name = '';
  final List<Map<String, dynamic>> lines = [];
  final List<Map<String, dynamic>> charges = [];
  _Payee(this.sellerId, this.consignorId);
  String get key => sellerId ?? 'c:$consignorId';
  double get sales => lines.fold(0, (s, l) => s + (parseNumeric(l['amount']) ?? 0));
  double get ready => lines.where((l) => l['ready'] == true).fold(0, (s, l) => s + (parseNumeric(l['amount']) ?? 0));
  double get chargesTotal => charges.fold(0, (s, c) => s + (parseNumeric(c['amount']) ?? 0));
}

class _PayoutsPageState extends State<PayoutsPage> {
  final _supabase = Supabase.instance.client;
  bool get _isOwner => UserProfileService.instance.isOwner;

  bool _loading = true;
  List<_Payee> _payees = [];
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final lines = await _supabase.from('payout_lines').select().order('paid_at');
      final charges = await _supabase.from('payout_open_charges').select().order('created_at');
      final history = await _supabase
          .from('payouts')
          .select('id, number, amount, paid_at, method, reference, seller_id, consignor_id, data')
          .order('paid_at', ascending: false)
          .limit(200);

      final map = <String, _Payee>{};
      _Payee payee(Map<String, dynamic> r) {
        final s = r['payee_seller_id']?.toString();
        final c = r['payee_consignor_id']?.toString();
        final p = _Payee(s, c);
        return map.putIfAbsent(p.key, () => p);
      }
      for (final l in lines) {
        payee(l).lines.add(l);
      }
      for (final c in charges) {
        payee(c).charges.add(c);
      }

      // Names: sellers and owners (owner sees both; a seller sees only himself).
      final sellerIds = map.values.map((p) => p.sellerId).whereType<String>().toList();
      final consIds = map.values.map((p) => p.consignorId).whereType<String>().toList();
      final names = <String, String>{};
      if (sellerIds.isNotEmpty) {
        for (final s in await _supabase.from('sellers').select('id, name').inFilter('id', sellerIds)) {
          names[s['id'].toString()] = s['name'].toString();
        }
      }
      if (consIds.isNotEmpty && _isOwner) {
        for (final c in await _supabase.from('consignors').select('id, name').inFilter('id', consIds)) {
          names['c:${c['id']}'] = c['name'].toString();
        }
      }
      for (final p in map.values) {
        p.name = names[p.key] ?? 'Owner';
      }

      if (!mounted) return;
      setState(() {
        _payees = map.values.toList()..sort((a, b) => a.name.compareTo(b.name));
        _history = List<Map<String, dynamic>>.from(history);
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(Object msg, {bool error = false}) {
    if (!mounted) return;
    final text = msg is PostgrestException ? msg.message : msg.toString();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: error ? Theme.of(context).colorScheme.error : null,
    ));
  }

  Future<void> _pay(_Payee p) async {
    final selected = <String>{
      for (final l in p.lines)
        if (l['ready'] == true) l['order_id'].toString(),
    };
    final method = TextEditingController(text: 'Wise');
    final reference = TextEditingController();
    final note = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        final sales = p.lines
            .where((l) => selected.contains(l['order_id'].toString()))
            .fold<double>(0, (s, l) => s + (parseNumeric(l['amount']) ?? 0));
        final pay = sales - p.chargesTotal;
        final t = Theme.of(ctx).textTheme;
        return AlertDialog(
          title: Text('Pay ${p.name}'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Sales', style: t.titleSmall),
                for (final l in p.lines)
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: selected.contains(l['order_id'].toString()),
                    onChanged: l['state'] == 'chargeback open'
                        ? null
                        : (v) => setD(() => v == true
                            ? selected.add(l['order_id'].toString())
                            : selected.remove(l['order_id'].toString())),
                    title: Text('${l['order_number']} · ${l['stone'] ?? 'Stone'}'),
                    subtitle: Text(l['state'].toString(),
                        style: TextStyle(color: l['ready'] == true ? AppColors.success : AppColors.accent)),
                    secondary: Text(formatEur(parseNumeric(l['amount']) ?? 0)),
                  ),
                if (p.charges.isNotEmpty) ...[
                  const Divider(),
                  Text('Deducted (all open charges)', style: t.titleSmall),
                  for (final c in p.charges)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(c['reason'].toString()),
                      subtitle: Text(c['order_number']?.toString() ?? ''),
                      trailing: Text('−${formatEur(parseNumeric(c['amount']) ?? 0)}'),
                    ),
                ],
                const Divider(),
                Text('Send: ${formatEur(pay < 0 ? 0 : pay)}', style: t.titleLarge),
                if (selected.any((id) => p.lines.any((l) => l['order_id'].toString() == id && l['ready'] != true)))
                  Text('Some sales are still in their return period — if one comes back you recover it from the next payout.',
                      style: t.bodySmall?.copyWith(color: AppColors.accent)),
                const SizedBox(height: 8),
                TextField(controller: method, decoration: const InputDecoration(labelText: 'Paid via (Wise, Payoneer, bank)')),
                TextField(controller: reference, decoration: const InputDecoration(labelText: 'Transfer reference')),
                TextField(controller: note, decoration: const InputDecoration(labelText: 'Note (optional)')),
                const SizedBox(height: 8),
                Text('First send the money in Wise / Payoneer, then record it here.', style: t.bodySmall),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: pay > 0 && selected.isNotEmpty ? () => Navigator.pop(ctx, true) : null,
              child: Text('Record payout ${formatEur(pay < 0 ? 0 : pay)}'),
            ),
          ],
        );
      }),
    );
    final m = method.text, r = reference.text, n = note.text;
    method.dispose();
    reference.dispose();
    note.dispose();
    if (ok != true) return;
    try {
      final id = await _supabase.rpc('create_payout', params: {
        'p_seller_id': p.sellerId,
        'p_consignor_id': p.consignorId,
        'p_order_ids': selected.toList(),
        'p_method': m,
        'p_reference': r,
        'p_note': n,
      });
      _snack('Payout recorded — statement created.');
      await _load();
      openUrl('https://www.gemworkers.com/statements/$id');
    } catch (e) {
      _snack(e, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Payouts')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    _isOwner
                        ? 'What you owe each brother and owner: unpaid sales minus open charges (refunds, chargebacks). '
                          '"Ready" = the 30-day return period is over.'
                        : 'Your sales waiting for payout, charges that will be deducted, and your payout statements.',
                    style: t.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 12),
                  if (_payees.isEmpty)
                    Text('Nothing waiting to be paid.', style: t.bodyLarge?.copyWith(color: AppColors.muted)),
                  for (final p in _payees) _payeeCard(p, t),
                  const SizedBox(height: 20),
                  Text('Statements', style: t.titleMedium),
                  if (_history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('No payouts yet.', style: t.bodyMedium?.copyWith(color: AppColors.muted)),
                    ),
                  for (final h in _history)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.receipt_outlined, color: AppColors.accent),
                      title: Text('${h['number']} · ${(h['data'] as Map?)?['payee'] ?? ''}'),
                      subtitle: Text([
                        DateFormat('d MMM y').format(DateTime.parse(h['paid_at'].toString()).toLocal()),
                        if (h['method'] != null) h['method'],
                        if (h['reference'] != null) h['reference'],
                      ].join(' · ')),
                      trailing: Text(formatEur(parseNumeric(h['amount']) ?? 0), style: t.titleSmall),
                      onTap: () => openUrl('https://www.gemworkers.com/statements/${h['id']}'),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _payeeCard(_Payee p, TextTheme t) {
    final balance = p.sales - p.chargesTotal;
    final readyBalance = p.ready - p.chargesTotal;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(p.name, style: t.titleSmall)),
          Text(formatEur(balance), style: t.titleMedium?.copyWith(color: balance < 0 ? AppColors.error : null)),
        ]),
        Text(
          '${p.lines.length} unpaid sales ${formatEur(p.sales)}'
          '${p.charges.isNotEmpty ? ' − charges ${formatEur(p.chargesTotal)}' : ''}'
          ' · ready now ${formatEur(readyBalance < 0 ? 0 : readyBalance)}',
          style: t.bodySmall?.copyWith(color: AppColors.muted),
        ),
        if (balance < 0)
          Text('Owes you ${formatEur(-balance)} — recovered from the next sales.',
              style: t.bodySmall?.copyWith(color: AppColors.error)),
        if (_isOwner && p.lines.isNotEmpty) ...[
          const SizedBox(height: 8),
          FilledButton.tonal(onPressed: () => _pay(p), child: const Text('Pay…')),
        ],
      ]),
    );
  }
}
