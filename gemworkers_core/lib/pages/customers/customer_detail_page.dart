import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../models/order.dart';
import '../../repositories/customer_repository.dart';
import '../../repositories/order_repository.dart';
import '../orders/order_detail_page.dart';
import 'add_edit_customer_page.dart';

class CustomerDetailPage extends StatefulWidget {
  final Customer customer;
  const CustomerDetailPage({super.key, required this.customer});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  final _customerRepo = CustomerRepository();
  final _orderRepo = OrderRepository();

  late Customer _customer;
  List<Order> _orders = [];
  bool _loading = true;

  double get _totalSpent => _orders
      .where((o) => o.status == 'paid')
      .fold(0.0, (sum, o) => sum + o.total);

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final orders =
          await _orderRepo.getOrdersForCustomer(_customer.id!);
      if (mounted) setState(() { _orders = orders; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditCustomerPage(customer: _customer)),
    );
    if (saved == true && mounted) {
      // Reload customer from DB to pick up changes.
      final customers = await _customerRepo.getCustomers();
      final updated = customers
          .where((c) => c.id == _customer.id)
          .firstOrNull;
      if (updated != null && mounted) {
        setState(() => _customer = updated);
      }
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text(
            'Delete "${_customer.name}"? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _customerRepo.deleteCustomer(_customer.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _openOrder(Order order) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id!)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalSpent;
    final tier = _customer.effectiveTier(total);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_customer.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: _openEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: _delete,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(tier, total, cs),
                const SizedBox(height: 16),
                _buildDetails(),
                const SizedBox(height: 16),
                _buildOrderHistory(),
              ],
            ),
    );
  }

  Widget _buildHeader(String tier, double total, ColorScheme cs) {
    final paidOrders =
        _orders.where((o) => o.status == 'paid').length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: cs.primaryContainer,
              child: Text(
                _customer.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _customer.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            _TierBadge(tier),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatCell(
                    label: 'Orders', value: '${_orders.length}'),
                _StatCell(
                    label: 'Paid', value: '$paidOrders'),
                _StatCell(
                    label: 'Revenue',
                    value: '€${total.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details',
                style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 24),
            if (_customer.email.isNotEmpty)
              _row('Email', _customer.email),
            if (_customer.phone.isNotEmpty)
              _row('Phone', _customer.phone),
            if (_customer.country.isNotEmpty)
              _row('Country', _customer.country),
            _row('Type',
                _customer.type == 'business' ? 'Business' : 'Individual'),
            if (_customer.manualTier != null)
              _row('Tier Override', _customer.manualTier!),
            if (_customer.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Notes',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_customer.notes),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order History',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_orders.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text('No orders yet',
                      style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              ..._orders.map((o) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _openOrder(o),
                    title: Text(o.orderNumber.isNotEmpty
                        ? o.orderNumber
                        : 'Order'),
                    subtitle: Text(
                      '${o.orderDate.day.toString().padLeft(2, '0')}/'
                      '${o.orderDate.month.toString().padLeft(2, '0')}/'
                      '${o.orderDate.year}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '€${o.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        _StatusChip(o.status),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 13)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _TierBadge extends StatelessWidget {
  final String tier;
  const _TierBadge(this.tier);

  Color get _color => switch (tier) {
        'Silver' => const Color(0xFF9E9E9E),
        'Gold' => const Color(0xFFF9A825),
        'Premium' => const Color(0xFF7B1FA2),
        'Collector' => const Color(0xFF00897B),
        _ => const Color(0xFF8B5E3C),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Text(
        tier,
        style: TextStyle(
            color: _color,
            fontWeight: FontWeight.w700,
            fontSize: 13),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  Color get _color => switch (status) {
        'paid' => Colors.green,
        'confirmed' => Colors.blue,
        'cancelled' => Colors.red,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 11,
            color: _color,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
