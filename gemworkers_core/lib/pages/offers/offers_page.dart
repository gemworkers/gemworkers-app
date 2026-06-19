import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/storefront_offer.dart';
import '../../repositories/offers_repository.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  final _repository = OffersRepository();

  List<StorefrontOffer> _offers = [];
  bool _loading = true;
  String? _saving; // ID of the offer currently being accepted/declined

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final offers = await _repository.fetchOffers();
      if (mounted) {
        setState(() {
          _offers = offers;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _respond(StorefrontOffer offer, String action) async {
    final accepted = action == 'accepted';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(accepted ? 'Accept offer?' : 'Decline offer?'),
        content: Text(
          accepted
              ? 'Accept the €${offer.offeredPrice.toStringAsFixed(2)} offer for '
                '"${offer.stoneTitle}"?\n\n'
                'The stone will be reserved and an order will be created at '
                'the offered price.'
              : 'Decline this offer? The stone stays available for other buyers.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: accepted
                ? null
                : FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                  ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(accepted ? 'Accept' : 'Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _saving = offer.id);
    try {
      await _repository.respondToOffer(offer.id, action);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            accepted
                ? 'Offer accepted — stone reserved and order created.'
                : 'Offer declined.',
          ),
        ));
        _load();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = null);
        final msg = e is PostgrestException ? e.message : e.toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offers')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _offers.isEmpty
              ? const _EmptyState()
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 80),
                    itemCount: _offers.length,
                    itemBuilder: (_, i) {
                      final offer = _offers[i];
                      return _OfferCard(
                        offer: offer,
                        saving: _saving == offer.id,
                        onAccept: _saving == null
                            ? () => _respond(offer, 'accepted')
                            : null,
                        onDecline: _saving == null
                            ? () => _respond(offer, 'declined')
                            : null,
                      );
                    },
                  ),
                ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No offers yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 4),
          Text(
            'Offers from buyers will appear here.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Offer card ────────────────────────────────────────────────────────────────

class _OfferCard extends StatelessWidget {
  final StorefrontOffer offer;
  final bool saving;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const _OfferCard({
    required this.offer,
    required this.saving,
    required this.onAccept,
    required this.onDecline,
  });

  Color get _statusColor => switch (offer.status) {
        'accepted' => Colors.green,
        'declined' => Colors.red,
        _          => Colors.orange,
      };

  String get _statusLabel => switch (offer.status) {
        'accepted' => 'Accepted',
        'declined' => 'Declined',
        _          => 'Pending',
      };

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}  '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cs        = Theme.of(context).colorScheme;
    final isPending = offer.status == 'pending';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stone title + status chip ──────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    offer.stoneTitle.isNotEmpty
                        ? offer.stoneTitle
                        : 'Unknown stone',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: _statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Offered price ──────────────────────────────────────────
            Text(
              '€${offer.offeredPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: cs.primary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),

            // ── Buyer email ────────────────────────────────────────────
            if (offer.buyerEmail.isNotEmpty)
              Text(
                offer.buyerEmail,
                style: TextStyle(
                    fontSize: 12, color: Colors.grey.shade600),
              ),

            // ── Buyer note ─────────────────────────────────────────────
            if (offer.buyerNote.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '"${offer.buyerNote}"',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],

            const SizedBox(height: 8),

            // ── Timestamp ──────────────────────────────────────────────
            Text(
              _formatDate(offer.createdAt),
              style: TextStyle(
                  fontSize: 11, color: Colors.grey.shade500),
            ),

            // ── Actions (pending only) ─────────────────────────────────
            if (isPending) ...[
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: saving ? null : onAccept,
                      child: saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          : const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: saving ? null : onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.error,
                        side: BorderSide(
                            color: cs.error.withValues(alpha: 0.5)),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
