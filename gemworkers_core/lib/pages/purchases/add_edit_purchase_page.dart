import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/seller_service.dart';
import '../../models/location.dart';
import '../../models/purchase.dart';
import '../../models/supplier.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/purchase_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../../shared/form_widgets.dart';
import '../locations/location_picker_dialog.dart';

class AddEditPurchasePage extends StatefulWidget {
  final Purchase? purchase;
  const AddEditPurchasePage({super.key, this.purchase});

  @override
  State<AddEditPurchasePage> createState() => _AddEditPurchasePageState();
}

class _AddEditPurchasePageState extends State<AddEditPurchasePage> {
  final _purchaseRepo = PurchaseRepository();
  final _supplierRepo = SupplierRepository();
  final _locationRepo = LocationRepository();

  List<Supplier> _suppliers = [];
  bool _loadingSuppliers = true;
  bool _saving = false;

  String? _supplierId;
  DateTime _purchaseDate = DateTime.now();
  // Destination location for auto-created inventory items (Intake by default).
  Location? _destinationLocation;
  final _gemCostCtrl = TextEditingController();
  final _shippingCtrl = TextEditingController();
  final _customsCtrl = TextEditingController();
  final _otherFeesCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final List<_DraftLineItem> _items = [];
  bool _createInventoryItems = true;

  bool get _isEdit => widget.purchase != null;

  // ── Computed totals ───────────────────────────────────────────────────────

  double get _gemCost => double.tryParse(_gemCostCtrl.text) ?? 0;
  double get _shipping => double.tryParse(_shippingCtrl.text) ?? 0;
  double get _customs => double.tryParse(_customsCtrl.text) ?? 0;
  double get _otherFees => double.tryParse(_otherFeesCtrl.text) ?? 0;
  double get _totalLanded => _gemCost + _shipping + _customs + _otherFees;

  int get _totalQty => _items.fold(0, (sum, i) => sum + i.quantity);
  double get _costPerGem => _totalQty > 0 ? _totalLanded / _totalQty : 0;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    if (widget.purchase == null) _loadDefaultDestination();
    final p = widget.purchase;
    if (p != null) {
      _supplierId = p.supplierId;
      _purchaseDate = p.purchaseDate;
      _gemCostCtrl.text = p.gemCost.toStringAsFixed(2);
      _shippingCtrl.text = p.shippingCost.toStringAsFixed(2);
      _customsCtrl.text = p.customsCost.toStringAsFixed(2);
      _otherFeesCtrl.text = p.otherFees.toStringAsFixed(2);
      _notesCtrl.text = p.notes;
      _items.addAll(p.items.map((i) => _DraftLineItem.fromPurchaseItem(i)));
      _createInventoryItems = false; // edit: items already exist
    } else {
      _gemCostCtrl.text = '0.00';
      _shippingCtrl.text = '0.00';
      _customsCtrl.text = '0.00';
      _otherFeesCtrl.text = '0.00';
    }

    for (final ctrl in [
      _gemCostCtrl,
      _shippingCtrl,
      _customsCtrl,
      _otherFeesCtrl,
    ]) {
      ctrl.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _gemCostCtrl.dispose();
    _shippingCtrl.dispose();
    _customsCtrl.dispose();
    _otherFeesCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultDestination() async {
    try {
      final locations =
          await _locationRepo.getLocationsFlat(kCurrentSellerId);
      final intake = locations
          .where((l) =>
              l.isStatusZone && l.name.toLowerCase().contains('intake'))
          .firstOrNull;
      if (mounted && intake != null) {
        setState(() => _destinationLocation = intake);
      }
    } catch (_) {}
  }

  Future<void> _pickDestination() async {
    final picked = await showLocationPicker(
      context,
      sellerId: kCurrentSellerId,
      currentLocationId: _destinationLocation?.id,
      statusZonesOnly: false,
    );
    if (picked != null && mounted) {
      setState(() => _destinationLocation = picked);
    }
  }

  Future<void> _loadSuppliers() async {
    try {
      final suppliers = await _supplierRepo.getSuppliers();
      if (mounted) {
        setState(() {
          _suppliers = suppliers;
          _loadingSuppliers = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingSuppliers = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _purchaseDate = picked);
  }

  void _addItem() {
    setState(() =>
        _items.add(const _DraftLineItem(gemType: '', quantity: 1)));
  }

  void _removeItem(int index) => setState(() => _items.removeAt(index));

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final purchase = Purchase(
        supplierId: _supplierId,
        purchaseDate: _purchaseDate,
        gemCost: _gemCost,
        shippingCost: _shipping,
        customsCost: _customs,
        otherFees: _otherFees,
        notes: _notesCtrl.text.trim(),
        items: _items
            .map((i) => PurchaseItem(
                  id: i.purchaseItemId,
                  gemType: i.gemType,
                  quantity: i.quantity,
                  allocatedCost: 0, // computed by repository
                  notes: i.notes,
                ))
            .toList(),
      );

      if (_isEdit) {
        await _purchaseRepo.updatePurchase(widget.purchase!.id!, purchase);
      } else {
        await _purchaseRepo.addPurchase(
          purchase,
          createInventoryItems: _createInventoryItems,
          destinationLocationId: _destinationLocation?.id,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Purchase' : 'New Purchase'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: _loadingSuppliers
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FormSection('Purchase Details'),
                  _buildSupplierDropdown(),
                  _DatePickerRow(date: _purchaseDate, onTap: _pickDate),
                  FormTextField('Notes', _notesCtrl, maxLines: 2),

                  const FormSection('Costs'),
                  _CostField(
                      label: 'Gem Cost (€)', controller: _gemCostCtrl),
                  _CostField(
                      label: 'Shipping Cost (€)',
                      controller: _shippingCtrl),
                  _CostField(
                      label: 'Customs Cost (€)',
                      controller: _customsCtrl),
                  _CostField(
                      label: 'Other Fees (€)',
                      controller: _otherFeesCtrl),
                  _TotalBanner(
                    total: _totalLanded,
                    totalQty: _totalQty,
                    costPerGem: _costPerGem,
                  ),

                  const FormSection('Gem Line Items'),
                  if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'No line items — the total landed cost will not be split',
                          style:
                              TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else ...[
                    if (_totalQty == 0)
                      _WarningBanner(
                          'Set at least 1 quantity to calculate cost shares'),
                    ..._items.asMap().entries.map(
                          (e) => _LineItemCard(
                            item: e.value,
                            costPerGem: _costPerGem,
                            onRemove: () => _removeItem(e.key),
                            onChanged: (updated) =>
                                setState(() => _items[e.key] = updated),
                          ),
                        ),
                  ],
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Gem Line'),
                  ),

                  if (!_isEdit) ...[
                    const FormSection('Options'),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                          'Create inventory items from this purchase'),
                      subtitle: const Text(
                        'Creates one draft inventory item per gem '
                        '(respecting quantity), each with its landed cost.',
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _createInventoryItems,
                      onChanged: (v) =>
                          setState(() => _createInventoryItems = v),
                    ),
                    if (_createInventoryItems) ...[
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDestination,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Destination Location',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.place_outlined, size: 18),
                            helperText:
                                'Where to place the created items (default: Intake)',
                          ),
                          child: Text(
                            _destinationLocation?.name ?? 'None — tap to pick',
                            style: TextStyle(
                              color: _destinationLocation == null
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSupplierDropdown() {
    final ids = <String?>[null, ..._suppliers.map((s) => s.id)];

    if (_suppliers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Supplier (optional)',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: const Text('No suppliers — add one in Suppliers',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return FormDropdownField<String?>(
      label: 'Supplier (optional)',
      value: _supplierId,
      items: ids,
      onChanged: (v) => setState(() => _supplierId = v),
      itemLabel: (id) {
        if (id == null) return 'No supplier';
        return _suppliers.where((s) => s.id == id).firstOrNull?.name ??
            id;
      },
    );
  }
}

// ── Draft line item ───────────────────────────────────────────────────────────

class _DraftLineItem {
  final String? purchaseItemId;
  final String gemType;
  final int quantity;
  final String notes;

  const _DraftLineItem({
    this.purchaseItemId,
    required this.gemType,
    required this.quantity,
    this.notes = '',
  });

  factory _DraftLineItem.fromPurchaseItem(PurchaseItem item) =>
      _DraftLineItem(
        purchaseItemId: item.id,
        gemType: item.gemType,
        quantity: item.quantity,
        notes: item.notes,
      );

  _DraftLineItem copyWith(
          {String? gemType, int? quantity, String? notes}) =>
      _DraftLineItem(
        purchaseItemId: purchaseItemId,
        gemType: gemType ?? this.gemType,
        quantity: quantity ?? this.quantity,
        notes: notes ?? this.notes,
      );
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _DatePickerRow extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  const _DatePickerRow({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Purchase Date',
            border: OutlineInputBorder(),
            suffixIcon:
                Icon(Icons.calendar_today_outlined, size: 18),
          ),
          child: Text(
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}',
          ),
        ),
      ),
    );
  }
}

class _CostField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _CostField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: label,
          prefixText: '€ ',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _TotalBanner extends StatelessWidget {
  final double total;
  final int totalQty;
  final double costPerGem;
  const _TotalBanner({
    required this.total,
    required this.totalQty,
    required this.costPerGem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Landed Cost',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                if (totalQty > 0)
                  Text(
                    '$totalQty gem${totalQty == 1 ? '' : 's'} · '
                    '€${costPerGem.toStringAsFixed(2)} each',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700),
                  ),
              ],
            ),
          ),
          Text(
            '€${total.toStringAsFixed(2)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String message;
  const _WarningBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined,
              size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: TextStyle(
                    fontSize: 12, color: Colors.orange.shade800)),
          ),
        ],
      ),
    );
  }
}

class _LineItemCard extends StatefulWidget {
  final _DraftLineItem item;
  final double costPerGem;
  final VoidCallback onRemove;
  final ValueChanged<_DraftLineItem> onChanged;

  const _LineItemCard({
    required this.item,
    required this.costPerGem,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_LineItemCard> createState() => _LineItemCardState();
}

class _LineItemCardState extends State<_LineItemCard> {
  late final TextEditingController _gemType;
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _gemType = TextEditingController(text: widget.item.gemType);
    _notes = TextEditingController(text: widget.item.notes);
  }

  @override
  void dispose() {
    _gemType.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _notifyText() {
    widget.onChanged(widget.item.copyWith(
      gemType: _gemType.text.trim(),
      notes: _notes.text.trim(),
    ));
  }

  double get _lineTotal => widget.item.quantity * widget.costPerGem;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gem type + remove
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _gemType,
                    onChanged: (_) => _notifyText(),
                    decoration: const InputDecoration(
                      labelText: 'Gem Type',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onRemove,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Quantity stepper + cost display
            Row(
              children: [
                const Text('Qty:', style: TextStyle(fontSize: 13)),
                IconButton(
                  icon: const Icon(Icons.remove, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.item.quantity > 1
                      ? () => widget.onChanged(
                          widget.item.copyWith(
                              quantity: widget.item.quantity - 1))
                      : null,
                ),
                Text(
                  '${widget.item.quantity}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => widget.onChanged(
                      widget.item.copyWith(
                          quantity: widget.item.quantity + 1)),
                ),
                const SizedBox(width: 8),
                // Per-gem cost (read-only)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('per gem',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600)),
                    Text(
                      '€${widget.costPerGem.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Spacer(),
                // Landed share (read-only)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('landed share',
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600)),
                    Text(
                      '€${_lineTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: cs.primary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Notes
            TextField(
              controller: _notes,
              onChanged: (_) => _notifyText(),
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
