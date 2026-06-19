import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import 'add_edit_order_page.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;
  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _repository = OrderRepository();

  Order? _order;
  bool _loading = true;
  bool _actionInProgress = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final order = await _repository.getOrderDetail(widget.orderId);
      if (mounted) setState(() { _order = order; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditOrderPage(order: _order)),
    );
    if (saved == true) _load();
  }

  Future<void> _markConfirmed() async {
    await _runAction(() async {
      await _repository.updateOrder(
          widget.orderId,
          _order!.copyWith(status: 'confirmed'));
      await _load();
    });
  }

  Future<void> _markPaid() async {
    final confirmed = await _confirmDialog(
      title: 'Mark as Paid',
      body: 'This will set all line items to Sold. Continue?',
      confirmLabel: 'Mark Paid',
      confirmColor: Colors.green,
    );
    if (!confirmed) return;
    await _runAction(() async {
      await _repository.markPaid(widget.orderId);
      await _load();
    });
  }

  Future<void> _cancelOrder() async {
    final isPaid = _order!.status == 'paid';
    final confirmed = await _confirmDialog(
      title: 'Cancel Order',
      body: isPaid
          ? 'This will revert all items back to Available. Continue?'
          : 'Cancel this order?',
      confirmLabel: 'Cancel Order',
      confirmColor: Colors.red,
    );
    if (!confirmed) return;
    await _runAction(() async {
      await _repository.cancelOrder(widget.orderId,
          currentStatus: _order!.status);
      await _load();
    });
  }

  Future<void> _markShipped() async {
    final trackingCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mark as Shipped'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm shipment. Add a tracking number so the buyer '
              'can check delivery status.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: trackingCtrl,
              decoration: const InputDecoration(
                labelText: 'Tracking number (optional)',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Mark as Shipped'),
          ),
        ],
      ),
    );
    final tracking =
        trackingCtrl.text.trim().isEmpty ? null : trackingCtrl.text.trim();
    trackingCtrl.dispose();

    if (confirmed != true || !mounted) return;
    await _runAction(() async {
      await _repository.markShipped(widget.orderId, trackingNumber: tracking);
      await _load();
    });
  }

  Future<void> _deleteOrder() async {
    final confirmed = await _confirmDialog(
      title: 'Delete Order',
      body: 'Delete "${_order!.orderNumber}"? This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: Colors.red,
    );
    if (!confirmed) return;
    await _runAction(() async {
      await _repository.deleteOrder(widget.orderId);
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _actionInProgress = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _actionInProgress = false);
    }
  }

  Future<bool> _confirmDialog({
    required String title,
    required String body,
    required String confirmLabel,
    Color confirmColor = Colors.red,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: confirmColor),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;

    return Scaffold(
      appBar: AppBar(
        title: Text(order?.orderNumber.isNotEmpty == true
            ? order!.orderNumber
            : 'Order'),
        actions: [
          if (!_loading && order != null) ...[
            if (order.status == 'draft' || order.status == 'confirmed')
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: _actionInProgress ? null : _openEdit,
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _actionInProgress ? null : _deleteOrder,
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : order == null
              ? const Center(child: Text('Order not found'))
              : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                      children: [
                        _buildHeader(order),
                        const SizedBox(height: 16),
                        _buildLineItems(order),
                        const SizedBox(height: 16),
                        if (order.notes.isNotEmpty) _buildNotes(order),
                      ],
                    ),
                    if (_actionInProgress)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Colors.black26,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
      bottomNavigationBar: order == null || _loading
          ? null
          : _buildActionBar(order),
    );
  }

  Widget _buildHeader(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.orderNumber.isNotEmpty
                        ? order.orderNumber
                        : '—',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StatusBadge(order.status),
              ],
            ),
            const Divider(height: 24),
            _row('Customer',
                order.customerName.isNotEmpty ? order.customerName : '—'),
            _row(
                'Date',
                '${order.orderDate.day.toString().padLeft(2, '0')}/'
                    '${order.orderDate.month.toString().padLeft(2, '0')}/'
                    '${order.orderDate.year}'),
            _row('Items', '${order.items.length}'),
            if (order.shippedAt != null)
              _row('Shipped', _formatDateTime(order.shippedAt!)),
            if (order.receivedAt != null)
              _row('Received', _formatDateTime(order.receivedAt!)),
            if (order.trackingNumber != null)
              _row('Tracking', order.trackingNumber!),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(
                  '€${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItems(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Line Items',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (order.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                    child: Text('No items',
                        style: TextStyle(color: Colors.grey))),
              )
            else
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1.4),
                  3: FlexColumnWidth(1.4),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade300))),
                    children: const [
                      _TableHeader('Item'),
                      _TableHeader('Qty'),
                      _TableHeader('Price'),
                      _TableHeader('Subtotal'),
                    ],
                  ),
                  ...order.items.map((item) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.itemTitle.isNotEmpty
                                      ? item.itemTitle
                                      : item.inventoryItemId,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                if (item.itemSku.isNotEmpty)
                                  Text(
                                    item.itemSku,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '€${item.priceAtSale.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              '€${item.subtotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(Order order) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(order.notes),
          ],
        ),
      ),
    );
  }

  Widget? _buildActionBar(Order order) {
    final status = order.status;
    if (status == 'cancelled') return null;
    if (status == 'received') return null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            if (status == 'draft')
              Expanded(
                child: FilledButton.icon(
                  onPressed: _actionInProgress ? null : _markConfirmed,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Confirm Order'),
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue),
                ),
              ),
            if (status == 'confirmed') ...[
              if (order.saleChannel == 'platform') ...[
                // Platform order: seller marks shipped; Mark Paid belongs to
                // the payments epic and is not available in this flow.
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _actionInProgress ? null : _cancelOrder,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _actionInProgress ? null : _markShipped,
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Mark as Shipped'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange),
                  ),
                ),
              ] else ...[
                // Manual order: existing Cancel + Mark Paid unchanged.
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _actionInProgress ? null : _cancelOrder,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _actionInProgress ? null : _markPaid,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Mark Paid'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.green),
                  ),
                ),
              ],
            ],
            if (status == 'shipped')
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Awaiting buyer confirmation',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              ),
            if (status == 'paid')
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _actionInProgress ? null : _cancelOrder,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel & Revert Items'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year}  '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
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

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  Color get _color => switch (status) {
        'paid'      => Colors.green,
        'confirmed' => Colors.blue,
        'shipped'   => Colors.orange,
        'received'  => Colors.teal,
        'cancelled' => Colors.red,
        _           => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: _color,
            fontWeight: FontWeight.w600,
            fontSize: 13),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600),
      ),
    );
  }
}
