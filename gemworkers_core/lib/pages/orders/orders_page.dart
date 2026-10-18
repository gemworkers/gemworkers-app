import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import '../../theme/app_theme.dart';
import 'add_edit_order_page.dart';
import 'mark_shipped_dialog.dart';
import 'order_detail_page.dart';
import 'order_status.dart';

// ── Tabs ──────────────────────────────────────────────────────────────────────

enum _OrdersTab {
  toShip('To ship', ['confirmed'], 'Nothing to ship right now.'),
  awaitingPayment(
      'Awaiting payment', ['pending_payment'], 'No orders awaiting payment.'),
  shipped('Shipped', ['shipped'], 'No shipped orders yet.'),
  completed('Completed', ['received', 'paid'], 'No completed orders yet.'),
  all('All', null, 'No orders yet.');

  final String label;

  /// Statuses shown in this tab; null = every status.
  final List<String>? statuses;
  final String emptyMessage;
  const _OrdersTab(this.label, this.statuses, this.emptyMessage);

  static _OrdersTab forStatus(String? status) => switch (status) {
        'confirmed' => toShip,
        'pending_payment' => awaitingPayment,
        'shipped' => shipped,
        'received' || 'paid' => completed,
        _ => all,
      };
}

/// Prep days assumed when none of an order's items has prep_days set.
const _kDefaultPrepDays = 3;

// ── Page ──────────────────────────────────────────────────────────────────────

class OrdersPage extends StatefulWidget {
  final String? initialStatusFilter;
  const OrdersPage({super.key, this.initialStatusFilter});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  final _repository = OrderRepository();
  late final TabController _tabController;

  List<Order> _orders = [];
  Map<String, int> _statusCounts = {};
  bool _loading = true;
  _OrdersTab _tab = _OrdersTab.toShip;
  final Set<String> _shippingIds = {};

  @override
  void initState() {
    super.initState();
    _tab = _OrdersTab.forStatus(widget.initialStatusFilter ?? 'confirmed');
    _tabController = TabController(
      length: _OrdersTab.values.length,
      vsync: this,
      initialIndex: _tab.index,
    )..addListener(() {
        if (!_tabController.indexIsChanging &&
            _tabController.index != _tab.index) {
          setState(() => _tab = _OrdersTab.values[_tabController.index]);
          _load();
        }
      });
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    setState(() => _loading = true);
    final tab = _tab;
    try {
      final svc = UserProfileService.instance;
      final results = await Future.wait([
        _repository.getShopOrders(statuses: tab.statuses),
        _repository.getStatusCounts(
            sellerId: svc.shouldFilterBySeller ? svc.sellerId : null),
      ]);
      var orders = results[0] as List<Order>;
      if (svc.shouldFilterBySeller) {
        orders = orders.where((o) => o.sellerId == svc.sellerId).toList();
      }
      // Ignore a stale response if the tab changed while loading.
      if (mounted && tab == _tab) {
        setState(() {
          _orders = orders;
          _statusCounts = results[1] as Map<String, int>;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted && tab == _tab) setState(() => _loading = false);
    }
  }

  int _countFor(_OrdersTab tab) {
    final statuses = tab.statuses;
    if (statuses == null) {
      return _statusCounts.values.fold(0, (a, b) => a + b);
    }
    return statuses.fold(0, (sum, s) => sum + (_statusCounts[s] ?? 0));
  }

  // ── Navigation & actions ──────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditOrderPage()),
    );
    if (added == true) _load();
  }

  Future<void> _openDetail(Order order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => OrderDetailPage(orderId: order.id!)),
    );
    _load();
  }

  /// Same flow as the detail page: confirm dialog + mark_order_shipped RPC
  /// (which validates server-side).
  Future<void> _markShipped(Order order) async {
    final id = order.id;
    if (id == null) return;
    final result = await showMarkShippedDialog(context);
    if (result == null || !mounted) return;
    setState(() => _shippingIds.add(id));
    try {
      await _repository.markShipped(id, trackingNumber: result.tracking);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${order.orderNumber} marked as shipped')));
      }
      await _load();
    } catch (e) {
      if (mounted) {
        final msg = e is PostgrestException ? e.message : e.toString();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _shippingIds.remove(id));
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final gutter = wide ? 32.0 : 16.0;

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
            if (_loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_orders.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(message: _tab.emptyMessage),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 32),
                sliver: SliverList.separated(
                  itemCount: _orders.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final order = _orders[i];
                    return _OrderCard(
                      order,
                      wide: wide,
                      shipping: _shippingIds.contains(order.id),
                      onTap: _openDetail,
                      onMarkShipped: _markShipped,
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
        Row(
          children: [
            Expanded(
              child: Text(
                'Orders & Shipping',
                style: textTheme.headlineLarge
                    ?.copyWith(fontSize: wide ? 40 : 30, height: 1.1),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add, size: 20),
              label: Text(wide ? 'New manual order' : 'New'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.only(right: 28),
          tabs: [
            for (final t in _OrdersTab.values)
              Tab(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: t.label),
                  TextSpan(
                    text: '  ${_countFor(t)}',
                    style: const TextStyle(
                        color: AppColors.muted, fontWeight: FontWeight.w400),
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

class _OrderCard extends StatelessWidget {
  final Order order;
  final bool wide;
  final bool shipping;
  final Future<void> Function(Order) onTap;
  final Future<void> Function(Order) onMarkShipped;

  const _OrderCard(
    this.order, {
    required this.wide,
    required this.shipping,
    required this.onTap,
    required this.onMarkShipped,
  });

  static String _date(DateTime d) {
    final local = d.toLocal();
    return DateFormat(local.year == DateTime.now().year ? 'd MMM' : 'd MMM y')
        .format(local);
  }

  static String _dateTime(DateTime d) =>
      '${_date(d)}, ${DateFormat('HH:mm').format(d.toLocal())}';

  // ── Derived display values ────────────────────────────────────────────────

  String get _dateLine => switch (order.status) {
        _ when order.paidAt != null => 'Paid ${_date(order.paidAt!)}',
        'confirmed' when order.saleChannel == 'platform' &&
                order.offerId == null =>
          'Paid ${_date(order.orderDate)}',
        'pending_payment' when order.offerId != null =>
          'Offer accepted ${_date(order.createdAt ?? order.orderDate)}',
        'shipped' when order.shippedAt != null =>
          'Shipped ${_date(order.shippedAt!)}',
        'received' when order.receivedAt != null =>
          'Received ${_date(order.receivedAt!)}',
        _ => 'Ordered ${_date(order.orderDate)}',
      };

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

  String? get _buyerName => [
        order.customerName,
        order.buyerName ?? '',
        order.shippingName ?? '',
      ].where((s) => s.isNotEmpty).firstOrNull;

  String? get _buyerEmail =>
      order.buyerEmail?.isNotEmpty == true ? order.buyerEmail : null;

  double get _total => order.orderTotal > 0 ? order.orderTotal : order.total;

  /// Paid date (fallback: order date) + the largest prep_days among its
  /// items (default 3).
  DateTime get _shipBy {
    final prep = order.items
        .map((i) => i.itemPrepDays)
        .whereType<int>()
        .fold<int?>(null, (m, d) => m == null || d > m ? d : m);
    final base = (order.paidAt ?? order.orderDate).toLocal();
    return DateTime(base.year, base.month, base.day)
        .add(Duration(days: prep ?? _kDefaultPrepDays));
  }

  bool get _isOverdue {
    final now = DateTime.now();
    return _shipBy.isBefore(DateTime(now.year, now.month, now.day));
  }

  bool get _canShipHere =>
      order.status == 'confirmed' && order.saleChannel == 'platform';

  // ── Pieces ────────────────────────────────────────────────────────────────

  Widget? _dueLine(TextTheme t) {
    if (order.status == 'confirmed') {
      final overdue = _isOverdue;
      return Text(
        'Ship by ${_date(_shipBy)}${overdue ? ' · overdue' : ''}',
        style: t.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: overdue ? AppColors.error : AppColors.ink,
        ),
      );
    }
    if (order.status == 'pending_payment' && order.paymentDueAt != null) {
      return Text(
        'Buyer pays by ${_dateTime(order.paymentDueAt!)}',
        style: t.bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600, color: AppColors.accent),
      );
    }
    return null;
  }

  /// Main action; [showsDetails] tells whether it already is "View details".
  (Widget, bool showsDetails) _mainButton() {
    const size = Size(0, 40);
    if (_canShipHere) {
      return (
        FilledButton.icon(
          onPressed: shipping ? null : () => onMarkShipped(order),
          style: FilledButton.styleFrom(minimumSize: size),
          icon: shipping
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.local_shipping_outlined, size: 18),
          label: const Text('Mark as shipped'),
        ),
        false,
      );
    }
    if (order.status == 'pending_payment') {
      return (
        FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(
            minimumSize: size,
            disabledBackgroundColor: AppColors.raised,
            disabledForegroundColor: AppColors.muted,
          ),
          child: const Text('Waiting for buyer'),
        ),
        false,
      );
    }
    return (
      OutlinedButton(
        onPressed: () => onTap(order),
        style: OutlinedButton.styleFrom(minimumSize: size),
        child: const Text('View details'),
      ),
      true,
    );
  }

  Widget _detailsLink(TextTheme t) => InkWell(
        onTap: () => onTap(order),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'View details',
            style: t.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.textSecondary,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final muted = t.bodyMedium?.copyWith(fontSize: 13, color: AppColors.muted);
    final due = _dueLine(t);
    final (button, buttonIsDetails) = _mainButton();

    final orderBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          order.orderNumber.isNotEmpty ? order.orderNumber : 'Draft',
          style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(_dateLine, style: muted),
        const SizedBox(height: 6),
        Text(_itemLine,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: t.bodyMedium?.copyWith(fontSize: 15)),
      ],
    );

    final buyerBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name if known, else the email takes the name line; "No buyer" only
        // when both are missing.
        Text(_buyerName ?? _buyerEmail ?? 'No buyer',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _buyerName == null && _buyerEmail == null
                ? muted
                : t.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        if (_buyerName != null && _buyerEmail != null)
          Text(_buyerEmail!,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
        if (order.shippingCountry?.isNotEmpty == true)
          Text(order.shippingCountry!, style: muted),
      ],
    );

    final total = Text(
      '€${_total.toStringAsFixed(2)}',
      style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
    );

    final Widget content = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Photo(_imageUrl, size: 88),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: orderBlock),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: buyerBlock),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: Align(alignment: Alignment.topRight, child: total),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(order.status),
                    if (due != null) ...[const SizedBox(height: 8), due],
                    const SizedBox(height: 12),
                    button,
                    if (!buttonIsDetails) ...[
                      const SizedBox(height: 4),
                      _detailsLink(t),
                    ],
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Photo(_imageUrl, size: 72),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: orderBlock),
                            const SizedBox(width: 8),
                            total,
                          ],
                        ),
                        const SizedBox(height: 8),
                        buyerBlock,
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [_StatusChip(order.status), ?due],
              ),
              const SizedBox(height: 12),
              button,
              if (!buttonIsDetails)
                Align(
                  alignment: Alignment.center,
                  child: _detailsLink(t),
                ),
            ],
          );

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onTap(order),
        hoverColor: AppColors.raised.withValues(alpha: 0.3),
        child: Padding(
          padding: EdgeInsets.all(wide ? 20 : 16),
          child: content,
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final String? url;
  final double size;
  const _Photo(this.url, {required this.size});

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
        width: size,
        height: size,
        child: url != null
            ? Image.network(url!,
                fit: BoxFit.cover, errorBuilder: (_, _, _) => placeholder)
            : placeholder,
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: ShapeDecoration(
        color: orderStatusBackground(status),
        shape: const StadiumBorder(),
      ),
      child: Text(
        orderStatusLabel(status),
        style: TextStyle(
          fontSize: 12,
          color: orderStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
