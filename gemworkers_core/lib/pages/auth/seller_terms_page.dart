import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/user_profile_service.dart';
import '../../theme/app_theme.dart';

// Seller terms (sql/seller_terms.sql): every seller agrees to the current
// version before using the admin; a new version must be agreed again. The
// text has {fee} and {your country}, filled in here from the seller's row.

class SellerTerms {
  final String version;
  final String title;
  final String body;     // filled in for this seller
  final String company;  // company details shown under the terms
  final DateTime? acceptedAt;
  const SellerTerms(this.version, this.title, this.body, this.company, this.acceptedAt);
}

final _db = Supabase.instance.client;

Future<SellerTerms?> loadSellerTerms() async {
  final terms = await _db
      .from('seller_terms')
      .select('version, title, body')
      .eq('is_current', true)
      .maybeSingle();
  if (terms == null) return null;
  final uid = _db.auth.currentUser?.id;
  final accepted = uid == null
      ? null
      : await _db
          .from('seller_terms_acceptances')
          .select('accepted_at')
          .eq('user_id', uid)
          .eq('version', terms['version'] as String)
          .maybeSingle();

  // {fee} and {your country} from the seller's own row.
  var fee = '—';
  var country = 'your country';
  final sellerId = UserProfileService.instance.sellerId;
  if (sellerId != null) {
    final s = await _db.from('sellers').select('commission_rate, country').eq('id', sellerId).maybeSingle();
    final rate = double.tryParse('${s?['commission_rate'] ?? ''}');
    if (rate != null) {
      final pct = rate * 100;
      fee = pct == pct.roundToDouble() ? pct.toStringAsFixed(0) : pct.toStringAsFixed(1);
    }
    final code = s?['country']?.toString();
    if (code != null && code.isNotEmpty) {
      final c = await _db.from('shipping_countries').select('name').eq('code', code).maybeSingle();
      country = c?['name']?.toString() ?? code;
    }
  }
  final co = await _db.from('public_company_info').select().maybeSingle();
  final company = co == null
      ? ''
      : [
          co['name'],
          co['address'],
          if (co['kvk'] != null) 'KvK ${co['kvk']}',
          if (co['vat'] != null) 'VAT ${co['vat']}',
          co['email'],
        ].where((v) => v != null && '$v'.trim().isNotEmpty).join('\n');

  return SellerTerms(
    terms['version'] as String,
    terms['title'] as String,
    (terms['body'] as String).replaceAll('{fee}', fee).replaceAll('{your country}', country),
    company,
    accepted?['accepted_at'] != null ? DateTime.parse(accepted!['accepted_at'].toString()) : null,
  );
}

/// Shows [child] once the seller has agreed to the current terms; before that
/// only the terms with "I agree". Owners pass straight through.
class SellerTermsGate extends StatefulWidget {
  final Widget child;
  const SellerTermsGate({super.key, required this.child});

  @override
  State<SellerTermsGate> createState() => _SellerTermsGateState();
}

class _SellerTermsGateState extends State<SellerTermsGate> {
  late Future<SellerTerms?> _future = loadSellerTerms();
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    if (UserProfileService.instance.isOwner || _agreed) return widget.child;
    return FutureBuilder<SellerTerms?>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          return Scaffold(
            body: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Could not load the seller terms.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => setState(() => _future = loadSellerTerms()),
                  child: const Text('Try again'),
                ),
              ]),
            ),
          );
        }
        final terms = snap.data;
        // No terms published (or already agreed): straight in.
        if (terms == null || terms.acceptedAt != null) return widget.child;
        return SellerTermsPage(terms: terms, onAgreed: () => setState(() => _agreed = true));
      },
    );
  }
}

/// The terms text. With [onAgreed]: the "I agree" screen; without: read-only
/// (Account menu → Seller terms), showing when the seller agreed.
class SellerTermsPage extends StatefulWidget {
  final SellerTerms terms;
  final VoidCallback? onAgreed;
  const SellerTermsPage({super.key, required this.terms, this.onAgreed});

  @override
  State<SellerTermsPage> createState() => _SellerTermsPageState();
}

class _SellerTermsPageState extends State<SellerTermsPage> {
  bool _ticked = false;
  bool _saving = false;

  Future<void> _agree() async {
    setState(() => _saving = true);
    try {
      await _db.rpc('accept_seller_terms', params: {'p_version': widget.terms.version});
      widget.onAgreed?.call();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.terms;
    final accepting = widget.onAgreed != null;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title),
        automaticallyImplyLeading: !accepting,
        actions: [
          if (accepting)
            TextButton(
              onPressed: () async {
                UserProfileService.instance.clear();
                await AuthService.signOut();
              },
              child: const Text('Sign out'),
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (accepting)
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Welcome to GemWorkers. Please read the seller terms below. '
                      'You can start using the admin after you agree.',
                    ),
                  ),
                ),
              if (!accepting && t.acceptedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'You agreed to this version (${t.version}) on '
                    '${DateFormat('d MMMM yyyy, HH:mm').format(t.acceptedAt!.toLocal())}.',
                    style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                ),
              const SizedBox(height: 8),
              ..._renderTerms(t.body, textTheme),
              if (t.company.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text('Company details', style: textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(t.company, style: textTheme.bodyMedium),
              ],
              const SizedBox(height: 8),
              Text('Version ${t.version}', style: textTheme.bodySmall?.copyWith(color: AppColors.muted)),
              if (accepting) ...[
                const SizedBox(height: 24),
                CheckboxListTile(
                  value: _ticked,
                  onChanged: _saving ? null : (v) => setState(() => _ticked = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text('I have read the GemWorkers Seller Terms and I agree to them.'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _ticked && !_saving ? _agree : null,
                  style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(_saving ? 'Saving…' : 'I agree'),
                ),
                const SizedBox(height: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Minimal Markdown: "## " headings, numbered lines, **bold**, paragraphs.
List<Widget> _renderTerms(String body, TextTheme textTheme) {
  final out = <Widget>[];
  for (final raw in body.split('\n')) {
    final line = raw.trimRight();
    if (line.trim().isEmpty) {
      out.add(const SizedBox(height: 8));
    } else if (line.startsWith('## ')) {
      out.add(Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Text(line.substring(3), style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ));
    } else {
      final indent = RegExp(r'^\s+').firstMatch(line) != null;
      out.add(Padding(
        padding: EdgeInsets.only(left: indent ? 22 : 0, bottom: 4),
        child: Text.rich(TextSpan(children: _bold(line.trim())), style: textTheme.bodyMedium?.copyWith(height: 1.5)),
      ));
    }
  }
  return out;
}

List<TextSpan> _bold(String text) {
  final spans = <TextSpan>[];
  final parts = text.split('**');
  for (var i = 0; i < parts.length; i++) {
    spans.add(TextSpan(text: parts[i], style: i.isOdd ? const TextStyle(fontWeight: FontWeight.w700) : null));
  }
  return spans;
}
