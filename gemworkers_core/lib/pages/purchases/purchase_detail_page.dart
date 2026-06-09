import 'package:flutter/material.dart';

import '../../models/inventory_item.dart';
import '../../models/purchase.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/purchase_repository.dart';
import '../inventory/inventory_detail_page.dart';
import 'add_edit_purchase_page.dart';

class PurchaseDetailPage extends StatefulWidget {
  final String purchaseId;
  const PurchaseDetailPage({super.key, required this.purchaseId});

  @override
  State<PurchaseDetailPage> createState() => _PurchaseDetailPageState();
}

class _PurchaseDetailPageState extends State<PurchaseDetailPage> {
  final _purchaseRepo = PurchaseRepository();
  final _inventoryRepo = InventoryRepository();

  Purchase? _purchase;
  List<InventoryItem> _inventoryItems = [];
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
      final purchaseFuture =
          _purchaseRepo.getPurchaseDetail(widget.purchaseId);
      final inventoryFuture =
          _inventoryRepo.getItemsByPurchase(widget.purchaseId);

      final results = await Future.wait([purchaseFuture, inventoryFuture]);

      if (mounted) {
        setState(() {
          _purchase = results[0] as Purchase;
          _inventoryItems = results[1] as List<InventoryItem>;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditPurchasePage(purchase: _purchase)),
    );
    if (saved == true) _load();
  }

  Future<void> _deletePurchase() async {
    final confirmed = await _confirmDialog(
      title: 'Delete Purchase',
      body: 'Delete "${_purchase!.purchaseNumber}"? This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    await _runAction(() async {
      await _purchaseRepo.deletePurchase(widget.purchaseId);
      if (mounted) Navigator.pop(context, true);
    });
  }

  Future<void> _openInventoryItem(InventoryItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InventoryDetailPage(item: item)),
    );
    _load();
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
    final purchase = _purchase;

    return Scaffold(
      appBar: AppBar(
        title: Text(purchase?.purchaseNumber.isNotEmpty == true
            ? purchase!.purchaseNumber
            : 'Purchase'),
        actions: [
          if (!_loading && purchase != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: _actionInProgress ? null : _openEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _actionInProgress ? null : _deletePurchase,
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : purchase == null
              ? const Center(child: Text('Purchase not found'))
              : Stack(
                  children: [
                    ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      children: [
                        _buildHeader(purchase),
                        const SizedBox(height: 16),
                        _buildCostBreakdown(purchase),
                        const SizedBox(height: 16),
                        _buildLineItems(purchase),
                        if (_inventoryItems.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildInventoryItems(),
                        ],
                        if (purchase.notes.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildNotes(purchase),
                        ],
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
    );
  }

  Widget _buildHeader(Purchase purchase) {
    final totalGems = purchase.totalGems;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              purchase.purchaseNumber.isNotEmpty
                  ? purchase.purchaseNumber
                  : '—',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(height: 20),
            _row('Supplier',
                purchase.supplierName.isNotEmpty
                    ? purchase.supplierName
                    : '—'),
            _row(
              'Date',
              '${purchase.purchaseDate.day.toString().padLeft(2, '0')}/'
                  '${purchase.purchaseDate.month.toString().padLeft(2, '0')}/'
                  '${purchase.purchaseDate.year}',
            ),
            _row('Gem lines', '${purchase.items.length}'),
            if (totalGems > 0)
              _row('Total gems', '$totalGems · '
                  '€${purchase.costPerGem.toStringAsFixed(2)} each'),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBreakdown(Purchase purchase) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cost Breakdown',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _costRow('Gem Cost', purchase.gemCost),
            if (purchase.shippingCost > 0)
              _costRow('Shipping', purchase.shippingCost),
            if (purchase.customsCost > 0)
              _costRow('Customs', purchase.customsCost),
            if (purchase.otherFees > 0)
              _costRow('Other Fees', purchase.otherFees),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Landed Cost',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                Text(
                  '€${purchase.totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItems(Purchase purchase) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gem Lines',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (purchase.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(
                    child: Text('No line items',
                        style: TextStyle(color: Colors.grey))),
              )
            else
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.8),
                  1: IntrinsicColumnWidth(),
                  2: FlexColumnWidth(1.8),
                  3: FlexColumnWidth(1.6),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade300))),
                    children: const [
                      _TableHeader('Gem Type'),
                      _TableHeader('Qty'),
                      _TableHeader('Landed Share'),
                      _TableHeader('Per Gem'),
                    ],
                  ),
                  ...purchase.items.map(
                    (item) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            item.gemType.isNotEmpty ? item.gemType : '—',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          child: Text('${item.quantity}',
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '€${item.allocatedCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '€${item.costPerGem.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Created Inventory Items (${_inventoryItems.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ..._inventoryItems.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () => _openInventoryItem(item),
                leading:
                    const Icon(Icons.diamond_outlined, size: 20),
                title: Text(
                  item.title.isNotEmpty ? item.title : item.gemType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  '€${item.costPrice.toStringAsFixed(2)} cost',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: _StatusChip(item.status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(Purchase purchase) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(purchase.notes),
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
            width: 80,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _costRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text('€${value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  Color get _color => switch (status) {
        'available' => Colors.green,
        'reserved' => Colors.orange,
        'sold' => Colors.red,
        'draft' => Colors.grey,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    if (status.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 11, color: _color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
