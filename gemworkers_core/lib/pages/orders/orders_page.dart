import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import 'add_edit_order_page.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _repository = OrderRepository();

  List<Order> _orders = [];
  bool _loading = true;
  String? _statusFilter;

  static const _statuses = ['draft', 'confirmed', 'paid', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders =
          await _repository.getOrders(statusFilter: _statusFilter);
      if (mounted) {
        setState(() {
          _orders = orders;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _statusFilter == null,
                  onTap: () {
                    setState(() => _statusFilter = null);
                    _load();
                  },
                ),
                ..._statuses.map((s) => _FilterChip(
                      label: _capitalise(s),
                      selected: _statusFilter == s,
                      color: _statusColor(s),
                      onTap: () {
                        setState(() => _statusFilter = s);
                        _load();
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? _EmptyState(
                  hasFilter: _statusFilter != null,
                  onClear: () {
                    setState(() => _statusFilter = null);
                    _load();
                  },
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 80),
                    itemCount: _orders.length,
                    itemBuilder: (_, i) => _OrderCard(
                      _orders[i],
                      onTap: _openDetail,
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static Color _statusColor(String s) => switch (s) {
        'paid' => Colors.green,
        'confirmed' => Colors.blue,
        'cancelled' => Colors.red,
        _ => Colors.grey,
      };
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final c = color ?? cs.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        selectedColor: c.withValues(alpha: 0.15),
        checkmarkColor: c,
        labelStyle: TextStyle(
            color: selected ? c : null,
            fontWeight: selected ? FontWeight.w600 : null),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasFilter;
  final VoidCallback onClear;
  const _EmptyState({required this.hasFilter, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasFilter
                ? Icons.filter_list_off
                : Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? 'No orders with that status'
                : 'No orders yet',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (hasFilter) ...[
            const SizedBox(height: 8),
            TextButton(
                onPressed: onClear, child: const Text('Clear filter')),
          ],
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final Future<void> Function(Order) onTap;
  const _OrderCard(this.order, {required this.onTap});

  Color get _statusColor => switch (order.status) {
        'paid' => Colors.green,
        'confirmed' => Colors.blue,
        'cancelled' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: () => onTap(order),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: _statusColor.withValues(alpha: 0.4)),
          ),
          child: Icon(Icons.receipt_outlined,
              color: _statusColor, size: 22),
        ),
        title: Text(
          order.orderNumber.isNotEmpty
              ? order.orderNumber
              : 'Draft',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          order.customerName.isNotEmpty
              ? order.customerName
              : 'No customer',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: _statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                order.status,
                style: TextStyle(
                    fontSize: 11,
                    color: _statusColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${order.orderDate.day.toString().padLeft(2, '0')}/'
              '${order.orderDate.month.toString().padLeft(2, '0')}/'
              '${order.orderDate.year}',
              style:
                  const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
