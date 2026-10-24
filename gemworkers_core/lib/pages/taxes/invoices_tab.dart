import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/commission.dart';
import '../../core/utils/money.dart';
import '../../core/utils/open_url/open_url.dart';
import '../../theme/app_theme.dart';

/// Owner only. Every invoice and credit note (sql/invoices_setup.sql), newest
/// first. Opening one shows the printable page on the store (log in there
/// with the same owner account).
class InvoicesTab extends StatefulWidget {
  const InvoicesTab({super.key});

  @override
  State<InvoicesTab> createState() => _InvoicesTabState();
}

class _InvoicesTabState extends State<InvoicesTab> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _rows = [];
  bool _loading = true;

  static const _schemeLabels = {
    'domestic': 'NL VAT',
    'oss': 'EU VAT (OSS)',
    'reverse_charge': 'Reverse charge',
    'buyer_pays': 'No VAT (export / outside NL)',
    'none': 'No VAT',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final rows = await _supabase
          .from('invoices')
          .select('id, number, kind, issued_at, total, tax_amount, tax_scheme, ship_to_country, orders(order_number)')
          .order('issued_at', ascending: false)
          .limit(1000);
      if (mounted) setState(() { _rows = List<Map<String, dynamic>>.from(rows); _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    final t = Theme.of(context).textTheme;
    if (_rows.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No invoices yet. Every paid order gets one automatically, numbered GW-${DateTime.now().year}-00001 onwards.',
            textAlign: TextAlign.center,
            style: t.bodyLarge?.copyWith(color: AppColors.muted),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        itemCount: _rows.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final r = _rows[i];
          final credit = r['kind'] == 'credit_note';
          final total = parseNumeric(r['total']) ?? 0;
          final vat = parseNumeric(r['tax_amount']) ?? 0;
          final order = (r['orders'] as Map<String, dynamic>?)?['order_number'] ?? '';
          final date = DateFormat('d MMM y').format(DateTime.parse(r['issued_at'].toString()).toLocal());
          return ListTile(
            leading: Icon(credit ? Icons.undo : Icons.receipt_long_outlined,
                color: credit ? AppColors.error : AppColors.accent),
            title: Text('${r['number']}${credit ? '  (credit note)' : ''}'),
            subtitle: Text([
              date,
              order,
              _schemeLabels[r['tax_scheme']] ?? 'VAT',
              if (r['ship_to_country'] != null) 'to ${r['ship_to_country']}',
              if (vat != 0) 'VAT ${formatEur(vat)}',
            ].join(' · ')),
            trailing: Text(formatEur(total), style: t.titleSmall),
            onTap: () => openUrl('https://www.gemworkers.com/invoices/${r['id']}'),
          );
        },
      ),
    );
  }
}
