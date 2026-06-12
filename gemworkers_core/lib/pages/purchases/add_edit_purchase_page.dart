import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/location.dart';
import '../../models/purchase.dart';
import '../../models/supplier.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/purchase_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../../shared/form_widgets.dart';
import '../inventory/widgets/gem_and_variety_fields.dart';
import '../locations/location_picker_dialog.dart';

// ── Line type enum ────────────────────────────────────────────────────────────

enum PurchaseLineType {
  individual,
  multiple,
  lot;

  String get displayName => switch (this) {
        PurchaseLineType.individual => 'Individual Gem',
        PurchaseLineType.multiple => 'Multiple Items',
        PurchaseLineType.lot => 'Unsorted Lot',
      };

  String get dbValue => name; // 'individual' | 'multiple' | 'lot'
}

// ── Page ──────────────────────────────────────────────────────────────────────

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
  double get _costPerUnit => _totalQty > 0 ? _totalLanded / _totalQty : 0;

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
      _createInventoryItems = false;
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
      final locations = await _locationRepo
          .getLocationsFlat(UserProfileService.instance.effectiveSellerId);
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
      sellerId: UserProfileService.instance.effectiveSellerId,
      currentLocationId: _destinationLocation?.id,
      statusZonesOnly: false,
    );
    if (picked != null && mounted) {
      setState(() => _destinationLocation = picked);
    }
  }

  Future<void> _loadSuppliers() async {
    try {
      final svc = UserProfileService.instance;
      final suppliers = await _supplierRepo.getSuppliers(
        sellerId: svc.shouldFilterBySeller ? svc.sellerId : null,
      );
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

  // ── Line item management ──────────────────────────────────────────────────

  Future<void> _addItem() async {
    final type = await showDialog<PurchaseLineType>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Choose line item type'),
        children: [
          _TypeOption(
            icon: Icons.diamond_outlined,
            color: Colors.blue,
            title: 'Individual Gem',
            subtitle: 'One unique stone — gem type, weight, origin',
            onTap: () => Navigator.pop(ctx, PurchaseLineType.individual),
          ),
          _TypeOption(
            icon: Icons.inventory_2_outlined,
            color: Colors.green,
            title: 'Multiple / Identical',
            subtitle: 'Many of the same item, e.g. 20 tiger eye bracelets',
            onTap: () => Navigator.pop(ctx, PurchaseLineType.multiple),
          ),
          _TypeOption(
            icon: Icons.category_outlined,
            color: Colors.orange,
            title: 'Unsorted Lot',
            subtitle: 'Mixed batch — one placeholder, sort into gems later',
            onTap: () => Navigator.pop(ctx, PurchaseLineType.lot),
          ),
        ],
      ),
    );
    if (type != null && mounted) {
      setState(() => _items.add(_DraftLineItem(
            lineType: type,
            quantity: type == PurchaseLineType.individual ? 1 : 1,
          )));
    }
  }

  void _removeItem(int index) => setState(() => _items.removeAt(index));

  // ── Save ──────────────────────────────────────────────────────────────────

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
                  lineType: i.lineType.dbValue,
                  gemType: i.gemType,
                  variety: i.variety,
                  weightValue: i.weightValue,
                  weightUnit: i.weightUnit,
                  originCountry: i.originCountry,
                  itemName: i.itemName,
                  approxCount: i.approxCount,
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
                    costPerUnit: _costPerUnit,
                  ),

                  const FormSection('Line Items'),
                  if (_items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Text(
                          'No line items — total landed cost will not be split',
                          style: TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else ...[
                    if (_totalQty == 0)
                      _WarningBanner(
                          'Enter quantities or stone counts to calculate cost shares'),
                    ..._items.asMap().entries.map(
                          (e) => _LineItemCard(
                            key: ValueKey(e.key),
                            item: e.value,
                            costPerUnit: _costPerUnit,
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
                    label: const Text('Add Line Item'),
                  ),

                  if (!_isEdit) ...[
                    const FormSection('Options'),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                          'Create inventory items from this purchase'),
                      subtitle: const Text(
                        'Creates one draft inventory item per line '
                        '(individual gems, multiples, or lot placeholders), '
                        'each with its allocated landed cost.',
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
                            suffixIcon:
                                Icon(Icons.place_outlined, size: 18),
                            helperText:
                                'Where to place the created items (default: Intake)',
                          ),
                          child: Text(
                            _destinationLocation?.name ??
                                'None — tap to pick',
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
        return _suppliers.where((s) => s.id == id).firstOrNull?.name ?? id;
      },
    );
  }
}

// ── Draft line item ───────────────────────────────────────────────────────────

class _DraftLineItem {
  final String? purchaseItemId;
  final PurchaseLineType lineType;

  // individual
  final String gemType;
  final String variety;
  final double? weightValue;
  final String weightUnit;
  final String originCountry;

  // multiple + lot
  final String itemName;

  // lot
  final int? approxCount;

  // all — drives cost allocation (individual=1, multiple=count, lot=approxCount)
  final int quantity;
  final String notes;

  const _DraftLineItem({
    this.purchaseItemId,
    required this.lineType,
    this.gemType = '',
    this.variety = '',
    this.weightValue,
    this.weightUnit = 'ct',
    this.originCountry = '',
    this.itemName = '',
    this.approxCount,
    required this.quantity,
    this.notes = '',
  });

  factory _DraftLineItem.fromPurchaseItem(PurchaseItem item) {
    final type = switch (item.lineType) {
      'multiple' => PurchaseLineType.multiple,
      'lot' => PurchaseLineType.lot,
      _ => PurchaseLineType.individual,
    };
    return _DraftLineItem(
      purchaseItemId: item.id,
      lineType: type,
      gemType: item.gemType,
      variety: item.variety,
      weightValue: item.weightValue,
      weightUnit: item.weightUnit,
      originCountry: item.originCountry,
      itemName: item.itemName,
      approxCount: item.approxCount,
      quantity: item.quantity,
      notes: item.notes,
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _TypeOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withValues(alpha: 0.14),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle:
          Text(subtitle, style: const TextStyle(fontSize: 12)),
      onTap: onTap,
    );
  }
}

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
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
  final double costPerUnit;

  const _TotalBanner({
    required this.total,
    required this.totalQty,
    required this.costPerUnit,
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
                    '$totalQty unit${totalQty == 1 ? '' : 's'} · '
                    '€${costPerUnit.toStringAsFixed(2)} each',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade700),
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

// ── Line item card ────────────────────────────────────────────────────────────

class _LineItemCard extends StatefulWidget {
  final _DraftLineItem item;
  final double costPerUnit;
  final VoidCallback onRemove;
  final ValueChanged<_DraftLineItem> onChanged;

  const _LineItemCard({
    super.key,
    required this.item,
    required this.costPerUnit,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  State<_LineItemCard> createState() => _LineItemCardState();
}

class _LineItemCardState extends State<_LineItemCard> {
  late final TextEditingController _gemType;
  late final TextEditingController _variety;
  late final TextEditingController _weight;
  late final TextEditingController _origin;
  late final TextEditingController _itemName;
  late final TextEditingController _approxCount;
  late final TextEditingController _notes;
  late String _weightUnit;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _gemType = TextEditingController(text: i.gemType);
    _variety = TextEditingController(text: i.variety);
    _weight = TextEditingController(
        text: i.weightValue != null
            ? i.weightValue!.toStringAsFixed(3)
            : '');
    _origin = TextEditingController(text: i.originCountry);
    _itemName = TextEditingController(text: i.itemName);
    _approxCount = TextEditingController(
        text: i.approxCount?.toString() ?? '');
    _notes = TextEditingController(text: i.notes);
    _weightUnit = i.weightUnit;

    for (final c in [
      _gemType, _variety, _weight, _origin,
      _itemName, _approxCount, _notes,
    ]) {
      c.addListener(_notify);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _gemType, _variety, _weight, _origin,
      _itemName, _approxCount, _notes,
    ]) {
      c.removeListener(_notify);
      c.dispose();
    }
    super.dispose();
  }

  void _notify() => widget.onChanged(_build());

  int _computeQty() => switch (widget.item.lineType) {
        PurchaseLineType.individual => 1,
        PurchaseLineType.lot =>
          int.tryParse(_approxCount.text) ?? 1,
        PurchaseLineType.multiple => widget.item.quantity,
      };

  _DraftLineItem _build() => _DraftLineItem(
        purchaseItemId: widget.item.purchaseItemId,
        lineType: widget.item.lineType,
        gemType: _gemType.text.trim(),
        variety: _variety.text.trim(),
        weightValue: double.tryParse(_weight.text),
        weightUnit: _weightUnit,
        originCountry: _origin.text.trim(),
        itemName: _itemName.text.trim(),
        approxCount: int.tryParse(_approxCount.text),
        quantity: _computeQty(),
        notes: _notes.text.trim(),
      );

  void _setMultipleQty(int qty) {
    widget.onChanged(_DraftLineItem(
      purchaseItemId: widget.item.purchaseItemId,
      lineType: widget.item.lineType,
      gemType: _gemType.text.trim(),
      variety: _variety.text.trim(),
      itemName: _itemName.text.trim(),
      quantity: qty,
      notes: _notes.text.trim(),
    ));
  }

  double get _lineTotal => widget.item.quantity * widget.costPerUnit;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final type = widget.item.lineType;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: type chip + remove ──────────────────────────────
            Row(
              children: [
                _LineTypeChip(type),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: widget.onRemove,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Type-specific fields ────────────────────────────────────
            if (type == PurchaseLineType.individual) ...[
              GemAndVarietyFields(
                gemTypeController: _gemType,
                varietyController: _variety,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: TextField(
                        controller: _weight,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
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
                              _notify();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _origin,
                decoration: const InputDecoration(
                  labelText: 'Origin Country',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
            ] else if (type == PurchaseLineType.multiple) ...[
              TextField(
                controller: _itemName,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g. Tiger Eye Bracelet',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Qty:', style: TextStyle(fontSize: 13)),
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    visualDensity: VisualDensity.compact,
                    onPressed: widget.item.quantity > 1
                        ? () => _setMultipleQty(widget.item.quantity - 1)
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
                    onPressed: () =>
                        _setMultipleQty(widget.item.quantity + 1),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ] else ...[
              // lot
              TextField(
                controller: _itemName,
                decoration: const InputDecoration(
                  labelText: 'Lot Name',
                  hintText: 'e.g. Mixed Sapphire Lot',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _approxCount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Approx. stone count',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _gemType,
                      decoration: const InputDecoration(
                        labelText: 'Gem type (optional)',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],

            // ── Notes ───────────────────────────────────────────────────
            TextField(
              controller: _notes,
              maxLines: 1,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // ── Cost footer ─────────────────────────────────────────────
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _perUnitLabel(type),
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
                    Text(
                      '€${widget.costPerUnit.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'landed share',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600),
                    ),
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
          ],
        ),
      ),
    );
  }

  static String _perUnitLabel(PurchaseLineType type) => switch (type) {
        PurchaseLineType.individual => 'per gem',
        PurchaseLineType.multiple => 'per item',
        PurchaseLineType.lot => 'per stone (est.)',
      };
}

// ── Line type chip ────────────────────────────────────────────────────────────

class _LineTypeChip extends StatelessWidget {
  final PurchaseLineType type;
  const _LineTypeChip(this.type);

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (type) {
      PurchaseLineType.individual =>
        (Colors.blue, Icons.diamond_outlined),
      PurchaseLineType.multiple =>
        (Colors.green, Icons.inventory_2_outlined),
      PurchaseLineType.lot =>
        (Colors.orange, Icons.category_outlined),
    };
    return Chip(
      avatar: Icon(icon, size: 14, color: color),
      label: Text(
        type.displayName,
        style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      visualDensity: VisualDensity.compact,
    );
  }
}
