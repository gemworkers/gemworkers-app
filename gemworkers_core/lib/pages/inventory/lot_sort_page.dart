import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import 'widgets/gem_and_variety_fields.dart';

class LotSortPage extends StatefulWidget {
  final InventoryItem lot;
  const LotSortPage({super.key, required this.lot});

  @override
  State<LotSortPage> createState() => _LotSortPageState();
}

class _LotSortPageState extends State<LotSortPage> {
  final _inventoryRepo = InventoryRepository();
  final _movementRepo = ItemMovementRepository();

  late InventoryItem _lot;
  List<InventoryItem> _children = [];
  bool _loading = true;
  bool _submitting = false;

  // Form controllers
  final _gemTypeCtrl = TextEditingController();
  final _varietyCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _originCtrl = TextEditingController();
  final _shapeCtrl = TextEditingController();
  final _cutCtrl = TextEditingController();
  final _costCtrl = TextEditingController();
  String _weightUnit = 'ct';
  int _formResetKey = 0;

  @override
  void initState() {
    super.initState();
    _lot = widget.lot;
    _costCtrl.addListener(() => setState(() {}));
    _loadData();
  }

  @override
  void dispose() {
    _gemTypeCtrl.dispose();
    _varietyCtrl.dispose();
    _weightCtrl.dispose();
    _originCtrl.dispose();
    _shapeCtrl.dispose();
    _cutCtrl.dispose();
    _costCtrl.dispose();
    super.dispose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  double get _totalCost => _lot.costPrice;
  double get _allocated =>
      _children.fold(0.0, (sum, s) => sum + s.costPrice);
  double get _remaining => _totalCost - _allocated;
  int get _stonesRemaining => _lot.lotRemainingCount ?? 0;
  double get _suggestedCost =>
      _stonesRemaining > 0 ? _remaining / _stonesRemaining : 0;
  double get _enteredCost =>
      double.tryParse(_costCtrl.text.replaceAll(',', '.')) ?? 0;
  double get _remainingAfterThis => _remaining - _enteredCost;

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadData() async {
    if (_lot.id == null) return;
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _inventoryRepo.getItem(_lot.id!),
        _inventoryRepo.getLotChildren(_lot.id!),
      ]);
      if (mounted) {
        setState(() {
          _lot = results[0] as InventoryItem;
          _children = results[1] as List<InventoryItem>;
          _loading = false;
        });
        if (_costCtrl.text.isEmpty) {
          final s = _suggestedCost;
          if (s > 0) _costCtrl.text = s.toStringAsFixed(2);
        }
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _resetForm() {
    _gemTypeCtrl.clear();
    _varietyCtrl.clear();
    _weightCtrl.clear();
    _originCtrl.clear();
    _shapeCtrl.clear();
    _cutCtrl.clear();
    final s = _suggestedCost;
    _costCtrl.text = s > 0 ? s.toStringAsFixed(2) : '';
    setState(() {
      _weightUnit = 'ct';
      _formResetKey++;
    });
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _addStone() async {
    final cost =
        double.tryParse(_costCtrl.text.replaceAll(',', '.'));
    if (cost == null || cost < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid cost for this stone')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final gemType = _gemTypeCtrl.text.trim();
      final stone = InventoryItem(
        sku: '',
        title:
            gemType.isNotEmpty ? gemType : 'Stone from ${_lot.title}',
        gemType: gemType,
        variety: _varietyCtrl.text.trim(),
        originCountry: _originCtrl.text.trim(),
        originRegion: '',
        shape: _shapeCtrl.text.trim(),
        cutType: _cutCtrl.text.trim(),
        weightValue:
            double.tryParse(_weightCtrl.text.replaceAll(',', '.')) ?? 0,
        weightUnit: _weightUnit,
        quantity: 1,
        costPrice: cost,
        salePrice: 0,
        barcode: '',
        qrCode: '',
        status: 'draft',
        notes: '',
        imageUrls: const [],
        supplierId: _lot.supplierId,
        sellerId: _lot.sellerId ??
            UserProfileService.instance.effectiveSellerId,
        locationId: _lot.locationId,
        parentLotId: _lot.id,
        isUnsortedLot: false,
      );

      final created = await _inventoryRepo.addLotStone(
        stone: stone,
        lotId: _lot.id!,
        lotRemainingCount: _stonesRemaining,
      );

      if (_lot.locationId != null) {
        await _movementRepo.recordMovement(
          inventoryItemId: created.id!,
          fromLocationId: null,
          toLocationId: _lot.locationId,
          reason: 'Sorted from lot: ${_lot.title}',
        );
      }

      await _loadData();
      if (mounted) _resetForm();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _editStoneCost(InventoryItem stone) async {
    final ctrl = TextEditingController(
        text: stone.costPrice.toStringAsFixed(2));
    final label =
        stone.gemType.isNotEmpty ? stone.gemType : 'Stone';
    final newCost = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit cost — $label'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Cost (€)',
            prefixText: '€ ',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final v = double.tryParse(
                  ctrl.text.replaceAll(',', '.'));
              if (v == null || v < 0) return;
              Navigator.pop(ctx, v);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (newCost == null || !mounted) return;
    try {
      await _inventoryRepo.updateItemCost(stone.id!, newCost);
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> _confirmDeleteStone(InventoryItem stone) async {
    final label =
        stone.gemType.isNotEmpty ? stone.gemType : 'this stone';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Stone'),
        content: Text(
          'Remove $label (€${stone.costPrice.toStringAsFixed(2)}) from this lot? '
          'Its cost will be returned to the remaining balance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor:
                  Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await _inventoryRepo.removeLotStone(
        stoneId: stone.id!,
        lotId: _lot.id!,
        lotRemainingCount: _stonesRemaining,
      );
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Remove failed: $e')));
      }
    }
  }

  Future<void> _markLotSorted() async {
    if (_remaining.abs() > 0.01) {
      final over = _remaining < 0;
      final absStr = _remaining.abs().toStringAsFixed(2);
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Uneven allocation'),
          content: Text(
            '€$absStr is still ${over ? 'over-allocated' : 'unallocated'} — '
            "the lot's total cost won't exactly match the sum of its stones. "
            'Continue anyway?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Mark complete anyway'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    try {
      await _inventoryRepo.markLotSorted(_lot.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lot marked as sorted')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fullySorted = !_loading && _stonesRemaining == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sort Lot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _WalletHeader(
            lot: _lot,
            totalCost: _totalCost,
            allocated: _allocated,
            remaining: _remaining,
            stonesCreated: _children.length,
            stonesRemaining: _stonesRemaining,
          ),
          if (_loading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 80),
                children: [
                  if (fullySorted) ...[
                    _FullySortedBanner(onMarkComplete: _markLotSorted),
                    const SizedBox(height: 16),
                  ],
                  _buildAddForm(cs),
                  const SizedBox(height: 20),
                  _buildStonesList(cs),
                  if (!fullySorted && _children.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: _markLotSorted,
                        child: const Text('Mark lot complete'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddForm(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.add_circle_outline,
                    size: 18, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Add a stone',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            GemAndVarietyFields(
              key: ValueKey(_formResetKey),
              gemTypeController: _gemTypeCtrl,
              varietyController: _varietyCtrl,
            ),

            // Weight + unit
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: _weightCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        isDense: true,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                      ),
                      child: DropdownButton<String>(
                        value: _weightUnit,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: const ['ct', 'g', 'kg']
                            .map((u) => DropdownMenuItem(
                                value: u, child: Text(u)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _weightUnit = v);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Origin
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: TextField(
                controller: _originCtrl,
                decoration: const InputDecoration(
                  labelText: 'Origin Country',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Shape + Cut
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14, right: 6),
                    child: TextField(
                      controller: _shapeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Shape',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 14, left: 6),
                    child: TextField(
                      controller: _cutCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Cut',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Cost
            TextField(
              controller: _costCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Assigned Cost (€)',
                prefixText: '€ ',
                isDense: true,
                border: const OutlineInputBorder(),
                helperText: _costCtrl.text.isNotEmpty
                    ? 'Remaining after this: €${_remainingAfterThis.toStringAsFixed(2)}'
                    : _suggestedCost > 0
                        ? 'Suggested: €${_suggestedCost.toStringAsFixed(2)}'
                        : null,
                helperStyle: TextStyle(
                  color: _costCtrl.text.isNotEmpty &&
                          _remainingAfterThis < -0.01
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submitting ? null : _addStone,
                icon: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.add, size: 18),
                label: const Text('Add stone'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStonesList(ColorScheme cs) {
    if (_children.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No stones sorted yet — use the form above',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stones sorted so far (${_children.length})',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ..._children.map((stone) {
          final weightStr = stone.weightValue > 0
              ? '${stone.weightValue.toStringAsFixed(2)} ${stone.weightUnit}'
              : '';
          final details = [
            if (stone.variety.isNotEmpty) stone.variety,
            if (weightStr.isNotEmpty) weightStr,
          ].join(' · ');

          return Card(
            margin: const EdgeInsets.only(bottom: 4),
            child: ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              title: Text(
                stone.gemType.isNotEmpty ? stone.gemType : 'Stone',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: details.isNotEmpty
                  ? Text(details,
                      style: const TextStyle(fontSize: 12))
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '€${stone.costPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: cs.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () => _editStoneCost(stone),
                    tooltip: 'Edit cost',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 18, color: cs.error),
                    onPressed: () => _confirmDeleteStone(stone),
                    tooltip: 'Remove stone',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              onTap: () => _editStoneCost(stone),
            ),
          );
        }),
      ],
    );
  }
}

// ── Wallet header ─────────────────────────────────────────────────────────────

class _WalletHeader extends StatelessWidget {
  final InventoryItem lot;
  final double totalCost;
  final double allocated;
  final double remaining;
  final int stonesCreated;
  final int stonesRemaining;

  const _WalletHeader({
    required this.lot,
    required this.totalCost,
    required this.allocated,
    required this.remaining,
    required this.stonesCreated,
    required this.stonesRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isOver = remaining < -0.01;
    final isDone = remaining.abs() <= 0.01;
    final remainingColor = isOver
        ? cs.error
        : isDone
            ? Colors.green
            : cs.primary;

    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lot.title,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 15),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _WalletStat(
                label: 'Total cost',
                value: '€${totalCost.toStringAsFixed(2)}',
              ),
              _vDivider(),
              _WalletStat(
                label: 'Allocated',
                value: '€${allocated.toStringAsFixed(2)}',
              ),
              _vDivider(),
              _WalletStat(
                label: isOver ? 'Over by' : 'Remaining',
                value: '€${remaining.abs().toStringAsFixed(2)}',
                valueColor: remainingColor,
                bold: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$stonesCreated stone${stonesCreated == 1 ? '' : 's'} sorted'
            ' · ~$stonesRemaining remaining in lot',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
        width: 1,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.grey.shade300,
      );
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _WalletStat({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fully sorted banner ───────────────────────────────────────────────────────

class _FullySortedBanner extends StatelessWidget {
  final VoidCallback onMarkComplete;
  const _FullySortedBanner({required this.onMarkComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Lot fully sorted!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          FilledButton(
            onPressed: onMarkComplete,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Mark complete'),
          ),
        ],
      ),
    );
  }
}
