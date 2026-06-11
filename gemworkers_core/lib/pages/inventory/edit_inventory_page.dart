import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/supplier_repository.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';

class EditInventoryPage extends StatefulWidget {
  final InventoryItem item;

  const EditInventoryPage({super.key, required this.item});

  @override
  State<EditInventoryPage> createState() => _EditInventoryPageState();
}

class _EditInventoryPageState extends State<EditInventoryPage> {
  final _repository = InventoryRepository();
  final _supplierRepository = SupplierRepository();
  final _movementRepo = ItemMovementRepository();

  late final TextEditingController _sku;
  late final TextEditingController _title;
  late final TextEditingController _gemType;
  late final TextEditingController _variety;
  late final TextEditingController _originCountry;
  late final TextEditingController _originRegion;
  late final TextEditingController _shape;
  late final TextEditingController _cutType;
  late final TextEditingController _weightValue;
  late final TextEditingController _quantity;
  late final TextEditingController _costPrice;
  late final TextEditingController _salePrice;
  late final TextEditingController _barcode;
  late final TextEditingController _notes;

  late String _weightUnit;
  late String _status;

  // ── Supplier ──────────────────────────────────────────────────────────────

  List<Supplier> _suppliers = [];
  bool _loadingSuppliers = false;
  String? _supplierId;

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;
  String? _originalLocationId;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _sku = TextEditingController(text: i.sku);
    _title = TextEditingController(text: i.title);
    _gemType = TextEditingController(text: i.gemType);
    _variety = TextEditingController(text: i.variety);
    _originCountry = TextEditingController(text: i.originCountry);
    _originRegion = TextEditingController(text: i.originRegion);
    _shape = TextEditingController(text: i.shape);
    _cutType = TextEditingController(text: i.cutType);
    _weightValue = TextEditingController(text: i.weightValue.toString());
    _quantity = TextEditingController(text: i.quantity.toString());
    _costPrice = TextEditingController(text: i.costPrice.toString());
    _salePrice = TextEditingController(text: i.salePrice.toString());
    _barcode = TextEditingController(text: i.barcode);
    _notes = TextEditingController(text: i.notes);
    _weightUnit = i.weightUnit;
    _status = i.status;
    _supplierId = i.supplierId;
    _locationId = i.locationId;
    _originalLocationId = i.locationId;
    _loadSuppliers();
  }

  @override
  void dispose() {
    for (final c in [
      _sku, _title, _gemType, _variety, _originCountry, _originRegion,
      _shape, _cutType, _weightValue, _quantity, _costPrice, _salePrice,
      _barcode, _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Suppliers ─────────────────────────────────────────────────────────────

  Future<void> _loadSuppliers() async {
    setState(() => _loadingSuppliers = true);
    try {
      final suppliers = await _supplierRepository.getSuppliers();
      if (mounted) setState(() { _suppliers = suppliers; _loadingSuppliers = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingSuppliers = false);
    }
  }

  // ── Validation & save ─────────────────────────────────────────────────────

  String? _validate() {
    if (_sku.text.trim().isEmpty) return 'SKU is required.';
    if (_title.text.trim().isEmpty) return 'Title is required.';
    if (double.tryParse(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (double.tryParse(_costPrice.text) == null) {
      return 'Cost price must be a number.';
    }
    if (double.tryParse(_salePrice.text) == null) {
      return 'Sale price must be a number.';
    }
    if (int.tryParse(_quantity.text) == null) {
      return 'Quantity must be a whole number.';
    }
    return null;
  }

  Future<void> _save() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _saving = true);

    try {
      final supplierName = _supplierId != null
          ? _suppliers
              .where((s) => s.id == _supplierId)
              .map((s) => s.name)
              .firstOrNull ?? widget.item.supplierName
          : '';

      final updated = InventoryItem(
        id: widget.item.id,
        sku: _sku.text.trim(),
        title: _title.text.trim(),
        gemType: _gemType.text.trim(),
        variety: _variety.text.trim(),
        originCountry: _originCountry.text.trim(),
        originRegion: _originRegion.text.trim(),
        shape: _shape.text.trim(),
        cutType: _cutType.text.trim(),
        weightValue: double.parse(_weightValue.text),
        weightUnit: _weightUnit,
        quantity: int.parse(_quantity.text),
        costPrice: double.parse(_costPrice.text),
        salePrice: double.parse(_salePrice.text),
        barcode: _barcode.text.trim(),
        qrCode: widget.item.qrCode,
        status: _status,
        notes: _notes.text.trim(),
        imageUrls: widget.item.imageUrls,
        supplierId: _supplierId,
        supplierName: supplierName,
        locationId: _locationId,
        isListed: widget.item.isListed,
        sellingPrice: widget.item.sellingPrice,
        listedAt: widget.item.listedAt,
        createdAt: widget.item.createdAt,
      );

      await _repository.updateItem(widget.item.id!, updated);

      if (_locationId != _originalLocationId && widget.item.id != null) {
        await _movementRepo.recordMovement(
          inventoryItemId: widget.item.id!,
          fromLocationId: _originalLocationId,
          toLocationId: _locationId,
          reason: 'Manual edit',
        );
      }

      if (mounted) Navigator.pop(context, updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Supplier picker ───────────────────────────────────────────────────────

  Widget _buildSupplierPicker() {
    if (_loadingSuppliers) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }
    if (_suppliers.isEmpty) return const SizedBox.shrink();

    return FormDropdownField<String?>(
      label: 'Supplier',
      value: _supplierId,
      items: [null, ..._suppliers.where((s) => s.id != null).map((s) => s.id!)],
      itemLabel: (id) {
        if (id == null) return 'No supplier';
        return _suppliers.where((s) => s.id == id).map((s) => s.name).firstOrNull ?? id;
      },
      onChanged: (v) => setState(() => _supplierId = v),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final svc = UserProfileService.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const FormSection('Identification'),
          FormTextField('SKU *', _sku),
          FormTextField('Title *', _title),

          const FormSection('Gem Details'),
          FormTextField('Gem Type', _gemType),
          FormTextField('Variety', _variety),
          FormTextField('Shape', _shape),
          FormTextField('Cut Type', _cutType),

          const FormSection('Origin'),
          FormTextField('Country', _originCountry),
          FormTextField('Region', _originRegion),

          const FormSection('Weight & Quantity'),
          FormTextField('Weight *', _weightValue, keyboardType: TextInputType.number),
          FormDropdownField<String>(
            label: 'Unit',
            value: _weightUnit,
            items: const ['ct', 'g', 'kg'],
            onChanged: (v) => setState(() => _weightUnit = v!),
          ),
          FormTextField('Quantity *', _quantity, keyboardType: TextInputType.number),

          const FormSection('Pricing'),
          FormTextField('Cost Price *', _costPrice, keyboardType: TextInputType.number),
          FormTextField('Sale Price *', _salePrice, keyboardType: TextInputType.number),

          const FormSection('Supplier'),
          _buildSupplierPicker(),

          const FormSection('Where is this item?'),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: CascadingLocationPicker(
              sellerId: widget.item.sellerId ?? svc.effectiveSellerId,
              initialLocationId: _originalLocationId,
              onChanged: (id) => _locationId = id,
              enabled: !_saving,
            ),
          ),

          const FormSection('Other'),
          FormTextField('Barcode', _barcode),
          FormDropdownField<String>(
            label: 'Status',
            value: _status,
            items: const ['available', 'reserved', 'sold', 'draft'],
            onChanged: (v) => setState(() => _status = v!),
          ),
          FormTextField('Notes', _notes, maxLines: 4),

          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _saving
                ? const CircularProgressIndicator()
                : const Text('Save Changes'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
