import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/download/download_file.dart';
import '../../theme/app_theme.dart';

/// Owner only: people who signed up for "New stones, first" emails
/// (sql/newsletter.sql, double opt-in). Only 'confirmed' may be emailed.
class SubscribersPage extends StatefulWidget {
  const SubscribersPage({super.key});

  @override
  State<SubscribersPage> createState() => _SubscribersPageState();
}

class _SubscribersPageState extends State<SubscribersPage> {
  late Future<List<Map<String, dynamic>>> _future = _load();

  Future<List<Map<String, dynamic>>> _load() async {
    final rows = await Supabase.instance.client
        .from('newsletter_subscribers')
        .select('email, status, source, signed_up_at, confirmed_at, unsubscribed_at')
        .order('signed_up_at', ascending: false);
    return (rows as List).cast<Map<String, dynamic>>();
  }

  String _date(dynamic v) =>
      v == null ? '' : DateFormat('d MMM yyyy').format(DateTime.parse(v.toString()).toLocal());

  void _export(List<Map<String, dynamic>> rows) {
    final confirmed = rows.where((r) => r['status'] == 'confirmed');
    final csv = StringBuffer('email,confirmed_at,source\n');
    for (final r in confirmed) {
      csv.writeln('${r['email']},${r['confirmed_at'] ?? ''},${r['source'] ?? ''}');
    }
    downloadTextFile('gemworkers-subscribers.csv', csv.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribers'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _future = _load()),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Could not load subscribers: ${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final rows = snap.data!;
          int count(String s) => rows.where((r) => r['status'] == s).length;
          final textTheme = Theme.of(context).textTheme;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Wrap(spacing: 12, runSpacing: 12, children: [
                _Stat('Confirmed', count('confirmed'), 'can be emailed'),
                _Stat('Waiting', count('pending'), 'haven\'t clicked the link yet'),
                _Stat('Unsubscribed', count('unsubscribed'), 'never email again'),
              ]),
              const SizedBox(height: 12),
              Text(
                'Only confirmed subscribers may get marketing emails. Their confirmation date is the '
                'proof of consent the law asks for.',
                style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: count('confirmed') == 0 ? null : () => _export(rows),
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download confirmed (CSV)'),
                ),
              ),
              const SizedBox(height: 16),
              if (rows.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('No sign-ups yet. The box is at the bottom of every shop page.')),
                ),
              for (final r in rows)
                Card(
                  child: ListTile(
                    title: Text(r['email'].toString()),
                    subtitle: Text(switch (r['status']) {
                      'confirmed' => 'Confirmed ${_date(r['confirmed_at'])}',
                      'pending' => 'Waiting for confirmation · signed up ${_date(r['signed_up_at'])}',
                      _ => 'Unsubscribed ${_date(r['unsubscribed_at'])}',
                    }),
                    trailing: Icon(
                      switch (r['status']) {
                        'confirmed' => Icons.check_circle,
                        'pending' => Icons.hourglass_empty,
                        _ => Icons.block,
                      },
                      color: r['status'] == 'confirmed' ? AppColors.accent : AppColors.muted,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final String hint;
  const _Stat(this.label, this.value, this.hint);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('$value', style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          Text(label, style: t.titleSmall),
          Text(hint, style: t.bodySmall?.copyWith(color: AppColors.muted)),
        ]),
      ),
    );
  }
}
