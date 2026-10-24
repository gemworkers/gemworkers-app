import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/decimal_input.dart';
import '../../core/utils/money.dart';
import '../../models/tax_rule.dart';
import '../../repositories/tax_repository.dart';
import '../../theme/app_theme.dart';
import 'company_details_dialog.dart';
import 'invoices_tab.dart';

/// Owner only. Where we ship, the tax & duty rule per destination, extra
/// duties by origin (US tariffs) and shipping prices per route.
/// Starting values are unchecked estimates — tick "Checked" once confirmed.
/// Nothing here charges buyers until the checkout step uses it.
class TaxesPage extends StatefulWidget {
  const TaxesPage({super.key});

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

const _modeLabels = {
  'collect': 'We collect VAT (only when shipped from inside the union)',
  'buyer_pays': 'Buyer pays on delivery (reminder shown)',
  'none': 'Nothing to pay',
};

/// 0.21 → "21", 0.0255 → "2.55", null → ''.
String _pct(double? v) {
  if (v == null) return '';
  final s = (v * 100).toStringAsFixed(2);
  return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
}

/// "21" / "2,5" → 0.21 / 0.025; '' → null.
double? _fromPct(String text) {
  final v = parseDecimalInput(text);
  return v == null ? null : v / 100;
}

class _TaxesPageState extends State<TaxesPage> {
  final _repo = TaxRepository();
  final _search = TextEditingController();

  List<ShipCountry> _countries = [];
  Map<String, TaxRule> _rules = {};
  List<OriginDuty> _origins = [];
  List<ShippingRoute> _routes = [];
  bool _loading = true;
  String _query = '';
  bool _onlyUnchecked = false;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() => _query = _search.text.trim().toLowerCase()));
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _repo.getCountries(),
        _repo.getRules(),
        _repo.getOriginDuties(),
        _repo.getRoutes(),
      ]);
      if (!mounted) return;
      setState(() {
        _countries = results[0] as List<ShipCountry>;
        _rules = results[1] as Map<String, TaxRule>;
        _origins = results[2] as List<OriginDuty>;
        _routes = results[3] as List<ShippingRoute>;
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

  String _countryName(String? code) =>
      _countries.where((c) => c.code == code).map((c) => c.name).firstOrNull ?? code ?? '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Taxes & duties'),
          actions: [
            TextButton.icon(
              onPressed: () => showCompanyDetailsDialog(context),
              icon: const Icon(Icons.business_outlined, size: 18),
              label: const Text('Company details'),
            ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'Countries'),
              Tab(text: 'Tariffs by origin'),
              Tab(text: 'Shipping routes'),
              Tab(text: 'Invoices'),
            ],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                _buildCountries(),
                _buildOrigins(),
                _buildRoutes(),
                const InvoicesTab(),
              ]),
      ),
    );
  }

  // ── Countries ────────────────────────────────────────────────────────────

  Widget _buildCountries() {
    final list = _countries.where((c) {
      if (_query.isNotEmpty &&
          !c.name.toLowerCase().contains(_query) &&
          !c.code.toLowerCase().contains(_query)) {
        return false;
      }
      if (_onlyUnchecked && (_rules[c.code]?.verified ?? false)) return false;
      return true;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  decoration: const InputDecoration(
                    hintText: 'Search country…',
                    prefixIcon: Icon(Icons.search, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilterChip(
                label: const Text('Not checked'),
                selected: _onlyUnchecked,
                onSelected: (v) => setState(() => _onlyUnchecked = v),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            'Starting values are estimates — open a country to correct it and tick "Checked". '
            'We only collect what the law requires (EU VAT on stones shipped from NL); '
            'elsewhere the buyer pays on delivery and checkout shows a reminder. '
            'Countries without a rule: buyer pays, no estimate.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) => _countryTile(list[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _countryTile(ShipCountry c) {
    final rule = _rules[c.code];
    final parts = <String>[
      if (rule == null) 'No rule' else _modeLabels[rule.mode] ?? rule.mode,
      if (rule?.taxRate != null) '${rule!.taxName.isEmpty ? 'Tax' : rule.taxName} ${_pct(rule.taxRate)}%',
      if (rule?.customsUnion.isNotEmpty ?? false) rule!.customsUnion,
      if (rule?.minOrderEur != null) 'min ${formatEur(rule!.minOrderEur!)}',
    ];
    return ListTile(
      onTap: () => _editRule(c),
      leading: Icon(
        rule == null
            ? Icons.remove_circle_outline
            : rule.verified
                ? Icons.verified
                : Icons.help_outline,
        color: rule == null
            ? AppColors.muted
            : rule.verified
                ? AppColors.success
                : AppColors.accent,
      ),
      title: Text('${c.name} (${c.code})'),
      subtitle: Text('${c.region} · ${parts.join(' · ')}', maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Switch(
        value: c.enabled,
        onChanged: (v) async {
          try {
            await _repo.setCountryEnabled(c.code, v);
            _snack(v ? '${c.name}: we ship there now.' : '${c.name}: switched off — buyers can\'t order.');
            _load();
          } catch (e) {
            _snack(e, error: true);
          }
        },
      ),
    );
  }

  Future<void> _editRule(ShipCountry c) async {
    final existing = _rules[c.code];
    final r = existing ?? TaxRule(countryCode: c.code);
    var mode = r.mode;
    var verified = r.verified;
    final taxName = TextEditingController(text: r.taxName);
    final taxRate = TextEditingController(text: _pct(r.taxRate));
    final dLoose = TextEditingController(text: _pct(r.dutyLoose));
    final dJewelry = TextEditingController(text: _pct(r.dutyJewelry));
    final dSpecimen = TextEditingController(text: _pct(r.dutySpecimen));
    final freeBelow = TextEditingController(
        text: r.freeBelowEur == null ? '' : r.freeBelowEur.toString());
    final minOrder = TextEditingController(
        text: r.minOrderEur == null ? '' : r.minOrderEur.toString());
    final union = TextEditingController(text: r.customsUnion);
    final notes = TextEditingController(text: r.notes);

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text('${c.name} (${c.code})'),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: mode,
                    decoration: const InputDecoration(labelText: 'How taxes & duties are handled'),
                    items: _modeLabels.entries
                        .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                        .toList(),
                    onChanged: (v) => setD(() => mode = v ?? mode),
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: _field(taxName, 'Tax name (VAT, GST…)')),
                    const SizedBox(width: 12),
                    Expanded(child: _field(taxRate, 'Tax rate %', number: true)),
                  ]),
                  const SizedBox(height: 4),
                  Text('Import duty % (leave empty if unknown)',
                      style: Theme.of(ctx).textTheme.labelMedium),
                  Row(children: [
                    Expanded(child: _field(dLoose, 'Loose stones', number: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _field(dJewelry, 'Jewellery', number: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _field(dSpecimen, 'Specimens', number: true)),
                  ]),
                  _field(freeBelow, 'No import tax/duty below € (optional)', number: true),
                  _field(minOrder, 'Refuse orders below € (optional, e.g. UK 160)', number: true),
                  _field(union, 'Customs union (e.g. EU — same union = no import)'),
                  _field(notes, 'Notes', lines: 3),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: verified,
                    onChanged: (v) => setD(() => verified = v ?? false),
                    title: const Text('Checked (values confirmed)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (existing != null)
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'delete'),
                child: const Text('Remove rule'),
              ),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, 'save'), child: const Text('Save')),
          ],
        ),
      ),
    );

    try {
      if (action == 'delete') {
        await _repo.deleteRule(c.code);
        _snack('${c.name}: rule removed — buyer pays on delivery.');
        _load();
      } else if (action == 'save') {
        await _repo.saveRule(TaxRule(
          countryCode: c.code,
          mode: mode,
          taxName: taxName.text.trim(),
          taxRate: _fromPct(taxRate.text),
          dutyLoose: _fromPct(dLoose.text),
          dutyJewelry: _fromPct(dJewelry.text),
          dutySpecimen: _fromPct(dSpecimen.text),
          freeBelowEur: parseDecimalInput(freeBelow.text),
          minOrderEur: parseDecimalInput(minOrder.text),
          customsUnion: union.text.trim().toUpperCase(),
          notes: notes.text.trim(),
          verified: verified,
        ));
        _snack('${c.name} saved.');
        _load();
      }
    } catch (e) {
      _snack(e, error: true);
    } finally {
      for (final ctl in [taxName, taxRate, dLoose, dJewelry, dSpecimen, freeBelow, minOrder, union, notes]) {
        ctl.dispose();
      }
    }
  }

  Widget _field(TextEditingController c, String label, {bool number = false, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: c,
        maxLines: lines,
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(labelText: label, isDense: true),
      ),
    );
  }

  // ── Tariffs by origin ────────────────────────────────────────────────────

  Widget _buildOrigins() {
    return Scaffold(
      body: _origins.isEmpty
          ? const Center(child: Text('No origin tariffs yet.'))
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Text(
                  'Extra import duty a destination charges on goods from a specific origin '
                  '(e.g. US tariffs). Added on top of the country\'s base duty.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 8),
                for (final d in _origins)
                  ListTile(
                    onTap: () => _editOrigin(d),
                    leading: Icon(d.verified ? Icons.verified : Icons.help_outline,
                        color: d.verified ? AppColors.success : AppColors.accent),
                    title: Text('${_countryName(d.destCode)} ← from ${_countryName(d.originCode)}'),
                    subtitle: Text(
                        '+${_pct(d.extraDuty)}%${d.notes.isEmpty ? '' : ' · ${d.notes}'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editOrigin(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editOrigin(OriginDuty? d) async {
    final dest = TextEditingController(text: d?.destCode ?? '');
    final origin = TextEditingController(text: d?.originCode ?? '');
    final extra = TextEditingController(text: _pct(d?.extraDuty));
    final notes = TextEditingController(text: d?.notes ?? '');
    var verified = d?.verified ?? false;

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(d == null ? 'Add origin tariff' : 'Edit origin tariff'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _field(dest, 'Destination country code (e.g. US)'),
                _field(origin, 'Ships from country code (e.g. TH)'),
                _field(extra, 'Extra duty %', number: true),
                _field(notes, 'Notes'),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: verified,
                  onChanged: (v) => setD(() => verified = v ?? false),
                  title: const Text('Checked (values confirmed)'),
                ),
              ],
            ),
          ),
          actions: [
            if (d != null)
              TextButton(onPressed: () => Navigator.pop(ctx, 'delete'), child: const Text('Delete')),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, 'save'), child: const Text('Save')),
          ],
        ),
      ),
    );

    try {
      if (action == 'delete' && d != null) {
        await _repo.deleteOriginDuty(d.destCode, d.originCode);
        _load();
      } else if (action == 'save') {
        final rate = _fromPct(extra.text);
        final destCode = dest.text.trim().toUpperCase();
        final originCode = origin.text.trim().toUpperCase();
        if (rate == null || destCode.length != 2 || originCode.length != 2) {
          _snack('Enter two-letter country codes and a duty %.', error: true);
        } else {
          if (d != null && (d.destCode != destCode || d.originCode != originCode)) {
            await _repo.deleteOriginDuty(d.destCode, d.originCode);
          }
          await _repo.saveOriginDuty(OriginDuty(
            destCode: destCode,
            originCode: originCode,
            extraDuty: rate,
            notes: notes.text.trim(),
            verified: verified,
          ));
          _load();
        }
      }
    } catch (e) {
      _snack(e, error: true);
    } finally {
      for (final ctl in [dest, origin, extra, notes]) {
        ctl.dispose();
      }
    }
  }

  // ── Shipping routes ──────────────────────────────────────────────────────

  Widget _buildRoutes() {
    final regions = _countries.map((c) => c.region).toSet().toList()..sort();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Text(
            'Shipping price per route. A country route beats a region route. Until a route '
            'exists, checkout keeps each stone\'s own shipping price.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          if (_routes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No routes yet — tap + to add your courier prices.')),
            ),
          for (final r in _routes)
            ListTile(
              onTap: () => _editRoute(r, regions),
              leading: const Icon(Icons.local_shipping_outlined),
              title: Text(
                  'From ${_countryName(r.originCode)} → ${r.destCode != null ? _countryName(r.destCode) : r.destRegion}'),
              subtitle: Text([
                formatEur(r.priceEur),
                if (r.daysMin != null || r.daysMax != null)
                  '${r.daysMin ?? '?'}–${r.daysMax ?? '?'} days',
                if (r.courier.isNotEmpty) r.courier,
              ].join(' · ')),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editRoute(null, regions),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _editRoute(ShippingRoute? r, List<String> regions) async {
    final origin = TextEditingController(text: r?.originCode ?? '');
    final destCountry = TextEditingController(text: r?.destCode ?? '');
    final price = TextEditingController(text: r == null ? '' : r.priceEur.toString());
    final dMin = TextEditingController(text: r?.daysMin?.toString() ?? '');
    final dMax = TextEditingController(text: r?.daysMax?.toString() ?? '');
    final courier = TextEditingController(text: r?.courier ?? '');
    String? region = r?.destRegion ?? (r == null ? regions.firstOrNull : null);
    var byCountry = r?.destCode != null;

    final action = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(r == null ? 'Add shipping route' : 'Edit shipping route'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _field(origin, 'Ships from country code (NL, TH, PK…)'),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: byCountry,
                    onChanged: (v) => setD(() => byCountry = v),
                    title: Text(byCountry ? 'To one country' : 'To a whole region'),
                  ),
                  if (byCountry)
                    _field(destCountry, 'Destination country code (e.g. US)')
                  else
                    DropdownButtonFormField<String>(
                      initialValue: region,
                      decoration: const InputDecoration(labelText: 'Destination region'),
                      items: regions.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                      onChanged: (v) => setD(() => region = v),
                    ),
                  _field(price, 'Price €', number: true),
                  Row(children: [
                    Expanded(child: _field(dMin, 'Days min', number: true)),
                    const SizedBox(width: 12),
                    Expanded(child: _field(dMax, 'Days max', number: true)),
                  ]),
                  _field(courier, 'Courier (optional)'),
                ],
              ),
            ),
          ),
          actions: [
            if (r?.id != null)
              TextButton(onPressed: () => Navigator.pop(ctx, 'delete'), child: const Text('Delete')),
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, 'save'), child: const Text('Save')),
          ],
        ),
      ),
    );

    try {
      if (action == 'delete' && r?.id != null) {
        await _repo.deleteRoute(r!.id!);
        _load();
      } else if (action == 'save') {
        final originCode = origin.text.trim().toUpperCase();
        final destCode = destCountry.text.trim().toUpperCase();
        final eur = parseDecimalInput(price.text);
        if (originCode.length != 2 || eur == null || (byCountry ? destCode.length != 2 : region == null)) {
          _snack('Enter the origin code, a destination and a price.', error: true);
        } else {
          await _repo.saveRoute(ShippingRoute(
            id: r?.id,
            originCode: originCode,
            destRegion: byCountry ? null : region,
            destCode: byCountry ? destCode : null,
            priceEur: eur,
            daysMin: int.tryParse(dMin.text.trim()),
            daysMax: int.tryParse(dMax.text.trim()),
            courier: courier.text.trim(),
          ));
          _load();
        }
      }
    } catch (e) {
      _snack(e, error: true);
    } finally {
      for (final ctl in [origin, destCountry, price, dMin, dMax, courier]) {
        ctl.dispose();
      }
    }
  }
}
