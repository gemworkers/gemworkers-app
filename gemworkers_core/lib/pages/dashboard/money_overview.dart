import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/commission.dart';
import '../../core/utils/money.dart';
import '../../theme/app_theme.dart';
import 'earnings_page.dart';

/// Owner-only "Money" section on the Dashboard: what you owe sellers and
/// owners (sql/payouts_setup.sql), VAT for this quarter and its deadline
/// (sql/tax_report.sql), open returns and chargebacks. Each card opens the
/// page where you act on it.
class MoneyOverview extends StatefulWidget {
  final VoidCallback onPayouts;
  final VoidCallback onReturns;
  final VoidCallback onTaxes;
  final VoidCallback onOrders;
  const MoneyOverview({
    super.key,
    required this.onPayouts,
    required this.onReturns,
    required this.onTaxes,
    required this.onOrders,
  });

  @override
  State<MoneyOverview> createState() => MoneyOverviewState();
}

class MoneyOverviewState extends State<MoneyOverview> {
  final _sb = Supabase.instance.client;
  bool _loading = true;

  double _owed = 0, _ready = 0, _charges = 0;
  int _payees = 0;
  double _vat = 0;
  DateTime? _deadline;
  String _quarter = '';
  int _returnsOpen = 0, _returnsToRefund = 0;
  int _disputes = 0;
  double? _earned;
  int _earnedOrders = 0;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    setState(() => _loading = true);
    final now = DateTime.now();
    final q = (now.month - 1) ~/ 3 + 1;
    try {
      final r = await Future.wait<dynamic>([
        _sb.from('payout_lines').select('amount, ready, payee_seller_id, payee_consignor_id'),
        _sb.from('payout_open_charges').select('amount'),
        _sb.rpc('tax_report', params: {'p_year': now.year, 'p_quarter': q}),
        _sb.from('returns').select('status').inFilter('status', ['requested', 'approved', 'received']),
        _sb.from('orders').select('id').eq('dispute_status', 'open'),
        loadEarnings(EarningsRange.quarter).then<Map<String, dynamic>?>((v) => v).catchError((_) => null),
      ]);
      final earnings = r[5] as Map<String, dynamic>?;
      final earnedTotals = (earnings?['totals'] as Map?) ?? const {};
      final lines = List<Map<String, dynamic>>.from(r[0] as List);
      final charges = List<Map<String, dynamic>>.from(r[1] as List);
      final report = Map<String, dynamic>.from(r[2] as Map);
      final returns = List<Map<String, dynamic>>.from(r[3] as List);
      final disputes = r[4] as List;

      double sum(Iterable<Map<String, dynamic>> xs) => xs.fold(0, (s, x) => s + (parseNumeric(x['amount']) ?? 0));
      final buckets = Map<String, dynamic>.from((report['buckets'] as Map?) ?? const {});
      double vatOf(String k) => parseNumeric((buckets[k] as Map?)?['vat']) ?? 0;

      if (!mounted) return;
      setState(() {
        _owed = sum(lines);
        _ready = sum(lines.where((l) => l['ready'] == true));
        _charges = sum(charges);
        _payees = {
          for (final l in lines) '${l['payee_seller_id'] ?? ''}|${l['payee_consignor_id'] ?? ''}',
        }.length;
        _vat = vatOf('domestic') + vatOf('oss');
        _deadline = DateTime.tryParse(report['deadline']?.toString() ?? '');
        _quarter = 'Q$q ${now.year}';
        _returnsOpen = returns.where((x) => x['status'] != 'received').length;
        _returnsToRefund = returns.where((x) => x['status'] == 'received').length;
        _disputes = disputes.length;
        _earned = earnings == null ? null : parseNumeric(earnedTotals['earned']) ?? 0;
        _earnedOrders = (earnedTotals['orders'] as num?)?.toInt() ?? 0;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Money overview: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final daysLeft = _deadline?.difference(DateTime.now()).inDays;
    final toPay = _ready - _charges;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text('Money', style: t.titleLarge),
        ),
        if (_loading)
          const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator())
        else
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth >= 900 ? 4 : c.maxWidth >= 560 ? 2 : 1;
            final w = (c.maxWidth - (cols - 1) * 16) / cols;
            return Wrap(spacing: 16, runSpacing: 16, children: [
              for (final card in [
                if (_earned != null)
                  _MoneyCard(
                    value: formatEur(_earned!),
                    label: 'GemWorkers earned · $_quarter',
                    hint: '$_earnedOrders paid orders · after sellers, Stripe and refunds, without VAT',
                    alert: _earned! < 0,
                    link: 'See totals and per order',
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const EarningsPage())),
                  ),
                _MoneyCard(
                  value: formatEur(_owed - _charges),
                  label: 'Owed to sellers & owners',
                  hint: _payees == 0
                      ? 'Nothing waiting'
                      : '$_payees ${_payees == 1 ? 'person' : 'people'} · ready to pay now ${formatEur(toPay < 0 ? 0 : toPay)}',
                  alert: _owed - _charges < 0,
                  link: 'Open Payouts',
                  onTap: widget.onPayouts,
                ),
                _MoneyCard(
                  value: formatEur(_vat),
                  label: 'VAT to pay · $_quarter',
                  hint: _deadline == null
                      ? null
                      : 'File by ${DateFormat('d MMM y').format(_deadline!)}'
                          '${daysLeft != null && daysLeft >= 0 ? ' · $daysLeft days left' : ''}',
                  alert: daysLeft != null && daysLeft < 14,
                  link: 'Open Tax report',
                  onTap: widget.onTaxes,
                ),
                _MoneyCard(
                  value: '${_returnsOpen + _returnsToRefund}',
                  label: 'Open returns',
                  hint: _returnsToRefund > 0
                      ? '$_returnsToRefund received — waiting for your refund'
                      : _returnsOpen > 0 ? 'Waiting for you or on the way back' : 'All caught up',
                  alert: _returnsToRefund > 0,
                  link: 'Open Returns',
                  onTap: widget.onReturns,
                ),
                _MoneyCard(
                  value: '$_disputes',
                  label: 'Open chargebacks',
                  hint: _disputes > 0 ? 'Send your evidence in Stripe before the deadline' : 'None',
                  alert: _disputes > 0,
                  link: 'Open Orders',
                  onTap: widget.onOrders,
                ),
              ])
                SizedBox(width: w, child: card),
            ]);
          }),
      ],
    );
  }
}

class _MoneyCard extends StatelessWidget {
  final String value;
  final String label;
  final String? hint;
  final bool alert;
  final String link;
  final VoidCallback onTap;
  const _MoneyCard({
    required this.value,
    required this.label,
    required this.link,
    required this.onTap,
    this.hint,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(value,
                style: AppTheme.numeric(t.displaySmall,
                    fontSize: 32, height: 1, color: alert ? AppColors.error : AppColors.ink)),
            const SizedBox(height: 10),
            Text(label, style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            if (hint != null) ...[
              const SizedBox(height: 2),
              Text(hint!, style: t.bodySmall?.copyWith(color: alert ? AppColors.error : AppColors.muted)),
            ],
            const SizedBox(height: 14),
            Text('$link →', style: t.labelLarge?.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
