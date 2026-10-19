import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/order.dart';
import '../../models/seller.dart';
import '../../repositories/dashboard_intelligence_repository.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/offers_repository.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/seller_repository.dart';
import '../../theme/app_theme.dart';
import '../orders/order_detail_page.dart';
import '../orders/order_status.dart';
import 'dashboard_intelligence.dart';

/// Where a dashboard link goes; MainLayout maps it to a sidebar page + tab.
enum DashboardDestination {
  ordersToShip,
  ordersAwaitingPayment,
  ordersAll,
  offers,
  listingsDraft,
}

/// Order statuses that count as a sale in "This month".
const _kSaleStatuses = {'paid', 'confirmed', 'shipped', 'received'};

class DashboardPage extends StatefulWidget {
  final ValueChanged<DashboardDestination> onNavigate;
  const DashboardPage({super.key, required this.onNavigate});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _inventoryRepo = InventoryRepository();
  final _orderRepo = OrderRepository();
  final _offersRepo = OffersRepository();
  final _sellerRepo = SellerRepository();

  List<InventoryItem> _items = [];
  List<Order> _orders = [];
  List<Seller> _sellers = [];
  Seller? _selectedSeller;
  int _pendingOffers = 0;
  DashboardTimeRange _timeRange = DashboardTimeRange.thisMonth;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  bool get _isSeller => UserProfileService.instance.isSeller;

  /// Seller users are locked to their own seller; owners scope by the chip
  /// picker (null = all sellers).
  String? get _scopeSellerId =>
      _isSeller ? UserProfileService.instance.sellerId : _selectedSeller?.id;

  Future<T> _safe<T>(Future<T> future, T fallback) async {
    try {
      return await future;
    } catch (e) {
      debugPrint(e.toString());
      return fallback;
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await Future.wait([
      _safe(_inventoryRepo.getItems(), <InventoryItem>[]),
      _safe(_sellerRepo.getSellers(), <Seller>[]),
      _safe(_orderRepo.getShopOrders(), <Order>[]),
    ]);
    final items = results[0] as List<InventoryItem>;
    final sellers = results[1] as List<Seller>;
    final orders = results[2] as List<Order>;

    // Seller users are locked to their own seller — auto-select and lock it.
    Seller? selectedSeller = _selectedSeller;
    if (_isSeller) {
      final sid = UserProfileService.instance.sellerId;
      selectedSeller = sellers.where((s) => s.id == sid).firstOrNull;
    }

    if (!mounted) return;
    setState(() {
      _items = items;
      _sellers = sellers;
      _orders = orders;
      _selectedSeller = selectedSeller;
      _loading = false;
    });
    await _loadPendingOffers();
  }

  Future<void> _loadPendingOffers() async {
    final count = await _safe(
        _offersRepo.getPendingCount(sellerId: _scopeSellerId), 0);
    if (mounted) setState(() => _pendingOffers = count);
  }

  void _selectSeller(Seller? seller) {
    setState(() => _selectedSeller = seller);
    _loadPendingOffers();
  }

  Future<void> _openOrder(Order order) async {
    if (order.id == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id!)),
    );
    _load();
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  List<InventoryItem> get _scopedItems {
    final sid = _scopeSellerId;
    return sid == null ? _items : _items.where((e) => e.sellerId == sid).toList();
  }

  /// Newest first (getShopOrders orders by created_at desc).
  List<Order> get _scopedOrders {
    final sid = _scopeSellerId;
    return sid == null
        ? _orders
        : _orders.where((o) => o.sellerId == sid).toList();
  }

  /// Same rule as the Listings "Draft" tab: not sold, not reserved and not
  /// an active (listed + available) listing.
  int get _draftCount => _scopedItems
      .where((e) =>
          e.status != 'sold' &&
          e.status != 'reserved' &&
          !(e.isListed && e.status == 'available'))
      .length;

  int get _activeCount => _scopedItems
      .where((e) => e.isListed && e.status == 'available')
      .length;

  ({double sales, int count, double received}) _monthStats(DateTime month) {
    var sales = 0.0;
    var count = 0;
    var received = 0.0;
    for (final o in _scopedOrders) {
      if (!_kSaleStatuses.contains(o.status)) continue;
      final d = (o.paidAt ?? o.orderDate).toLocal();
      if (d.year != month.year || d.month != month.month) continue;
      sales += o.items.isNotEmpty ? o.total : o.orderTotal;
      count++;
      received += o.sellerPayout;
    }
    return (sales: sales, count: count, received: received);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final gutter = wide ? 32.0 : 16.0;

    return Scaffold(
      body: _loading && _orders.isEmpty && _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    EdgeInsets.fromLTRB(gutter, wide ? 28 : 20, gutter, 40),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildGreeting(wide),
                          _buildSellerFilter(),
                          const SizedBox(height: 28),
                          _buildAttention(),
                          const SizedBox(height: 36),
                          _buildThisMonth(),
                          const SizedBox(height: 36),
                          _buildRecentOrders(),
                          const SizedBox(height: 36),
                          _buildInsights(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGreeting(bool wide) {
    final t = Theme.of(context).textTheme;
    final now = DateTime.now();
    final part = now.hour < 12
        ? 'morning'
        : now.hour < 18
            ? 'afternoon'
            : 'evening';
    final firstName = UserProfileService.instance.profile?.displayName
        ?.trim()
        .split(RegExp(r'\s+'))
        .first;
    final greeting = firstName?.isNotEmpty == true
        ? 'Good $part, $firstName'
        : 'Good $part';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: t.headlineLarge
                    ?.copyWith(fontSize: wide ? 36 : 30, height: 1.15),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE d MMMM y').format(now),
                style: t.bodyMedium?.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _loading ? null : _load,
          tooltip: 'Refresh',
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh, color: AppColors.muted),
        ),
      ],
    );
  }

  Widget _buildSellerFilter() {
    // Seller users are always locked to their own seller — no picker shown.
    if (_sellers.isEmpty || _isSeller) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _Pill(
              label: 'All sellers',
              selected: _selectedSeller == null,
              onTap: () => _selectSeller(null),
            ),
            ..._sellers.map((s) => _Pill(
                  label: s.name,
                  selected: _selectedSeller?.id == s.id,
                  onTap: () => _selectSeller(s),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAttention() {
    final orders = _scopedOrders;
    final toShip = orders.where((o) => o.status == 'confirmed').toList();
    final overdue = toShip.where(orderShipOverdue).length;
    final nextShipBy = toShip.isEmpty
        ? null
        : toShip.map(orderShipBy).reduce((a, b) => a.isBefore(b) ? a : b);
    final awaiting = orders.where((o) => o.status == 'pending_payment').length;
    final drafts = _draftCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('Needs your attention'),
        _ResponsiveGrid(children: [
          _AttentionCard(
            count: toShip.length,
            label: 'Orders to ship',
            hint: overdue > 0
                ? '$overdue overdue'
                : nextShipBy != null
                    ? 'Next ship by ${_shortDate(nextShipBy)}'
                    : null,
            alert: overdue > 0,
            link: 'Go to To ship',
            onTap: () => widget.onNavigate(DashboardDestination.ordersToShip),
          ),
          _AttentionCard(
            count: _pendingOffers,
            label: 'Offers to answer',
            hint: 'Buyers are waiting for a reply',
            link: 'Review offers',
            onTap: () => widget.onNavigate(DashboardDestination.offers),
          ),
          _AttentionCard(
            count: awaiting,
            label: 'Awaiting payment',
            hint: 'Accepted offers not yet paid',
            link: 'View orders',
            onTap: () =>
                widget.onNavigate(DashboardDestination.ordersAwaitingPayment),
          ),
          _AttentionCard(
            count: drafts,
            label: 'Draft listings',
            hint: 'Not visible in your shop yet',
            link: 'Finish drafts',
            onTap: () => widget.onNavigate(DashboardDestination.listingsDraft),
          ),
        ]),
      ],
    );
  }

  Widget _buildThisMonth() {
    final now = DateTime.now();
    final current = _monthStats(now);
    final last = _monthStats(DateTime(now.year, now.month - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader('This month',
            trailing: DateFormat('MMMM y').format(now)),
        _ResponsiveGrid(children: [
          _StatTile(
            label: 'Sales',
            value: _eur(current.sales),
            comparison: '${_eur(last.sales)} last month',
          ),
          _StatTile(
            label: 'Orders',
            value: '${current.count}',
            comparison: '${last.count} last month',
          ),
          _StatTile(
            label: 'You received',
            value: _eur(current.received),
            comparison: '${_eur(last.received)} last month',
          ),
          _StatTile(
            label: 'Active listings',
            value: '$_activeCount',
            comparison: 'Listed and available',
          ),
        ]),
      ],
    );
  }

  Widget _buildRecentOrders() {
    final recent = _scopedOrders.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionHeader(
          'Recent orders',
          action: TextButton(
            onPressed: () => widget.onNavigate(DashboardDestination.ordersAll),
            child: const Text('View all →'),
          ),
        ),
        _WhiteCard(
          padding: EdgeInsets.zero,
          child: recent.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(28),
                  child: Text(
                    'No orders yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.muted),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < recent.length; i++) ...[
                      if (i > 0)
                        const Divider(
                            height: 1, color: AppColors.rowDivider),
                      _RecentOrderRow(recent[i], onTap: _openOrder),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionHeader('Insights'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: DashboardTimeRange.values
                .map((range) => _Pill(
                      label: range.label,
                      selected: _timeRange == range,
                      onTap: () => setState(() => _timeRange = range),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        // Tabular figures for every plain-styled number cell in Insights.
        DefaultTextStyle.merge(
          style: const TextStyle(fontFeatures: AppTheme.tabularFigures),
          child: DashboardIntelligenceSections(
            timeRange: _timeRange,
            sellerId: _selectedSeller?.id,
            isOwner: !_isSeller,
          ),
        ),
      ],
    );
  }

  static String _eur(double v) =>
      NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2)
          .format(v);

  static String _shortDate(DateTime d) =>
      DateFormat(d.year == DateTime.now().year ? 'd MMM' : 'd MMM y')
          .format(d);
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget? action;
  const _SectionHeader(this.title, {this.trailing, this.action});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: t.headlineSmall?.copyWith(fontSize: 26, height: 1.1),
            ),
          ),
          if (trailing != null)
            Text(trailing!,
                style: t.bodyMedium?.copyWith(color: AppColors.muted)),
          ?action,
        ],
      ),
    );
  }
}

/// 4 columns on wide layouts, 2×2 below 860px, 1 column below 480px; cards in
/// a row share the tallest card's height.
class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const _ResponsiveGrid({required this.children});

  static const _gap = 16.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final cols = w >= 860
          ? 4
          : w >= 480
              ? 2
              : 1;
      final rows = <Widget>[];
      for (var i = 0; i < children.length; i += cols) {
        if (rows.isNotEmpty) rows.add(const SizedBox(height: _gap));
        rows.add(IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < cols; j++) ...[
                if (j > 0) const SizedBox(width: _gap),
                Expanded(
                  child: i + j < children.length
                      ? children[i + j]
                      : const SizedBox(),
                ),
              ],
            ],
          ),
        ));
      }
      return Column(children: rows);
    });
  }
}

class _WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  const _WhiteCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        hoverColor: AppColors.raised.withValues(alpha: 0.3),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  final int count;
  final String label;

  /// Shown under the label when [count] > 0.
  final String? hint;

  /// Paints the count and hint red (overdue orders).
  final bool alert;
  final String link;
  final VoidCallback onTap;

  const _AttentionCard({
    required this.count,
    required this.label,
    required this.link,
    required this.onTap,
    this.hint,
    this.alert = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final calm = count == 0;
    final countColor = alert
        ? AppColors.error
        : calm
            ? AppColors.muted
            : AppColors.ink;
    final subline = calm ? 'All caught up' : hint;

    return _WhiteCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: AppTheme.numeric(t.displaySmall,
                fontSize: 40, height: 1, color: countColor),
          ),
          const SizedBox(height: 10),
          Text(label,
              style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          if (subline != null) ...[
            const SizedBox(height: 2),
            Text(
              subline,
              style: t.bodySmall?.copyWith(
                color: alert ? AppColors.error : AppColors.muted,
                fontWeight: alert ? FontWeight.w600 : null,
              ),
            ),
          ],
          const Spacer(),
          const SizedBox(height: 16),
          Text(
            '$link →',
            style: t.labelLarge?.copyWith(
              color: calm ? AppColors.muted : AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String? comparison;

  const _StatTile({required this.label, required this.value, this.comparison});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: t.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTheme.numeric(t.headlineMedium,
                  fontSize: 28, height: 1.15),
            ),
          ),
          if (comparison != null) ...[
            const Spacer(),
            const SizedBox(height: 6),
            Text(comparison!,
                style: AppTheme.numeric(t.bodySmall, color: AppColors.muted)),
          ],
        ],
      ),
    );
  }
}

class _RecentOrderRow extends StatelessWidget {
  final Order order;
  final Future<void> Function(Order) onTap;
  const _RecentOrderRow(this.order, {required this.onTap});

  String get _itemLine {
    if (order.items.isEmpty) return 'No items';
    final first = order.items.first.itemTitle.isNotEmpty
        ? order.items.first.itemTitle
        : 'Untitled item';
    final more = order.items.length - 1;
    return more > 0 ? '$first  +$more more' : first;
  }

  String? get _imageUrl =>
      order.items.map((i) => i.itemImageUrl).whereType<String>().firstOrNull;

  double get _total => order.orderTotal > 0 ? order.orderTotal : order.total;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final narrow = MediaQuery.sizeOf(context).width < 600;
    final chip = OrderStatusChip(order.status);

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          order.orderNumber.isNotEmpty ? order.orderNumber : 'Draft',
          style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          _itemLine,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: t.bodyMedium?.copyWith(color: AppColors.muted),
        ),
        if (narrow) ...[const SizedBox(height: 6), chip],
      ],
    );

    return InkWell(
      onTap: () => onTap(order),
      hoverColor: AppColors.raised.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _Thumb(_imageUrl),
            const SizedBox(width: 14),
            Expanded(child: details),
            if (!narrow) ...[
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: Align(alignment: Alignment.centerLeft, child: chip),
              ),
            ],
            const SizedBox(width: 12),
            SizedBox(
              width: 96,
              child: Text(
                '€${_total.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: AppTheme.numeric(t.bodyMedium),
              ),
            ),
          ],
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
        child: Icon(Icons.diamond_outlined, size: 20, color: AppColors.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 48,
        height: 48,
        child: url != null
            ? Image.network(url!,
                fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder)
            : placeholder,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.ink,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide(
            color: selected ? AppColors.ink : AppColors.borderStrong),
        shape: const StadiumBorder(),
      ),
    );
  }
}
