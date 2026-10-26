import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/commission.dart';
import '../../core/utils/money.dart';
import '../../theme/app_theme.dart';

/// Owner-only: what GemWorkers keeps — totals for a period and the same
/// sum per order (sql/earnings_report.sql). Euros, VAT never counted as
/// income, before income tax and fixed costs.
class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

enum EarningsRange { month, quarter, year, all }

/// [from, to) for a period, Amsterdam dates as the SQL expects.
({DateTime from, DateTime to}) earningsRange(EarningsRange r) {
  final now = DateTime.now();
  switch (r) {
    case EarningsRange.month:
      return (from: DateTime(now.year, now.month), to: DateTime(now.year, now.month + 1));
    case EarningsRange.quarter:
      final q = (now.month - 1) ~/ 3;
      return (from: DateTime(now.year, q * 3 + 1), to: DateTime(now.year, q * 3 + 4));
    case EarningsRange.year:
      return (from: DateTime(now.year), to: DateTime(now.year + 1));
    case EarningsRange.all:
      return (from: DateTime(2020), to: DateTime(now.year + 1));
  }
}

Future<Map<String, dynamic>> loadEarnings(EarningsRange r) async {
  final d = earningsRange(r);
  String f(DateTime x) => DateFormat('yyyy-MM-dd').format(x);
  final v = await Supabase.instance.client
      .rpc('earnings_report', params: {'p_from': f(d.from), 'p_to': f(d.to)});
  return Map<String, dynamic>.from(v as Map);
}

class _EarningsPageState extends State<EarningsPage> {
  EarningsRange _range = EarningsRange.quarter;
  late Future<Map<String, dynamic>> _future = loadEarnings(_range);

  void _pick(EarningsRange r) => setState(() {
        _range = r;
        _future = loadEarnings(r);
      });

  static double _n(dynamic v) => parseNumeric(v) ?? 0;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('What GemWorkers earned')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Could not load earnings: ${snap.error}'));
          }
          final data = snap.data;
          final totals = Map<String, dynamic>.from((data?['totals'] as Map?) ?? const {});
          final orders = ((data?['orders'] as List?) ?? const []).cast<Map>().map((m) => m.cast<String, dynamic>()).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final (r, label) in [
                  (EarningsRange.month, 'This month'),
                  (EarningsRange.quarter, 'This quarter'),
                  (EarningsRange.year, 'This year'),
                  (EarningsRange.all, 'All time'),
                ])
                  ChoiceChip(label: Text(label), selected: _range == r, onSelected: (_) => _pick(r)),
              ]),
              const SizedBox(height: 16),
              if (data == null)
                const LinearProgressIndicator()
              else ...[
                _TotalsCard(totals: totals),
                const SizedBox(height: 24),
                Text('Per order', style: t.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Tap an order to see how its amount is made up.',
                    style: t.bodySmall?.copyWith(color: AppColors.muted)),
                const SizedBox(height: 8),
                if (orders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text('No paid orders in this period.', style: t.bodyMedium?.copyWith(color: AppColors.muted)),
                  ),
                for (final o in orders) _OrderTile(o: o),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  final Map<String, dynamic> totals;
  const _TotalsCard({required this.totals});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    double n(String k) => _EarningsPageState._n(totals[k]);
    final earned = n('earned');
    final feePending = (totals['fee_pending'] as num?)?.toInt() ?? 0;
    final costMissing = (totals['cost_missing'] as num?)?.toInt() ?? 0;
    final payoutOpen = n('payout') - n('payout_paid');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(formatEur(earned),
            style: AppTheme.numeric(t.displaySmall,
                fontSize: 34, height: 1, color: earned < 0 ? AppColors.error : AppColors.success)),
        const SizedBox(height: 8),
        Text('GemWorkers keeps · ${totals['orders'] ?? 0} paid orders',
            style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        _Line('Sales (stones + shipping, without VAT)', n('sales')),
        _Line('Refunded to buyers', -n('refunded')),
        _Line('Sellers\' & owners\' share', -n('payout'),
            hint: payoutOpen > 0.004 ? '${formatEur(payoutOpen)} of this still to pay' : null),
        _Line('Refund costs paid back by sellers', n('recovered')),
        _Line('Stripe fees', -n('stripe_fee')),
        _Line('Postage you paid', -n('postage')),
        _Line('Cost of your own stones', -n('stone_cost')),
        _Line('Currency margin (dollar, pound … payments)', n('fx')),
        const Divider(height: 24),
        _Line('GemWorkers keeps', earned, bold: true),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.raised, borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Line('VAT collected (not yours — goes to the tax office)', n('vat')),
            const SizedBox(height: 6),
            Text(
              'Before income tax and before fixed costs (website, insurance, packaging…). '
              'Your accountant works out the income tax from this.',
              style: t.bodySmall?.copyWith(color: AppColors.muted),
            ),
          ]),
        ),
        if (feePending > 0 || costMissing > 0) ...[
          const SizedBox(height: 12),
          if (feePending > 0)
            Text('• $feePending order${feePending == 1 ? '' : 's'}: Stripe hasn\'t reported its fee yet (filled in daily).',
                style: t.bodySmall?.copyWith(color: AppColors.accent)),
          if (costMissing > 0)
            Text('• $costMissing of your own stone${costMissing == 1 ? '' : 's'} sold without a cost price — '
                'fill in "Cost price" on the stone so the profit is right.',
                style: t.bodySmall?.copyWith(color: AppColors.accent)),
        ],
      ]),
    );
  }
}

class _Line extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final String? hint;
  const _Line(this.label, this.value, {this.bold = false, this.hint});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final style = bold ? t.bodyLarge?.copyWith(fontWeight: FontWeight.w700) : t.bodyMedium;
    final shown = value.abs() < 0.005 ? '€0' : (value < 0 ? '− ${formatEur(-value)}' : formatEur(value));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: style),
            if (hint != null) Text(hint!, style: t.bodySmall?.copyWith(color: AppColors.muted)),
          ]),
        ),
        const SizedBox(width: 12),
        Text(shown, style: AppTheme.numeric(style)),
      ]),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final Map<String, dynamic> o;
  const _OrderTile({required this.o});

  static const _kinds = {
    'commission': 'Seller\'s stone (service fee)',
    'consignment': 'Consignment stone',
    'own': 'Your own stone',
  };

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    double n(String k) => _EarningsPageState._n(o[k]);
    final earned = n('earned');
    final paid = DateTime.tryParse('${o['paid_at']}')?.toLocal();
    final sub = [
      if (paid != null) DateFormat('d MMM y').format(paid),
      _kinds[o['kind']] ?? '',
      if (o['status'] == 'refunded') 'refunded',
    ].where((s) => s.isNotEmpty).join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Text('${o['order_number']} · ${o['stone'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(sub, style: t.bodySmall?.copyWith(color: AppColors.muted)),
        trailing: Text(formatEur(earned),
            style: AppTheme.numeric(t.bodyLarge, color: earned < 0 ? AppColors.error : AppColors.ink)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          _Line('Sale (without VAT)', n('sales')),
          if (n('refunded') != 0) _Line('Refunded', -n('refunded')),
          if (n('payout') != 0)
            _Line('Seller\'s / owner\'s share', -n('payout'),
                hint: o['payout_paid'] == true ? 'paid out' : 'still to pay'),
          if (n('recovered') != 0) _Line('Refund costs paid back by seller', n('recovered')),
          o['stripe_fee'] == null
              ? const _Pending('Stripe fee', 'not reported yet')
              : _Line('Stripe fee', -n('stripe_fee')),
          if (n('postage') != 0) _Line('Postage you paid', -n('postage')),
          if (o['kind'] == 'own')
            o['cost_missing'] == true
                ? const _Pending('Cost of the stone', 'no cost price filled in')
                : _Line('Cost of the stone', -n('stone_cost')),
          if (n('fx') != 0) _Line('Currency margin', n('fx')),
          const Divider(height: 16),
          _Line('GemWorkers keeps', earned, bold: true),
          if (n('vat') != 0) _Line('VAT (for the tax office)', n('vat')),
        ],
      ),
    );
  }
}

class _Pending extends StatelessWidget {
  final String label;
  final String note;
  const _Pending(this.label, this.note);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(child: Text(label, style: t.bodyMedium)),
        Text(note, style: t.bodySmall?.copyWith(color: AppColors.accent)),
      ]),
    );
  }
}
