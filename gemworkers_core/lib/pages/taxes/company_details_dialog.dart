import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Owner only. GemWorkers' own details printed on every invoice
/// (store_settings company_*; sql/invoices_setup.sql). Each invoice keeps the
/// details it was issued with, so fill this in before the first real sale.
Future<void> showCompanyDetailsDialog(BuildContext context) async {
  final supabase = Supabase.instance.client;
  const keys = ['company_name', 'company_address', 'company_kvk', 'company_vat', 'company_email'];

  Map<String, String> current = {};
  try {
    final rows = await supabase.from('store_settings').select('key, value').inFilter('key', keys);
    current = {for (final r in rows) r['key'].toString(): r['value']?.toString() ?? ''};
  } catch (_) {}
  if (!context.mounted) return;

  final c = {
    for (final k in keys) k: TextEditingController(text: current[k] ?? ''),
  };
  if (c['company_name']!.text.isEmpty) c['company_name']!.text = 'GemWorkers';
  if (c['company_email']!.text.isEmpty) c['company_email']!.text = 'hello@gemworkers.com';

  final save = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Company details (on invoices)'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: c['company_name'], decoration: const InputDecoration(labelText: 'Business name')),
              const SizedBox(height: 8),
              TextField(
                controller: c['company_address'],
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Business address (virtual office)', alignLabelWithHint: true),
              ),
              const SizedBox(height: 8),
              TextField(controller: c['company_kvk'], decoration: const InputDecoration(labelText: 'KvK number')),
              const SizedBox(height: 8),
              TextField(
                controller: c['company_vat'],
                decoration: const InputDecoration(
                  labelText: 'BTW-id / VAT number',
                  hintText: 'NL123456789B01',
                  helperText: 'The btw-identificatienummer — not the omzetbelastingnummer.',
                ),
              ),
              const SizedBox(height: 8),
              TextField(controller: c['company_email'], decoration: const InputDecoration(labelText: 'Email on invoices')),
              const SizedBox(height: 12),
              const Text(
                'New invoices use these details. Invoices already issued keep the details they had.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
      ],
    ),
  );

  if (save == true) {
    final now = DateTime.now().toIso8601String();
    try {
      await supabase.from('store_settings').upsert([
        for (final k in keys)
          {
            'key': k,
            'value': k == 'company_vat'
                ? c[k]!.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '')
                : c[k]!.text.trim(),
            'updated_at': now,
          },
      ], onConflict: 'key');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Company details saved.')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e is PostgrestException ? e.message : e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }
  }
  for (final ctl in c.values) {
    ctl.dispose();
  }
}
