import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/location.dart';
import '../../models/seller.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/dashboard_intelligence_repository.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/purchase_repository.dart';
import '../../repositories/seller_repository.dart';
import '../inventory/inventory_detail_page.dart';
import 'dashboard_intelligence.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _inventoryRepo = InventoryRepository();
  final _orderRepo = OrderRepository();
  final _customerRepo = CustomerRepository();
  final _purchaseRepo = PurchaseRepository();
  final _sellerRepo = SellerRepository();
  final _locationRepo = LocationRepository();

  List<InventoryItem> _items = [];
  List<Seller> _sellers = [];
  List<Location> _statusZones = [];
  Seller? _selectedSeller;
  DashboardTimeRange _timeRange = DashboardTimeRange.thisMonth;
  int _orderCount = 0;
  int _customerCount = 0;
  double _revenue = 0.0;
  double _totalSpent = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final itemsFuture = _inventoryRepo.getItems();
      final sellersFuture = _sellerRepo.getSellers();

      int orderCount = 0;
      int customerCount = 0;
      double revenue = 0.0;
      double totalSpent = 0.0;

      // Seller users see only their own stats — customer count is hidden.
      final svc = UserProfileService.instance;
      final sellerScopeId = svc.isSeller ? svc.sellerId : null;

      try {
        final stats =
            await _orderRepo.getDashboardStats(sellerId: sellerScopeId);
        orderCount = stats.orderCount;
        revenue = stats.revenue;
      } catch (_) {}
      if (!svc.isSeller) {
        try {
          customerCount = await _customerRepo.getCustomerCount();
        } catch (_) {}
      }
      try {
        totalSpent =
            await _purchaseRepo.getTotalSpent(sellerId: sellerScopeId);
      } catch (_) {}

      final results = await Future.wait([itemsFuture, sellersFuture]);
      final items = results[0] as List<InventoryItem>;
      final sellers = results[1] as List<Seller>;

      // Seller users are locked to their own seller — auto-select and lock it.
      Seller? selectedSeller = _selectedSeller;
      if (UserProfileService.instance.isSeller) {
        final sid = UserProfileService.instance.sellerId;
        try {
          selectedSeller = sellers.firstWhere((s) => s.id == sid);
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _items = items;
          _sellers = sellers;
          _selectedSeller = selectedSeller;
          _orderCount = orderCount;
          _customerCount = customerCount;
          _revenue = revenue;
          _totalSpent = totalSpent;
          _loading = false;
        });
        _loadStatusZones();
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadStatusZones() async {
    if (_sellers.isEmpty) return;
    final sellerId =
        _selectedSeller?.id ?? _sellers.first.id ?? '';
    if (sellerId.isEmpty) return;
    try {
      final locs = await _locationRepo.getLocationsFlat(sellerId);
      if (mounted) {
        setState(() {
          _statusZones = locs.where((l) => l.isStatusZone).toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _selectSeller(Seller? seller) async {
    setState(() {
      _selectedSeller = seller;
      _statusZones = [];
    });
    _loadStatusZones();
  }

  // ── Computed stats ────────────────────────────────────────────────────────

  List<InventoryItem> get _filteredItems => _selectedSeller == null
      ? _items
      : _items.where((e) => e.sellerId == _selectedSeller!.id).toList();

  int get _totalItems => _filteredItems.length;

  int _countByStatus(String s) =>
      _filteredItems.where((e) => e.status == s).length;

  Set<String> get _suspendedSellerIds => _sellers
      .where((s) => s.status == 'suspended' && s.id != null)
      .map((s) => s.id!)
      .toSet();

  // Excluded suspended sellers' items from the "All" marketplace count.
  int get _listedCount {
    final items = _filteredItems.where((e) => e.isListed);
    if (_selectedSeller == null) {
      final suspended = _suspendedSellerIds;
      return items.where((e) => !suspended.contains(e.sellerId)).length;
    }
    return items.length;
  }

  double get _listedValue {
    final items = _filteredItems.where((e) => e.isListed);
    if (_selectedSeller == null) {
      final suspended = _suspendedSellerIds;
      return items
          .where((e) => !suspended.contains(e.sellerId))
          .fold(0.0, (sum, e) => sum + (e.sellingPrice ?? 0));
    }
    return items.fold(0.0, (sum, e) => sum + (e.sellingPrice ?? 0));
  }

  double get _totalValue =>
      _filteredItems.fold(0.0, (sum, e) => sum + e.salePrice);

  List<InventoryItem> get _recentItems => _filteredItems.take(5).toList();

  int _countInZone(Location zone) =>
      _filteredItems.where((e) => e.locationId == zone.id).length;

  // ── Build sections ────────────────────────────────────────────────────────

  Widget _buildTimeRangeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: DashboardTimeRange.values.map((range) {
          final selected = _timeRange == range;
          final color = Theme.of(context).colorScheme.primary;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(range.label),
              selected: selected,
              onSelected: (_) => setState(() => _timeRange = range),
              selectedColor: color.withValues(alpha: 0.15),
              checkmarkColor: color,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSellerFilter() {
    // Seller users are always locked to their own seller — no picker shown.
    if (_sellers.isEmpty || UserProfileService.instance.isSeller) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _SellerChip(
            label: 'All',
            selected: _selectedSeller == null,
            onTap: () => _selectSeller(null),
          ),
          ..._sellers.map((s) => _SellerChip(
                label: s.name,
                selected: _selectedSeller?.id == s.id,
                onTap: () => _selectSeller(s),
              )),
        ],
      ),
    );
  }

  Widget _buildZoneBreakdown() {
    if (_statusZones.isEmpty) return const SizedBox.shrink();
    final total = _filteredItems.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Zones',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (total == 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('No items',
                      style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ..._statusZones.map((zone) {
                final count = _countInZone(zone);
                return _StatusBar(
                  label: zone.name,
                  count: count,
                  total: total,
                  color: Colors.blueGrey,
                );
              }),
          ],
        ),
      ),
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openItem(InventoryItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InventoryDetailPage(item: item)),
    );
    _load();
  }

  // ── Build sections ────────────────────────────────────────────────────────

  Widget _buildStatsGrid() {
    final available = _countByStatus('available');

    return Column(
      children: [
        // Row 1 — inventory overview
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Items',
                value: '$_totalItems',
                icon: Icons.inventory_2_outlined,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Available',
                value: '$available',
                icon: Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Inventory Value',
                value: '€${_formatValue(_totalValue)}',
                icon: Icons.euro_outlined,
                color: Colors.amber.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2 — money in vs money out
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Revenue',
                value: '€${_formatValue(_revenue)}',
                icon: Icons.payments_outlined,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Spent on Purchases',
                value: '€${_formatValue(_totalSpent)}',
                icon: Icons.shopping_bag_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 3 — activity (Customers hidden for seller role)
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Orders',
                value: '$_orderCount',
                icon: Icons.receipt_long_outlined,
                color: Colors.deepPurple,
              ),
            ),
            if (!UserProfileService.instance.isSeller) ...[
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Customers',
                  value: '$_customerCount',
                  icon: Icons.person_outline,
                  color: Colors.blue,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Row 4 — marketplace
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Listed (marketplace)',
                value: '$_listedCount',
                icon: Icons.storefront_outlined,
                color: Colors.cyan.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Listed Value',
                value: '€${_formatValue(_listedValue)}',
                icon: Icons.sell_outlined,
                color: Colors.cyan.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBreakdown() {
    final statuses = [
      ('Available', _countByStatus('available'), Colors.green),
      ('Reserved', _countByStatus('reserved'), Colors.orange),
      ('Sold', _countByStatus('sold'), Colors.red),
      ('Draft', _countByStatus('draft'), Colors.grey),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Breakdown',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (_totalItems == 0)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No items yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...statuses.map(
                (s) => _StatusBar(
                  label: s.$1,
                  count: s.$2,
                  total: _totalItems,
                  color: s.$3,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Additions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_recentItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No items yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...(_recentItems.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: () => _openItem(item),
                  leading: item.imageUrls.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item.imageUrls.first,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.diamond_outlined),
                          ),
                        )
                      : const Icon(Icons.diamond_outlined),
                  title: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    item.gemType.isNotEmpty ? item.gemType : item.sku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '€${item.salePrice.toStringAsFixed(2)}',
                        style:
                            const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      _StatusDot(item.status),
                    ],
                  ),
                ),
              )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTimeRangeSelector(),
                  _buildSellerFilter(),
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildStatusBreakdown(),
                  const SizedBox(height: 16),
                  _buildZoneBreakdown(),
                  const SizedBox(height: 16),
                  _buildRecentItems(),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  DashboardIntelligenceSections(
                    timeRange: _timeRange,
                    sellerId: _selectedSeller?.id,
                    isOwner: !UserProfileService.instance.isSeller,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  static String _formatValue(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _StatusBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 36,
            child: Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SellerChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: color.withValues(alpha: 0.15),
        checkmarkColor: color,
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String status;
  const _StatusDot(this.status);

  Color get _color => switch (status) {
        'available' => Colors.green,
        'reserved' => Colors.orange,
        'sold' => Colors.red,
        'draft' => Colors.grey,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(status, style: TextStyle(fontSize: 11, color: _color)),
      ],
    );
  }
}
