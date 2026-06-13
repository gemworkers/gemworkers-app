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

// ── Per-line cost breakdown (computed from Method B in the page) ──────────────

class _LineSummary {
  final double lineValue;
  final double overheadShare;
  final double landedCost;
  final double perItemCost;

  const _LineSummary({
    required this.lineValue,
    required this.overheadShare,
    required this.landedCost,
    required this.perItemCost,
  });

  static const zero = _LineSummary(
    lineValue: 0,
    overheadShare: 0,
    landedCost: 0,
    perItemCost: 0,
  );
}

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

  String get dbValue => name;
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

  // Gem cost is auto-calculated from line item prices — no controller needed.
  final _shippingCtrl = TextEditingController();
  final _customsCtrl = TextEditingController();
  final _otherFeesCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final List<_DraftLineItem> _items = [];
  bool _createInventoryItems = true;

  bool get _isEdit => widget.purchase != null;

  // ── Computed totals ───────────────────────────────────────────────────────

  double get _gemCost => _items.fold(0.0, (sum, i) => sum + i.lineValue);
  double get _shipping => double.tryParse(_shippingCtrl.text) ?? 0;
  double get _customs => double.tryParse(_customsCtrl.text) ?? 0;
  double get _otherFees => double.tryParse(_otherFeesCtrl.text) ?? 0;
  double get _overhead => _shipping + _customs + _otherFees;

  /// Method B: each line keeps its gem value; only overhead is split
  /// proportionally by line value. Falls back to equal-per-stone when
  /// no prices have been entered.
  List<_LineSummary> get _lineSummaries {
    if (_items.isEmpty) return [];
    final overhead = _overhead;
    final totalGemValue = _gemCost;

    if (totalGemValue == 0) {
      final totalQty = _items.fold(0, (sum, i) => sum + i.quantity);
      return _items.map((item) {
        final overheadShare =
            totalQty > 0 ? (item.quantity / totalQty) * overhead : 0.0;
        final landed = item.lineValue + overheadShare;
        final qty = item.quantity > 0 ? item.quantity : 1;
        return _LineSummary(
          lineValue: item.lineValue,
          overheadShare: overheadShare,
          landedCost: landed,
          perItemCost: landed / qty,
        );
      }).toList();
    }

    return _items.map((item) {
      final lv = item.lineValue;
      final overheadShare = (lv / totalGemValue) * overhead;
      final landed = lv + overheadShare;
      final qty = item.quantity > 0 ? item.quantity : 1;
      return _LineSummary(
        lineValue: lv,
        overheadShare: overheadShare,
        landedCost: landed,
        perItemCost: landed / qty,
      );
    }).toList();
  }

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
      _shippingCtrl.text = p.shippingCost.toStringAsFixed(2);
      _customsCtrl.text = p.customsCost.toStringAsFixed(2);
      _otherFeesCtrl.text = p.otherFees.toStringAsFixed(2);
      _notesCtrl.text = p.notes;
      _items.addAll(p.items.map((i) => _DraftLineItem.fromPurchaseItem(i)));
      _createInventoryItems = false;
    } else {
      _shippingCtrl.text = '0.00';
      _customsCtrl.text = '0.00';
      _otherFeesCtrl.text = '0.00';
    }

    for (final ctrl in [_shippingCtrl, _customsCtrl, _otherFeesCtrl]) {
      ctrl.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
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
      setState(() => _items.add(_DraftLineItem(lineType: type, quantity: 1)));
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
                  unitPrice: i.unitPrice,
                  priceMode: i.priceMode,
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
    final summaries = _lineSummaries;
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
                  _GemCostDisplay(gemCost: _gemCost),
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
                    gemValue: _gemCost,
                    overhead: _overhead,
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
                    if (_items.isNotEmpty && _gemCost == 0)
                      _WarningBanner(
                          'Enter prices on each line to distribute overhead by value'),
                    ..._items.asMap().entries.map(
                          (e) => _LineItemCard(
                            key: ValueKey(e.key),
                            item: e.value,
                            summary: e.key < summaries.length
                                ? summaries[e.key]
                                : _LineSummary.zero,
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

// ── Draft line item (form state — not persisted directly) ─────────────────────

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

  // price — UI only, not stored in DB
  final double unitPrice;
  final String priceMode; // 'per_piece' | 'total'

  final String notes;

  double get lineValue =>
      priceMode == 'per_piece' ? unitPrice * quantity : unitPrice;

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
    this.unitPrice = 0,
    this.priceMode = 'total',
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
      unitPrice: item.unitPrice,
      priceMode: item.priceMode,
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
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
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

class _GemCostDisplay extends StatelessWidget {
  final double gemCost;
  const _GemCostDisplay({required this.gemCost});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Gem Cost (€)',
          border: OutlineInputBorder(),
          helperText: 'Auto-calculated — sum of all line item prices',
          suffixIcon: Icon(Icons.lock_outline, size: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Text(
          '€ ${gemCost.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16),
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
  final double gemValue;
  final double overhead;

  const _TotalBanner({required this.gemValue, required this.overhead});

  @override
  Widget build(BuildContext context) {
    final total = gemValue + overhead;
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
                Text(
                  'Gems €${gemValue.toStringAsFixed(2)}'
                  ' · Overhead €${overhead.toStringAsFixed(2)}',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
  final _LineSummary summary;
  final VoidCallback onRemove;
  final ValueChanged<_DraftLineItem> onChanged;

  const _LineItemCard({
    super.key,
    required this.item,
    required this.summary,
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
  late final TextEditingController _price;
  late final TextEditingController _notes;
  late String _weightUnit;
  late String _priceMode;

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
    _approxCount =
        TextEditingController(text: i.approxCount?.toString() ?? '');
    _price = TextEditingController(
        text: i.unitPrice > 0 ? i.unitPrice.toStringAsFixed(2) : '');
    _notes = TextEditingController(text: i.notes);
    _weightUnit = i.weightUnit;
    _priceMode = i.priceMode;

    for (final c in [
      _gemType, _variety, _weight, _origin,
      _itemName, _approxCount, _price, _notes,
    ]) {
      c.addListener(_notify);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _gemType, _variety, _weight, _origin,
      _itemName, _approxCount, _price, _notes,
    ]) {
      c.removeListener(_notify);
      c.dispose();
    }
    super.dispose();
  }

  void _notify() => widget.onChanged(_build());

  int _computeQty() => switch (widget.item.lineType) {
        PurchaseLineType.individual => 1,
        PurchaseLineType.lot => int.tryParse(_approxCount.text) ?? 1,
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
        unitPrice: double.tryParse(_price.text) ?? 0,
        priceMode: _priceMode,
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
      unitPrice: double.tryParse(_price.text) ?? 0,
      priceMode: _priceMode,
      notes: _notes.text.trim(),
    ));
  }

  // ── Price field helpers ───────────────────────────────────────────────────

  String get _priceFieldLabel {
    final type = widget.item.lineType;
    if (type == PurchaseLineType.individual) return 'Price (€)';
    if (type == PurchaseLineType.multiple) {
      return _priceMode == 'per_piece'
          ? 'Price per piece (€)'
          : 'Total price (€)';
    }
    return _priceMode == 'per_piece'
        ? 'Price per stone (€)'
        : 'Total lot price (€)';
  }

  String? get _priceHelperText {
    if (widget.item.lineType == PurchaseLineType.individual) return null;
    if (_priceMode != 'per_piece') return null;
    final price = double.tryParse(_price.text) ?? 0;
    final qty = widget.item.quantity;
    final total = price * qty;
    final unit = widget.item.lineType == PurchaseLineType.lot ? 'stone' : 'piece';
    return '€${price.toStringAsFixed(2)} × $qty ${unit}s = €${total.toStringAsFixed(2)} total';
  }

  Widget _buildPriceModeToggle() {
    final isLot = widget.item.lineType == PurchaseLineType.lot;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SegmentedButton<String>(
        segments: [
          ButtonSegment(
            value: 'per_piece',
            label: Text(isLot ? 'Per stone' : 'Per piece',
                style: const TextStyle(fontSize: 12)),
          ),
          const ButtonSegment(
            value: 'total',
            label: Text('Total', style: TextStyle(fontSize: 12)),
          ),
        ],
        selected: {_priceMode},
        onSelectionChanged: (s) {
          setState(() => _priceMode = s.first);
          _notify();
        },
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _price,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: _priceFieldLabel,
          prefixText: '€ ',
          isDense: true,
          border: const OutlineInputBorder(),
          helperText: _priceHelperText,
        ),
      ),
    );
  }

  // ── Cost footer ───────────────────────────────────────────────────────────

  String get _perItemLabel => switch (widget.item.lineType) {
        PurchaseLineType.individual => 'per gem',
        PurchaseLineType.multiple => 'per piece',
        PurchaseLineType.lot => 'per stone est.',
      };

  Widget _buildCostFooter(BuildContext context) {
    final s = widget.summary;
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _CostStat('gem value', '€${s.lineValue.toStringAsFixed(2)}'),
          _CostStat('+ overhead', '+€${s.overheadShare.toStringAsFixed(2)}'),
          _CostStat('landed', '€${s.landedCost.toStringAsFixed(2)}',
              highlight: true, color: cs.primary),
          _CostStat(_perItemLabel, '€${s.perItemCost.toStringAsFixed(2)}',
              highlight: true, color: cs.primary),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.item.lineType;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────
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

            // ── Price entry ─────────────────────────────────────────────
            if (type != PurchaseLineType.individual) _buildPriceModeToggle(),
            _buildPriceField(),

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

            // ── Cost breakdown ──────────────────────────────────────────
            _buildCostFooter(context),
          ],
        ),
      ),
    );
  }
}

// ── Cost stat cell ────────────────────────────────────────────────────────────

class _CostStat extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? color;

  const _CostStat(this.label, this.value,
      {this.highlight = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              textAlign: TextAlign.center),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  highlight ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Line type chip ────────────────────────────────────────────────────────────

class _LineTypeChip extends StatelessWidget {
  final PurchaseLineType type;
  const _LineTypeChip(this.type);

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (type) {
      PurchaseLineType.individual => (Colors.blue, Icons.diamond_outlined),
      PurchaseLineType.multiple =>
        (Colors.green, Icons.inventory_2_outlined),
      PurchaseLineType.lot => (Colors.orange, Icons.category_outlined),
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
