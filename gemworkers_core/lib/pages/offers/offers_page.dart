import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/storefront_offer.dart';
import '../../repositories/offers_repository.dart';
import '../../theme/app_theme.dart';
import '../orders/order_detail_page.dart';

// ── Tabs ──────────────────────────────────────────────────────────────────────

enum _OffersTab {
  pending('Pending', 'pending', "No offers waiting — you're all caught up."),
  accepted('Accepted', 'accepted', 'No accepted offers yet.'),
  declined('Declined', 'declined', 'No declined offers.'),
  expired('Expired', 'expired', 'No expired offers.'),
  all('All', null, 'No offers yet. Buyers\' offers will appear here.');

  final String label;

  /// Offer status shown in this tab; null = every status.
  final String? status;
  final String emptyMessage;
  const _OffersTab(this.label, this.status, this.emptyMessage);

  bool matches(StorefrontOffer o) => status == null || o.status == status;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class OffersPage extends StatefulWidget {
  const OffersPage({super.key});

  @override
  State<OffersPage> createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage>
    with SingleTickerProviderStateMixin {
  final _repository = OffersRepository();
  late final TabController _tabController;

  List<StorefrontOffer> _offers = [];
  bool _loading = true;
  String? _saving; // ID of the offer currently being accepted/declined
  _OffersTab _tab = _OffersTab.pending;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _OffersTab.values.length,
      vsync: this,
      initialIndex: _tab.index,
    )..addListener(() {
        if (!_tabController.indexIsChanging &&
            _tabController.index != _tab.index) {
          setState(() => _tab = _OffersTab.values[_tabController.index]);
        }
      });
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final offers = await _repository.fetchOffers();
      final svc = UserProfileService.instance;
      final scoped = svc.shouldFilterBySeller
          ? offers.where((o) => o.sellerId == svc.sellerId).toList()
          : offers;
      if (mounted) {
        setState(() {
          _offers = scoped;
          _loading = false;
          _saving = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  int _countFor(_OffersTab tab) => _offers.where(tab.matches).length;

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
                ? 'Offer accepted. The buyer has 48 hours to pay — the stone is reserved until then.'
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

  Future<void> _openOrder(String orderId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
    );
    if (mounted) _load();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final gutter = wide ? 32.0 : 16.0;
    final visible = _offers.where(_tab.matches).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, wide ? 28 : 20, gutter, 20),
              sliver: SliverToBoxAdapter(child: _buildTop(wide)),
            ),
            if (_loading && _offers.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(message: _tab.emptyMessage),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 32),
                sliver: SliverList.separated(
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final offer = visible[i];
                    return _OfferCard(
                      offer: offer,
                      wide: wide,
                      saving: _saving == offer.id,
                      onAccept: _saving == null
                          ? () => _respond(offer, 'accepted')
                          : null,
                      onDecline: _saving == null
                          ? () => _respond(offer, 'declined')
                          : null,
                      onViewOrder: offer.orderId != null
                          ? () => _openOrder(offer.orderId!)
                          : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop(bool wide) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Offers',
          style: textTheme.headlineLarge
              ?.copyWith(fontSize: wide ? 40 : 30, height: 1.1),
        ),
        const SizedBox(height: 6),
        Text(
          "Buyers' price offers on your stones.",
          style: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.only(right: 28),
          tabs: [
            for (final t in _OffersTab.values)
              Tab(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: t.label),
                  TextSpan(
                    text: '  ${_countFor(t)}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                      fontFeatures: AppTheme.tabularFigures,
                    ),
                  ),
                ])),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 64),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: AppColors.muted),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final StorefrontOffer offer;
  final bool wide;
  final bool saving;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onViewOrder;

  const _OfferCard({
    required this.offer,
    required this.wide,
    required this.saving,
    required this.onAccept,
    required this.onDecline,
    required this.onViewOrder,
  });

  static String _money(double v) =>
      NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2)
          .format(v);

  static String _dateTime(DateTime d) {
    final local = d.toLocal();
    final day = DateFormat(
            local.year == DateTime.now().year ? 'd MMM' : 'd MMM y')
        .format(local);
    return '$day, ${DateFormat('HH:mm').format(local)}';
  }

  static String _ago(DateTime d) {
    final diff = DateTime.now().difference(d.toLocal());
    String plural(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return plural(diff.inMinutes, 'minute');
    if (diff.inDays < 1) return plural(diff.inHours, 'hour');
    if (diff.inDays < 7) return plural(diff.inDays, 'day');
    if (diff.inDays < 30) return plural(diff.inDays ~/ 7, 'week');
    final local = d.toLocal();
    return 'on ${DateFormat(local.year == DateTime.now().year ? 'd MMM' : 'd MMM y').format(local)}';
  }

  /// Offer as a share of the listed price, rounded; null if no price.
  int? get _percentOfPrice {
    final listed = offer.listedPrice;
    if (listed == null || listed <= 0) return null;
    return (offer.offeredPrice / listed * 100).round();
  }

  String get _buyerLabel {
    if (offer.buyerName.isNotEmpty && offer.buyerEmail.isNotEmpty) {
      return '${offer.buyerName} · ${offer.buyerEmail}';
    }
    if (offer.buyerName.isNotEmpty) return offer.buyerName;
    if (offer.buyerEmail.isNotEmpty) return offer.buyerEmail;
    return 'Buyer';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          offer.stoneTitle.isNotEmpty ? offer.stoneTitle : 'Unknown stone',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (offer.stoneSku.isNotEmpty)
          Text(
            offer.stoneSku,
            style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        const SizedBox(height: 10),
        if (offer.listedPrice != null)
          Text(
            'Listed at ${_money(offer.listedPrice!)}',
            style: AppTheme.numeric(textTheme.bodyMedium,
                    color: AppColors.muted)
                .copyWith(fontWeight: FontWeight.w400),
          ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 4,
          children: [
            Text(
              _money(offer.offeredPrice),
              style: AppTheme.numeric(textTheme.headlineSmall,
                  fontSize: 28, height: 1.2, color: AppColors.ink),
            ),
            if (_percentOfPrice != null) _PercentChip(_percentOfPrice!),
          ],
        ),
      ],
    );

    final buyerInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: [
            TextSpan(
              text: _buyerLabel,
              style: const TextStyle(
                  color: AppColors.ink, fontWeight: FontWeight.w500),
            ),
            TextSpan(text: '  ·  received ${_ago(offer.createdAt)}'),
          ]),
          style: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        ),
        if (offer.buyerNote.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            '“${offer.buyerNote}”',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );

    final actions = _buildActions(context);

    final Widget body;
    if (wide) {
      body = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Thumb(offer.stoneImageUrl),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [details, const SizedBox(height: 12), buyerInfo],
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(width: 260, child: actions),
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumb(offer.stoneImageUrl),
              const SizedBox(width: 14),
              Expanded(child: details),
            ],
          ),
          const SizedBox(height: 12),
          buyerInfo,
          const SizedBox(height: 14),
          actions,
        ],
      );
    }

    return Container(
      padding: EdgeInsets.all(wide ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: body,
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (offer.status) {
      case 'pending':
        final accept = FilledButton(
          onPressed: saving ? null : onAccept,
          child: saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Accept'),
        );
        final decline = OutlinedButton(
          onPressed: saving ? null : onDecline,
          child: const Text('Decline'),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [accept, const SizedBox(height: 8), decline],
        );

      case 'accepted':
        final orderStatus = offer.orderStatus;
        final awaiting = orderStatus == null || orderStatus == 'pending_payment';
        final cancelled = orderStatus == 'cancelled';
        final String detail;
        if (cancelled) {
          detail = 'Order cancelled';
        } else if (!awaiting) {
          detail = 'Paid';
        } else if (offer.orderPaymentDueAt != null) {
          detail = 'Buyer pays by ${_dateTime(offer.orderPaymentDueAt!)}';
        } else {
          detail = '';
        }
        return Column(
          crossAxisAlignment:
              wide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _StatusChip(
              awaiting ? 'Accepted — awaiting payment' : 'Accepted',
              color: awaiting ? AppColors.accent : AppColors.success,
              background: awaiting
                  ? AppColors.raised
                  : AppColors.success.withValues(alpha: 0.1),
            ),
            if (detail.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                detail,
                textAlign: wide ? TextAlign.end : TextAlign.start,
                style: AppTheme.numeric(
                  Theme.of(context).textTheme.bodySmall,
                  color: detail == 'Paid'
                      ? AppColors.success
                      : AppColors.textSecondary,
                ),
              ),
            ],
            if (onViewOrder != null)
              TextButton(
                onPressed: onViewOrder,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 36),
                ),
                child: const Text('View order'),
              ),
          ],
        );

      default:
        final label = switch (offer.status) {
          'declined' => 'Declined',
          'expired' => 'Expired',
          final s => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1),
        };
        return Align(
          alignment: wide ? Alignment.topRight : Alignment.centerLeft,
          child: _StatusChip(
            label,
            color: AppColors.muted,
            background: AppColors.raised,
          ),
        );
    }
  }
}

class _PercentChip extends StatelessWidget {
  final int percent;
  const _PercentChip(this.percent);

  @override
  Widget build(BuildContext context) {
    final low = percent < 70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: const ShapeDecoration(
        color: AppColors.raised,
        shape: StadiumBorder(),
      ),
      child: Text(
        '$percent% of price',
        style: AppTheme.numeric(
          Theme.of(context).textTheme.labelMedium,
          color: low ? AppColors.error : AppColors.accent,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color background;
  const _StatusChip(this.label,
      {required this.color, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: ShapeDecoration(color: background, shape: const StadiumBorder()),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String? url;
  const _Thumb(this.url);

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.raised,
      child: Center(
        child: Icon(Icons.diamond_outlined, size: 28, color: AppColors.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 88,
        height: 88,
        child: url != null
            ? Image.network(url!,
                fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder)
            : placeholder,
      ),
    );
  }
}
