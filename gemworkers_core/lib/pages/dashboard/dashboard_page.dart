import 'package:flutter/material.dart';

import '../../models/inventory_item.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../inventory/inventory_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _inventoryRepo = InventoryRepository();
  final _supplierRepo = SupplierRepository();

  List<InventoryItem> _items = [];
  int _supplierCount = 0;
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

      // Suppliers table may not be created yet — fail gracefully.
      int supplierCount = 0;
      try {
        final suppliers = await _supplierRepo.getSuppliers();
        supplierCount = suppliers.length;
      } catch (_) {}

      final items = await itemsFuture;
      if (mounted) {
        setState(() {
          _items = items;
          _supplierCount = supplierCount;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Computed stats ────────────────────────────────────────────────────────

  int get _totalItems => _items.length;

  int _countByStatus(String s) => _items.where((e) => e.status == s).length;

  double get _totalValue => _items.fold(0.0, (sum, e) => sum + e.salePrice);

  List<InventoryItem> get _recentItems => _items.take(5).toList();

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
    final value = _totalValue;

    return Column(
      children: [
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
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Total Value',
                value: '€${_formatValue(value)}',
                icon: Icons.euro_outlined,
                color: Colors.amber.shade700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Suppliers',
                value: '$_supplierCount',
                icon: Icons.people_outline,
                color: Colors.blue,
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
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
                  _buildStatsGrid(),
                  const SizedBox(height: 16),
                  _buildStatusBreakdown(),
                  const SizedBox(height: 16),
                  _buildRecentItems(),
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
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 36,
            child: Text(
              '${(pct * 100).toStringAsFixed(0)}%',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ),
        ],
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
