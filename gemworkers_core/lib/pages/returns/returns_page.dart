import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/decimal_input.dart';
import '../../core/utils/money.dart';
import '../../models/return_request.dart';
import '../../repositories/return_repository.dart';
import '../../theme/app_theme.dart';

enum _ReturnsTab {
  requested('New', ['requested'], 'No new return requests.'),
  approved('On the way', ['approved'], 'No returns on the way back.'),
  received('To refund', ['received'], 'Nothing waiting for a refund.'),
  closed('Closed', ['refunded', 'rejected', 'withdrawn', 'expired'], 'No closed returns yet.');

  final String label;
  final List<String> statuses;
  final String emptyMessage;
  const _ReturnsTab(this.label, this.statuses, this.emptyMessage);
}

/// Owner only. Approve → stone comes back → mark received → refund
/// (Stripe, through the store). sql/returns_setup.sql.
class ReturnsPage extends StatefulWidget {
  final VoidCallback? onOpenChanged;
  const ReturnsPage({super.key, this.onOpenChanged});

  @override
  State<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends State<ReturnsPage> with SingleTickerProviderStateMixin {
  final _repo = ReturnRepository();
  late final TabController _tabs;
  List<ReturnRequest> _returns = [];
  bool _loading = true;
  String? _saving;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _ReturnsTab.values.length, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _repo.getReturns();
      if (mounted) setState(() { _returns = list; _loading = false; _saving = null; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
    widget.onOpenChanged?.call();
  }

  void _snack(Object msg, {bool error = false}) {
    if (!mounted) return;
    final text = msg is PostgrestException
        ? msg.message
        : msg.toString().replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: error ? Theme.of(context).colorScheme.error : null,
    ));
  }

  Future<void> _run(ReturnRequest r, Future<void> Function() action, String done) async {
    setState(() => _saving = r.id);
    try {
      await action();
      _snack(done);
      _load();
    } catch (e) {
      setState(() => _saving = null);
      _snack(e, error: true);
    }
  }

  /// Text dialog; returns null on cancel.
  Future<String?> _askText(String title, String hint, String button, {bool required = false}) {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 420,
            child: TextField(
              controller: c,
              autofocus: true,
              maxLines: 4,
              maxLength: 1000,
              onChanged: (_) => setD(() {}),
              decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder()),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: required && c.text.trim().isEmpty ? null : () => Navigator.pop(ctx, c.text.trim()),
              child: Text(button),
            ),
          ],
        ),
      ),
    ).whenComplete(c.dispose);
  }

  Future<void> _approve(ReturnRequest r) async {
    final note = await _askText('Approve return', 'Optional note for the buyer (shown in the email).', 'Approve');
    if (note == null) return;
    _run(r, () => _repo.approve(r.id, note), 'Approved — the buyer got the return address by email.');
  }

  Future<void> _reject(ReturnRequest r) async {
    final note = await _askText('Reject return', 'Reason for the buyer (required).', 'Reject', required: true);
    if (note == null) return;
    _run(r, () => _repo.reject(r.id, note), 'Rejected — the buyer was told why.');
  }

  Future<void> _received(ReturnRequest r) async {
    final note = await _askText('Stone received back', 'Condition of the stone (only you see this).', 'Mark received');
    if (note == null) return;
    _run(r, () => _repo.markReceived(r.id, note), 'Marked received. Check it, then refund.');
  }

  Future<void> _refund(ReturnRequest r) async {
    final deduction = TextEditingController();
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        final d = parseDecimalInput(deduction.text) ?? 0;
        final refund = ((r.paid * 100).round() - (d * 100).round()) / 100;
        final valid = d >= 0 && refund > 0 && (d == 0 || reason.text.trim().isNotEmpty);
        return AlertDialog(
          title: const Text('Refund'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buyer paid ${formatEur(r.paid)}'
                    '${r.tax > 0 ? ' (incl. ${formatEur(r.tax)} VAT)' : ''}, shipping included.'),
                const SizedBox(height: 12),
                TextField(
                  controller: deduction,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setD(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Deduction € (only for damage / loss in value)',
                    hintText: '0',
                  ),
                ),
                if (d > 0)
                  TextField(
                    controller: reason,
                    maxLength: 500,
                    onChanged: (_) => setD(() {}),
                    decoration: const InputDecoration(labelText: 'Reason for the deduction (shown to the buyer)'),
                  ),
                const SizedBox(height: 12),
                Text('Refund to the buyer: ${formatEur(refund < 0 ? 0 : refund)}',
                    style: Theme.of(ctx).textTheme.titleMedium),
                if (r.payoutStatus == 'paid')
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('You already paid the seller for this stone — recover it from their next payout.',
                        style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: valid ? () => Navigator.pop(ctx, true) : null,
              child: Text('Refund ${formatEur(refund < 0 ? 0 : refund)}'),
            ),
          ],
        );
      }),
    );
    final d = parseDecimalInput(deduction.text) ?? 0;
    final why = reason.text.trim();
    deduction.dispose();
    reason.dispose();
    if (ok != true || !mounted) return;
    setState(() => _saving = r.id);
    try {
      final amount = await _repo.refund(r.id, d, why);
      _snack('Refunded ${formatEur(amount)} — the buyer got an email. The stone is back in Listings (not listed).');
      _load();
    } catch (e) {
      setState(() => _saving = null);
      _snack(e, error: true);
    }
  }

  Future<void> _editAddress() async {
    final current = await _repo.getReturnAddress().catchError((_) => '');
    if (!mounted) return;
    final c = TextEditingController(text: current);
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Return address'),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: c,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'GemWorkers Returns\nStreet 1\n1234 AB City\nNetherlands',
              helperText: 'Sent to buyers when you approve a return. Never a seller address.',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
        ],
      ),
    );
    c.dispose();
    if (text == null) return;
    try {
      await _repo.setReturnAddress(text);
      _snack('Return address saved.');
    } catch (e) {
      _snack(e, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Returns'),
        actions: [
          TextButton.icon(
            onPressed: _editAddress,
            icon: const Icon(Icons.home_work_outlined, size: 18),
            label: const Text('Return address'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            for (final t in _ReturnsTab.values)
              Tab(text: '${t.label}  ${_returns.where((r) => t.statuses.contains(r.status)).length}'),
          ],
        ),
      ),
      body: _loading && _returns.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [for (final t in _ReturnsTab.values) _list(t)],
            ),
    );
  }

  Widget _list(_ReturnsTab tab) {
    final list = _returns.where((r) => tab.statuses.contains(r.status)).toList();
    if (list.isEmpty) {
      return Center(
        child: Text(tab.emptyMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.muted)),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _card(list[i]),
      ),
    );
  }

  Widget _card(ReturnRequest r) {
    final t = Theme.of(context).textTheme;
    final busy = _saving == r.id;
    final idle = _saving == null;
    final date = DateFormat('d MMM y').format(r.requestedAt.toLocal());
    String line(String label, String value) => '$label: $value';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(
                [if (r.stoneTitle.isNotEmpty) r.stoneTitle, if (r.stoneSku.isNotEmpty) r.stoneSku].join(' · '),
                style: t.titleSmall,
              ),
            ),
            Text(date, style: t.bodySmall?.copyWith(color: AppColors.muted)),
          ]),
          Text(
            [
              r.orderNumber,
              'paid ${formatEur(r.paid)}',
              if (r.customerType == 'business') 'business${r.buyerCompany.isNotEmpty ? ': ${r.buyerCompany}' : ''}',
              r.status,
            ].join(' · '),
            style: t.bodySmall?.copyWith(color: AppColors.muted),
          ),
          if (r.faulty) ...[
            const SizedBox(height: 6),
            Text('Buyer says: damaged or not as described (we pay return shipping)',
                style: t.bodySmall?.copyWith(color: AppColors.error)),
          ],
          if (r.reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectableText(line('Reason', r.reason), style: t.bodyMedium),
          ],
          if (r.returnTracking.isNotEmpty)
            SelectableText(line('Return tracking', r.returnTracking), style: t.bodySmall),
          if (r.conditionNote.isNotEmpty)
            Text(line('Condition', r.conditionNote), style: t.bodySmall),
          if (r.decisionNote.isNotEmpty)
            Text(line('Note to buyer', r.decisionNote), style: t.bodySmall),
          if (r.status == 'refunded') ...[
            const SizedBox(height: 6),
            Text(
              'Refunded ${formatEur(r.refundAmount ?? 0)}'
              '${r.refundedAt != null ? ' on ${DateFormat('d MMM y').format(r.refundedAt!.toLocal())}' : ''}'
              '${r.deduction > 0 ? ' (deducted ${formatEur(r.deduction)}: ${r.deductionReason})' : ''}',
              style: t.bodySmall?.copyWith(color: AppColors.success),
            ),
            if ((r.payoutClawback ?? 0) > 0)
              Text('Recover ${formatEur(r.payoutClawback!)} from the seller (payout was already paid).',
                  style: t.bodySmall?.copyWith(color: AppColors.error)),
          ],
          if (['requested', 'approved', 'received'].contains(r.status)) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (r.status == 'requested')
                FilledButton(onPressed: idle ? () => _approve(r) : null, child: _label('Approve', busy)),
              if (r.status == 'approved')
                FilledButton(onPressed: idle ? () => _received(r) : null, child: _label('Stone received', busy)),
              if (r.status == 'received')
                FilledButton(onPressed: idle ? () => _refund(r) : null, child: _label('Refund', busy)),
              OutlinedButton(onPressed: idle ? () => _reject(r) : null, child: const Text('Reject')),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _label(String text, bool busy) => busy
      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
      : Text(text);
}
