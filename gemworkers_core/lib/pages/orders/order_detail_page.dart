import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import '../../core/utils/decimal_input.dart';
import '../../repositories/consignor_repository.dart';
import '../../repositories/refund_repository.dart';
import '../../core/utils/customs.dart';
import '../../core/utils/open_url/open_url.dart';
import 'add_edit_order_page.dart';
import 'mark_shipped_dialog.dart';
import 'order_status.dart';
import '../messages/messages_page.dart';

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
  final _refundRepo = RefundRepository();
  List<OrderMoneyEvent> _refunds = [];
  List<OrderMoneyEvent> _charges = [];

  // Customs form (cross-border, outside the EU customs union).
  List<Map<String, dynamic>> _customsItems = [];
  String? _shipFrom; // seller country code
  Map<String, dynamic>? _invoice; // {id, number}
  String? _eori; // GemWorkers' EORI (exports from NL; owner only)
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
      if (UserProfileService.instance.isOwner && order.saleChannel == 'platform') {
        try {
          final m = await _refundRepo.getForOrder(widget.orderId);
          _refunds = m.refunds;
          _charges = m.charges;
        } catch (e) {
          debugPrint('Refunds not loaded: $e');
        }
      }
      if (order.saleChannel == 'platform') {
        try {
          final sb = Supabase.instance.client;
          final ids = order.items.map((i) => i.inventoryItemId).where((x) => x.isNotEmpty).toList();
          if (ids.isNotEmpty) {
            _customsItems = List<Map<String, dynamic>>.from(await sb
                .from('inventory_items')
                .select('id, title, sku, product_type, gem_type, variety, species, cut_type, shape, treatment, '
                    'weight_value, weight_unit, weight_grams, total_weight_grams, metal, metal_purity, jewelry_type, origin_country')
                .inFilter('id', ids));
          }
          if (order.sellerId != null) {
            final s = await sb.from('sellers').select('country').eq('id', order.sellerId!).maybeSingle();
            _shipFrom = s?['country']?.toString();
          }
          if (_shipFrom == 'NL' && UserProfileService.instance.isOwner) {
            final e = await sb.from('store_settings').select('value').eq('key', 'company_eori').maybeSingle();
            _eori = e?['value']?.toString();
          }
          _invoice = await sb.from('invoices').select('id, number')
              .eq('order_id', widget.orderId).eq('kind', 'invoice').maybeSingle();
        } catch (e) {
          debugPrint('Customs data not loaded: $e');
        }
      }
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
    final result = await showMarkShippedDialog(context);
    if (result == null || !mounted) return;
    await _runAction(() async {
      await _repository.markShipped(widget.orderId,
          trackingNumber: result.tracking);
      await _load();
    });
  }

  Future<void> _markPayoutPaid() async {
    String? selectedMethod = 'Wise';
    final referenceCtrl = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Mark Payout Paid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Record that the seller payout has been made.'),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Wise', label: Text('Wise')),
                  ButtonSegment(
                      value: 'Payoneer', label: Text('Payoneer')),
                ],
                selected: {selectedMethod ?? 'Wise'},
                onSelectionChanged: (v) =>
                    setLocal(() => selectedMethod = v.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: referenceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Transaction reference (optional)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
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
              style: FilledButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Mark Paid'),
            ),
          ],
        ),
      ),
    );

    final method = selectedMethod;
    final reference =
        referenceCtrl.text.trim().isEmpty ? null : referenceCtrl.text.trim();
    referenceCtrl.dispose();

    if (confirmed != true || !mounted) return;
    await _runAction(() async {
      await _repository.markPayoutPaid(widget.orderId,
          method: method, reference: reference);
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

  /// Opens (or starts) the conversation with this order's buyer about its
  /// stone (sql/order_conversation.sql), in a full-screen Messages view.
  Future<void> _messageBuyer(Order order) async {
    try {
      final id = await Supabase.instance.client
          .rpc('order_conversation', params: {'p_order_id': order.id});
      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Messages')),
          body: MessagesPage(initialConversationId: id.toString()),
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the conversation: $e')));
    }
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
            // pending_payment orders are released automatically when the
            // payment deadline passes, so they can't be deleted by hand.
            if (order.status != 'pending_payment')
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
                        if (const {'confirmed', 'shipped', 'received', 'paid'}
                            .contains(order.status)) ...[
                          _buildShippingAddress(order),
                          const SizedBox(height: 16),
                          if (_needsCustoms(order)) ...[
                            _buildCustoms(order),
                            const SizedBox(height: 16),
                          ],
                        ],
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
            if (UserProfileService.instance.isOwner && order.sellerName != null)
              _row('Shop', order.sellerName!),
            _row('Customer',
                order.customerName.isNotEmpty ? order.customerName : '—'),
            if (order.saleChannel == 'platform' && order.paidAt != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => _messageBuyer(order),
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Message buyer'),
                ),
              ),
            _row(
                'Date',
                '${order.orderDate.day.toString().padLeft(2, '0')}/'
                    '${order.orderDate.month.toString().padLeft(2, '0')}/'
                    '${order.orderDate.year}'),
            _row('Items', '${order.items.length}'),
            if (order.shippedAt != null)
              _row(
                order.shippedByOwner ? 'Shipped (admin)' : 'Shipped',
                _formatDateTime(order.shippedAt!),
              ),
            if (order.receivedAt != null)
              _row('Received', _formatDateTime(order.receivedAt!)),
            if (order.trackingNumber != null)
              _row('Tracking', order.trackingNumber!),
            const Divider(height: 24),
            if (order.saleChannel == 'platform') ...[
              _moneyRow(
                'Stone',
                order.orderTotal - (order.shippingCost ?? 0),
              ),
              if (order.shippingCost != null && order.shippingCost! > 0)
                _moneyRow('Shipping', order.shippingCost!),
              const SizedBox(height: 4),
            ],
            if (order.saleChannel == 'platform' && order.taxAmount > 0) ...[
              _moneyRow('Subtotal (excl. VAT)', order.orderTotal),
              _moneyRow(
                'VAT${order.taxRate != null ? ' ${_pct(order.taxRate!)}' : ''} — goes to the tax office',
                order.taxAmount,
              ),
            ],
            if (order.saleChannel == 'platform' && order.taxScheme == 'reverse_charge')
              _row('VAT', 'Reverse charged (EU business, 0%)'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.saleChannel == 'platform' && order.taxAmount > 0 ? 'Buyer paid' : 'Total',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                Text(
                  order.saleChannel == 'platform'
                      ? '€${(((order.orderTotal * 100).round() + (order.taxAmount * 100).round()) / 100).toStringAsFixed(2)}'
                      : '€${order.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            if (order.eurReceived != null && UserProfileService.instance.isOwner)
              _row('Euros received from Stripe', '€${order.eurReceived!.toStringAsFixed(2)}'),
            if (order.saleChannel == 'platform') ..._payoutRows(order),
            if (order.saleChannel == 'platform' && UserProfileService.instance.isOwner) ..._refundRows(order),
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

  static const _eu = {
    'AT', 'BE', 'BG', 'CY', 'CZ', 'DE', 'DK', 'EE', 'ES', 'FI', 'FR', 'GR', 'HR', 'HU', 'IE', 'IT',
    'LT', 'LU', 'LV', 'MT', 'NL', 'PL', 'PT', 'RO', 'SE', 'SI', 'SK',
  };

  /// A customs form is needed when the parcel crosses a customs border
  /// (any route except inside the same country or inside the EU).
  bool _needsCustoms(Order order) {
    final to = order.shippingCountry?.toUpperCase();
    final from = _shipFrom?.toUpperCase();
    if (to == null || to.isEmpty || from == null || _customsItems.isEmpty) return false;
    if (to == from) return false;
    return !(_eu.contains(to) && _eu.contains(from));
  }

  Widget _buildCustoms(Order order) {
    final t = Theme.of(context).textTheme;
    final goods = order.orderTotal - (order.shippingCost ?? 0);
    final details = [for (final i in _customsItems) customsDetailsFor(i)];
    final anyDiamond = details.any((d) => d.diamond);
    final lines = <(String, String)>[
      ('Type of shipment', 'Sale of goods (commercial) — never "gift" or "sample"'),
      for (final d in details) ...[
        ('Description', d.description),
        ('HS code', d.hsCode),
        if (d.netWeight != null) ('Net weight', d.netWeight!),
        if (d.originCountry != null) ('Country of origin', d.originCountry!),
      ],
      ('Quantity', '${details.length}'),
      ('Value of goods', '€${goods.toStringAsFixed(2)} EUR'),
      if ((order.shippingCost ?? 0) > 0) ('Shipping charged', '€${order.shippingCost!.toStringAsFixed(2)} EUR'),
      ('Invoice', _invoice == null ? 'Not issued yet' : '${_invoice!['number']} (print it and put it in the parcel)'),
      ('Sender name', 'GemWorkers'),
      if (_shipFrom == 'NL') ('EORI (exporter)', (_eori ?? '').isEmpty ? 'Add it in Taxes & duties → Company details' : _eori!),
      if (_shipFrom == 'NL' && goods > 1000) ('Export declaration', 'Over €1,000: the courier makes it with your EORI — keep their export document as proof'),
      ('Import taxes', 'Paid by the buyer on delivery (DAP / DDU)'),
    ];
    final text = lines.map((l) => '${l.$1}: ${l.$2}').join('\n');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text('Customs form (CN22 / CN23)', style: t.titleMedium)),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy all'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customs details copied.')));
              },
            ),
          ]),
          const SizedBox(height: 6),
          for (final l in lines) _row(l.$1, l.$2),
          for (final d in details)
            if (d.hsNote != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('HS code: ${d.hsNote}', style: t.bodySmall?.copyWith(color: Colors.orange.shade800)),
              ),
          if (anyDiamond)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Diamonds: include the Kimberley Process certificate / warranty statement (it is on the invoice).',
                  style: t.bodySmall?.copyWith(color: Colors.orange.shade800)),
            ),
          if (_invoice != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.print_outlined, size: 18),
                label: const Text('Open invoice to print'),
                onPressed: () => openUrl('https://www.gemworkers.com/invoices/${_invoice!['id']}'),
              ),
            ),
          Text(
            'Write the same value as the invoice — never lower. Customs starting values: check the HS code with your courier.',
            style: t.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ]),
      ),
    );
  }

  Widget _buildShippingAddress(Order order) {
    final hasAddress = order.shippingLine1 != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shipping Address',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (!hasAddress)
              Text(
                'No shipping address on file',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              )
            else ...[
              if (order.shippingName != null)
                _row('Recipient', order.shippingName!),
              _addressLine(order.shippingLine1!),
              if (order.shippingLine2?.isNotEmpty == true)
                _addressLine(order.shippingLine2!),
              _addressLine(_cityStateLine(order)),
              if (order.shippingCountry?.isNotEmpty == true)
                _addressLine(order.shippingCountry!),
              if (order.shippingPhone?.isNotEmpty == true)
                _row('Phone', order.shippingPhone!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _addressLine(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  String _cityStateLine(Order order) {
    final city = order.shippingCity ?? '';
    final statePostal = [
      if (order.shippingState?.isNotEmpty == true) order.shippingState!,
      if (order.shippingPostalCode?.isNotEmpty == true) order.shippingPostalCode!,
    ].join(' ');
    if (city.isEmpty) return statePostal;
    if (statePostal.isEmpty) return city;
    return '$city, $statePostal';
  }

  Widget? _buildActionBar(Order order) {
    final status = order.status;
    // Refunded (returns_setup.sql): no shipping and never a payout.
    if (status == 'cancelled' || status == 'pending_payment' || status == 'refunded') return null;

    // Brothers' and owners' sales are paid under Payouts (charges deducted).
    final showPayoutButton = UserProfileService.instance.isOwner &&
        order.saleChannel == 'platform' &&
        order.payoutStatus != 'paid' &&
        !const {'commission', 'consignment', 'own'}.contains(order.payoutKind);

    // Payout button is available from 'confirmed' onward (not draft/cancelled).
    final showPayout = showPayoutButton &&
        const {'confirmed', 'shipped', 'received', 'paid'}.contains(status);

    if (status == 'received' && !showPayout) return null;

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
                    label: Text(UserProfileService.instance.isOwner
                        ? 'Ship (Admin Override)'
                        : 'Mark as Shipped'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange),
                  ),
                ),
                if (showPayout) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _actionInProgress ? null : _markPayoutPaid,
                      icon: const Icon(Icons.payments_outlined),
                      label: const Text('Mark Payout Paid'),
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ),
                ],
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
            if (status == 'shipped') ...[
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
              if (showPayout) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _actionInProgress ? null : _markPayoutPaid,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Mark Payout Paid'),
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ],
            if (status == 'received' && showPayout)
              Expanded(
                child: FilledButton.icon(
                  onPressed: _actionInProgress ? null : _markPayoutPaid,
                  icon: const Icon(Icons.payments_outlined),
                  label: const Text('Mark Payout Paid'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            if (status == 'paid') ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _actionInProgress ? null : _cancelOrder,
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Cancel & Revert Items'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red),
                ),
              ),
              if (showPayout) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _actionInProgress ? null : _markPayoutPaid,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('Mark Payout Paid'),
                    style:
                        FilledButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ],
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

  /// Payout breakdown per kind (sql/consignment_setup.sql).
  List<Widget> _payoutRows(Order order) {
    final fee = order.stripeFee ?? 0;
    final isOwner = UserProfileService.instance.isOwner;
    switch (order.payoutKind) {
      case 'consignment':
        final goods = order.orderTotal - (order.shippingCost ?? 0);
        final extra = ((order.postagePaid ?? 0) - (order.shippingCost ?? 0)).clamp(0, double.infinity).toDouble();
        final profit = goods - (order.consignorPrice ?? 0) - extra - fee;
        return [
          const Divider(height: 16),
          _row('Owner', order.consignorName ?? '—'),
          _moneyRow('Stone price', goods),
          _moneyRow("Owner's price", order.consignorPrice ?? 0, prefix: '−'),
          if (extra > 0) _moneyRow('Postage (beyond shipping paid)', extra, prefix: '−'),
          _moneyRow('Stripe fee', fee, prefix: '−'),
          _moneyRow('Profit', profit),
          const Divider(height: 12),
          _moneyRow('Owner receives (price + ${_pct(order.profitShare ?? 0.5)} of profit)', order.sellerPayout, bold: true),
          _moneyRow('GemWorkers keeps', order.commissionAmount, bold: true),
          _row('Payout', _payoutStatusLabel(order)),
          if (isOwner && order.payoutStatus != 'paid' && order.status != 'refunded')
            _postageButton(order),
        ];
      case 'commission':
        return [
          const Divider(height: 16),
          if (order.commissionAmount > 0)
            _moneyRow('GemWorkers service fee (${_pct(order.commissionRate)}, min. €3 — includes payment & exchange costs)', order.commissionAmount, prefix: '−'),
          _moneyRow('Seller payout', order.sellerPayout, bold: true),
          // Paid by GemWorkers out of the commission — owner only.
          if (fee > 0 && isOwner) _moneyRow('Stripe fee (paid by GemWorkers)', fee),
          _row('Payout', _payoutStatusLabel(order)),
        ];
      case 'own':
        return [
          const Divider(height: 16),
          _row('Stone', "GemWorkers' own — no payout"),
          if (fee > 0) _moneyRow('Stripe fee (your cost)', fee),
        ];
      default:
        return [
          if (order.commissionAmount > 0) ...[
            const Divider(height: 16),
            _moneyRow('GemWorkers service fee (${_pct(order.commissionRate)})', order.commissionAmount, prefix: '−'),
            _moneyRow('Seller payout', order.sellerPayout, bold: true),
            _row('Payout', _payoutStatusLabel(order)),
          ],
        ];
    }
  }

  /// Refunds without a return + charges to the stone's owner
  /// (sql/refund_owner_costs.sql), and the Refund order button.
  List<Widget> _refundRows(Order order) {
    final canRefund = order.paidAt != null &&
        !const {'pending_payment', 'cancelled', 'refunded', 'draft'}.contains(order.status);
    return [
      if (_refunds.isNotEmpty) ...[
        const Divider(height: 16),
        for (final r in _refunds) _moneyRow('Refunded — ${r.label}', r.amount, prefix: '−'),
      ],
      if (_charges.isNotEmpty) ...[
        const Divider(height: 16),
        for (final c in _charges)
          _moneyRow(
            c.amount >= 0 ? "Charged to the stone's owner — ${c.label}" : "Credited to the stone's owner — ${c.label}",
            c.amount.abs(),
          ),
      ],
      if (canRefund)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.currency_exchange, size: 18),
            label: const Text('Refund order (no return)'),
            onPressed: _actionInProgress ? null : () => _refundOrder(order),
          ),
        ),
    ];
  }

  Future<void> _refundOrder(Order order) async {
    double left;
    try {
      left = await _refundRepo.refundable(order.id!);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      return;
    }
    if (!mounted) return;
    final amount = TextEditingController(text: left.toStringAsFixed(2));
    final reason = TextEditingController();
    var fate = 'lost';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setD) {
        final a = parseDecimalInput(amount.text) ?? 0;
        final valid = a > 0 && a <= left + 0.0001 && reason.text.trim().isNotEmpty;
        return AlertDialog(
          title: const Text('Refund order'),
          content: SizedBox(
            width: 440,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Up to €${left.toStringAsFixed(2)} can be refunded (incl. VAT). Is the stone coming back? Use Returns instead.'),
              const SizedBox(height: 12),
              TextField(
                controller: amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (_) => setD(() {}),
                decoration: const InputDecoration(labelText: 'Amount € (less = partial refund)'),
              ),
              TextField(
                controller: reason,
                maxLength: 500,
                onChanged: (_) => setD(() {}),
                decoration: const InputDecoration(labelText: 'Reason (on the credit note) *'),
              ),
              DropdownButtonFormField<String>(
                initialValue: fate,
                decoration: const InputDecoration(labelText: 'The stone'),
                items: const [
                  DropdownMenuItem(value: 'lost', child: Text('Lost in the post')),
                  DropdownMenuItem(value: 'kept', child: Text('Buyer keeps it')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (v) => setD(() => fate = v ?? fate),
              ),
              const SizedBox(height: 10),
              Text(
                order.payoutKind == 'own'
                    ? "Your own stone — the cost is yours."
                    : order.payoutKind == 'consignment'
                        ? "Partial refund: shared like the profit (owner's share charged to them). Full refund: the owner pays the lost Stripe fee."
                        : "The cost (refund without VAT, plus the Stripe fee on a full refund) is charged to the seller.",
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: valid ? () => Navigator.pop(ctx, true) : null,
              child: Text('Refund €${a.toStringAsFixed(2)}'),
            ),
          ],
        );
      }),
    );
    final a = parseDecimalInput(amount.text) ?? 0;
    final why = reason.text.trim();
    amount.dispose();
    reason.dispose();
    if (ok != true) return;
    await _runAction(() async {
      final done = await _refundRepo.refundOrder(order.id!, a, why, fate);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refunded €${done.toStringAsFixed(2)} — credit note created.')));
      }
      await _load();
    });
  }

  Widget _postageButton(Order order) => Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          icon: const Icon(Icons.local_post_office_outlined, size: 18),
          label: Text(order.postagePaid == null
              ? 'Postage I paid'
              : 'Postage paid: €${order.postagePaid!.toStringAsFixed(2)} — change'),
          onPressed: () => _editPostage(order),
        ),
      );

  Future<void> _editPostage(Order order) async {
    final c = TextEditingController(text: order.postagePaid?.toString() ?? '');
    final text = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Postage I paid'),
        content: SizedBox(
          width: 380,
          child: TextField(
            controller: c,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Postage €',
              helperText: 'Anything above the shipping the buyer paid comes off the profit before the split.',
              helperMaxLines: 3,
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
        ],
      ),
    );
    c.dispose();
    if (text == null) return;
    try {
      await ConsignorRepository().setPostagePaid(order.id!, text.trim().isEmpty ? null : parseDecimalInput(text));
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    }
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

  Widget _moneyRow(String label, double amount,
      {String prefix = '', bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: bold ? null : Colors.grey.shade600,
            ),
          ),
          Text(
            '$prefix€${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _payoutStatusLabel(Order order) {
    if (order.status == 'refunded' && order.payoutStatus != 'paid') return 'Not paid — order refunded';
    if (order.payoutStatus != 'paid') return 'Unpaid';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final parts = <String>['Paid'];
    if (order.payoutPaidAt != null) {
      final d = order.payoutPaidAt!.toLocal();
      parts.add('${d.day} ${months[d.month - 1]} ${d.year}');
    }
    if (order.payoutMethod?.isNotEmpty == true) parts.add(order.payoutMethod!);
    if (order.payoutReference?.isNotEmpty == true) {
      parts.add('ref ${order.payoutReference!}');
    }
    return parts.join(' · ');
  }

  String _pct(double rate) {
    final pct = rate * 100;
    return pct % 1 == 0 ? '${pct.toInt()}%' : '${pct.toStringAsFixed(1)}%';
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  Color get _color => orderStatusColor(status);

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
        orderStatusLabel(status),
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
