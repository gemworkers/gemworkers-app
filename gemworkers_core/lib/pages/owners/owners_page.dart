import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/seller_service.dart';
import '../../core/utils/decimal_input.dart';
import '../../models/consignor.dart';
import '../../models/seller.dart';
import '../../repositories/consignor_repository.dart';
import '../../repositories/seller_repository.dart';
import '../../theme/app_theme.dart';

/// Owner only. People whose stones you hold and sell from the Netherlands
/// (a brother, or someone not on GemWorkers). Their stones are listed under
/// My Shop with this owner set on the stone (Edit stone → Who owns this stone).
/// Payout = owner's price + their share of the profit (sql/consignment_setup.sql).
class OwnersPage extends StatefulWidget {
  const OwnersPage({super.key});

  @override
  State<OwnersPage> createState() => _OwnersPageState();
}

class _OwnersPageState extends State<OwnersPage> {
  final _repo = ConsignorRepository();
  final _sellerRepo = SellerRepository();
  List<Consignor> _owners = [];
  List<Seller> _sellers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await Future.wait([_repo.getAll(), _sellerRepo.getSellers()]);
      if (!mounted) return;
      setState(() {
        _owners = r[0] as List<Consignor>;
        _sellers = (r[1] as List<Seller>).where((s) => s.id != kCurrentSellerId).toList();
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(Object msg, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg is PostgrestException ? msg.message : msg.toString()),
      backgroundColor: error ? Theme.of(context).colorScheme.error : null,
    ));
  }

  Future<void> _edit([Consignor? existing]) async {
    final e = existing ?? const Consignor(name: '');
    final name = TextEditingController(text: e.name);
    final country = TextEditingController(text: e.country);
    final email = TextEditingController(text: e.email);
    final phone = TextEditingController(text: e.phone);
    final method = TextEditingController(text: e.payoutMethod);
    final details = TextEditingController(text: e.payoutDetails);
    final notes = TextEditingController(text: e.notes);
    final share = TextEditingController(text: (e.defaultShare * 100).toStringAsFixed(0));
    String? sellerId = e.sellerId;
    var active = e.active;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(existing == null ? 'New owner' : 'Edit owner'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Name *')),
                DropdownButtonFormField<String?>(
                  initialValue: sellerId,
                  decoration: const InputDecoration(labelText: 'Also a seller on GemWorkers? (a brother)'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('No — not on GemWorkers')),
                    for (final s in _sellers) DropdownMenuItem(value: s.id, child: Text(s.name)),
                  ],
                  onChanged: (v) => setD(() => sellerId = v),
                ),
                TextField(controller: country, decoration: const InputDecoration(labelText: 'Country code (e.g. TH, PK, NL)')),
                TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone')),
                TextField(controller: method, decoration: const InputDecoration(labelText: 'How you pay them (Wise, Payoneer, bank)')),
                TextField(controller: details, decoration: const InputDecoration(labelText: 'Payment details (IBAN / Wise email)')),
                TextField(
                  controller: share,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Their share of the profit %',
                    helperText: 'Default for new stones. 50 = profit split in half.',
                  ),
                ),
                TextField(controller: notes, maxLines: 2, decoration: const InputDecoration(labelText: 'Notes')),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: active,
                  onChanged: (v) => setD(() => active = v),
                  title: const Text('Active'),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );

    final pct = parseDecimalInput(share.text);
    final c = Consignor(
      id: e.id,
      name: name.text,
      country: country.text,
      email: email.text,
      phone: phone.text,
      payoutMethod: method.text,
      payoutDetails: details.text,
      notes: notes.text,
      sellerId: sellerId,
      defaultShare: ((pct ?? 50).clamp(0, 100)) / 100,
      active: active,
    );
    for (final t in [name, country, email, phone, method, details, notes, share]) {
      t.dispose();
    }
    if (ok != true) return;
    if (c.name.trim().isEmpty) {
      _snack('Please enter a name.', error: true);
      return;
    }
    try {
      await _repo.save(c);
      _snack('${c.name} saved.');
      _load();
    } catch (err) {
      _snack(err, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Owners')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(),
        icon: const Icon(Icons.add),
        label: const Text('New owner'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                Text(
                  'People whose stones you hold and sell from the Netherlands. Set the owner on the stone '
                  '(Edit stone → Who owns this stone). They get their price + their share of the profit '
                  '(after postage and the Stripe fee). Only you see this list.',
                  style: t.bodySmall?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 12),
                if (_owners.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('No owners yet.', textAlign: TextAlign.center, style: t.bodyLarge?.copyWith(color: AppColors.muted)),
                  ),
                for (final o in _owners)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(o.sellerId != null ? Icons.storefront_outlined : Icons.person_outline,
                        color: o.active ? AppColors.accent : AppColors.muted),
                    title: Text(o.name + (o.active ? '' : '  (inactive)')),
                    subtitle: Text([
                      if (o.sellerId != null)
                        'seller: ${_sellers.where((s) => s.id == o.sellerId).map((s) => s.name).firstOrNull ?? '—'}',
                      if (o.country.isNotEmpty) o.country,
                      'share ${(o.defaultShare * 100).toStringAsFixed(0)}%',
                      if (o.payoutMethod.isNotEmpty) 'paid via ${o.payoutMethod}',
                    ].join(' · ')),
                    trailing: const Icon(Icons.edit_outlined, size: 18),
                    onTap: () => _edit(o),
                  ),
              ],
            ),
    );
  }
}
