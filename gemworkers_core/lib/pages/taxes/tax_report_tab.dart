import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/commission.dart';
import '../../core/utils/download/download_file.dart';
import '../../core/utils/money.dart';
import '../../theme/app_theme.dart';

/// Owner only. Quarterly figures for the Dutch VAT return, the OSS return and
/// the ICP declaration, from invoices + credit notes (sql/tax_report.sql).
/// ACCOUNTANT REVIEW: box mapping and the "shipped from outside NL" group.
class TaxReportTab extends StatefulWidget {
  const TaxReportTab({super.key});

  @override
  State<TaxReportTab> createState() => _TaxReportTabState();
}

class _TaxReportTabState extends State<TaxReportTab> {
  final _supabase = Supabase.instance.client;
  late int _year;
  late int _quarter;
  Map<String, dynamic>? _report;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _quarter = (now.month - 1) ~/ 3 + 1;
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final r = await _supabase.rpc('tax_report', params: {'p_year': _year, 'p_quarter': _quarter});
      if (mounted) setState(() { _report = Map<String, dynamic>.from(r as Map); _loading = false; });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is PostgrestException ? e.message : e.toString();
          _loading = false;
        });
      }
    }
  }

  double _num(dynamic v) => parseNumeric(v) ?? 0;

  Map<String, dynamic> _bucket(String key) =>
      Map<String, dynamic>.from((_report?['buckets'] as Map?)?[key] as Map? ?? const {});

  /// The Dutch return asks for whole euros (rounded down in your favour).
  String _whole(double v) => '€${v.truncate()}'; // whole euros, cents dropped

  void _download() {
    final docs = List<Map<String, dynamic>>.from((_report?['documents'] as List?) ?? const []);
    String cell(Object? v) {
      final s = v?.toString() ?? '';
      return s.contains(RegExp(r'[",;\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
    }
    final lines = <String>[
      'number;type;date;order;group;from;to;buyer_vat;rate;net_eur;vat_eur;total_eur',
      for (final d in docs)
        [
          d['number'], d['kind'], d['date'], d['order'], d['bucket'], d['from'], d['to'],
          d['buyer_vat'], d['rate'], d['net'], d['vat'], d['total'],
        ].map(cell).join(';'),
    ];
    downloadTextFile('gemworkers-tax-$_year-Q$_quarter.csv', lines.join('\n'));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    // This year + next (to look ahead) back to the first year of sales.
    final years = [for (var y = DateTime.now().year + 1; y >= 2026; y--) y];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownButton<int>(
              value: _year,
              items: [for (final y in years) DropdownMenuItem(value: y, child: Text('$y'))],
              onChanged: (v) { if (v != null) { _year = v; _load(); } },
            ),
            DropdownButton<int>(
              value: _quarter,
              items: [for (var q = 1; q <= 4; q++) DropdownMenuItem(value: q, child: Text('Q$q'))],
              onChanged: (v) { if (v != null) { _quarter = v; _load(); } },
            ),
            if (_report != null)
              OutlinedButton.icon(
                onPressed: _download,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Download for accountant (CSV)'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_loading)
          const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
        else if (_error != null)
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))
        else if (_report != null)
          ..._body(t),
      ],
    );
  }

  List<Widget> _body(TextTheme t) {
    final r = _report!;
    final deadline = DateTime.parse(r['deadline'].toString());
    final daysLeft = deadline.difference(DateTime.now()).inDays;
    final domestic = _bucket('domestic');
    final eu = _bucket('eu_b2b');
    final export = _bucket('export');
    final outside = _bucket('outside_nl');
    final oss = List<Map<String, dynamic>>.from((r['oss'] as List?) ?? const []);
    final icp = List<Map<String, dynamic>>.from((r['icp'] as List?) ?? const []);
    final fmt = DateFormat('d MMMM y');

    return [
      Text('${fmt.format(DateTime.parse(r['from']))} – ${fmt.format(DateTime.parse(r['to']))}', style: t.titleMedium),
      Text(
        'File by ${fmt.format(deadline)}'
        '${daysLeft >= 0 ? ' ($daysLeft days left)' : ' — past the deadline'}'
        ' · ${r['invoices']} invoices, ${r['credit_notes']} credit notes',
        style: t.bodySmall?.copyWith(color: daysLeft < 14 ? AppColors.error : AppColors.muted),
      ),
      const SizedBox(height: 16),

      _card(t, 'Dutch VAT return (aangifte omzetbelasting)', [
        _row(t, '1a  Sales taxed at 21%', 'Turnover ${_whole(_num(domestic['net']))} · VAT ${_whole(_num(domestic['vat']))}',
            exact: '${formatEur(_num(domestic['net']))} + ${formatEur(_num(domestic['vat']))} VAT'),
        _row(t, '3a  Exports outside the EU (0%)', _whole(_num(export['net'])), exact: formatEur(_num(export['net']))),
        _row(t, '3b  Sales to EU businesses (reverse charge)', _whole(_num(eu['net'])), exact: formatEur(_num(eu['net']))),
        Text('EU sales to private buyers are NOT entered here — they go in the OSS return below.',
            style: t.bodySmall?.copyWith(color: AppColors.muted)),
      ]),

      _card(t, 'OSS return (Unieregeling)', [
        if (oss.isEmpty)
          Text('No EU consumer sales this quarter — file a nil ("nihil") OSS return.', style: t.bodyMedium)
        else ...[
          for (final o in oss)
            _row(t, '${o['name'] ?? o['country']} (${o['country']}) · ${_pct(o['rate'])}%',
                'Sales ${formatEur(_num(o['net']))} · VAT ${formatEur(_num(o['vat']))}'),
          const Divider(),
          _row(t, 'Total VAT to pay via OSS',
              formatEur(oss.fold<double>(0, (s, o) => s + _num(o['vat'])))),
        ],
      ]),

      _card(t, 'ICP declaration (opgaaf intracommunautaire prestaties)', [
        if (icp.isEmpty)
          Text('No sales to EU businesses — nothing to declare.', style: t.bodyMedium)
        else
          for (final i in icp)
            _row(t, '${i['vat']}${i['company'] != null ? ' · ${i['company']}' : ''}', _whole(_num(i['amount'])),
                exact: formatEur(_num(i['amount']))),
      ]),

      _card(t, 'Shipped from Thailand / Pakistan (not in the Dutch return)', [
        _row(t, '${outside['count'] ?? 0} documents', formatEur(_num(outside['net']))),
        Text('Sold outside the Netherlands — no Dutch VAT. Keep for your bookkeeping; ask your accountant how to record them.',
            style: t.bodySmall?.copyWith(color: AppColors.muted)),
      ]),

      Text('Starting setup — have your accountant check this report before your first filing.',
          style: t.bodySmall?.copyWith(color: AppColors.muted)),
    ];
  }

  String _pct(dynamic v) {
    final d = parseNumeric(v);
    if (d == null) return '?';
    final s = (d * 100).toStringAsFixed(2);
    return s.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  Widget _card(TextTheme t, String title, List<Widget> children) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: t.titleSmall),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      );

  Widget _row(TextTheme t, String label, String value, {String? exact}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(label, style: t.bodyMedium)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SelectableText(value, style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                if (exact != null) Text('exact: $exact', style: t.bodySmall?.copyWith(color: AppColors.muted)),
              ],
            ),
          ],
        ),
      );
}
