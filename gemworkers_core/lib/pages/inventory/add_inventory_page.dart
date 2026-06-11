import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../../models/inventory_item.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _repository = InventoryRepository();
  final _supplierRepository = SupplierRepository();
  final _picker = ImagePicker();

  // ── Controllers ───────────────────────────────────────────────────────────

  final _sku = TextEditingController();
  final _title = TextEditingController();
  final _gemType = TextEditingController();
  final _variety = TextEditingController();
  final _originCountry = TextEditingController();
  final _originRegion = TextEditingController();
  final _shape = TextEditingController();
  final _cutType = TextEditingController();
  final _weightValue = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _costPrice = TextEditingController();
  final _salePrice = TextEditingController();
  final _barcode = TextEditingController();
  final _notes = TextEditingController();

  String _weightUnit = 'ct';
  String _status = 'available';

  bool _listOnMarketplace = false;
  final _sellingPrice = TextEditingController();

  // ── Supplier ──────────────────────────────────────────────────────────────

  List<Supplier> _suppliers = [];
  bool _loadingSuppliers = false;
  String? _supplierId;

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;

  // ── Photo selection ───────────────────────────────────────────────────────

  final List<XFile> _photos = [];
  final List<Uint8List> _photoBytes = [];

  // ── Save state ────────────────────────────────────────────────────────────

  bool _saving = false;
  String _savingStatus = '';

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  @override
  void dispose() {
    for (final c in [
      _sku, _title, _gemType, _variety, _originCountry, _originRegion,
      _shape, _cutType, _weightValue, _quantity, _costPrice, _salePrice,
      _barcode, _notes, _sellingPrice,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Suppliers ─────────────────────────────────────────────────────────────

  Future<void> _loadSuppliers() async {
    setState(() => _loadingSuppliers = true);
    try {
      final svc = UserProfileService.instance;
      final suppliers = await _supplierRepository.getSuppliers(
        sellerId: svc.shouldFilterBySeller ? svc.sellerId : null,
      );
      if (mounted) setState(() { _suppliers = suppliers; _loadingSuppliers = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingSuppliers = false);
    }
  }

  // ── Photos ────────────────────────────────────────────────────────────────

  Future<void> _pickPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;

    final bytes = await Future.wait(picked.map((f) => f.readAsBytes()));
    setState(() {
      _photos.addAll(picked);
      _photoBytes.addAll(bytes);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
      _photoBytes.removeAt(index);
    });
  }

  // ── Validation & save ─────────────────────────────────────────────────────

  String? _validate() {
    if (_sku.text.trim().isEmpty) return 'SKU is required.';
    if (_title.text.trim().isEmpty) return 'Title is required.';
    if (_weightValue.text.isNotEmpty &&
        double.tryParse(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (_costPrice.text.isNotEmpty &&
        double.tryParse(_costPrice.text) == null) {
      return 'Cost price must be a number.';
    }
    if (_salePrice.text.isNotEmpty &&
        double.tryParse(_salePrice.text) == null) {
      return 'Sale price must be a number.';
    }
    if (_quantity.text.isNotEmpty && int.tryParse(_quantity.text) == null) {
      return 'Quantity must be a whole number.';
    }
    if (_listOnMarketplace) {
      final sp = double.tryParse(_sellingPrice.text);
      if (sp == null || sp <= 0) return 'Enter a selling price to list on marketplace.';
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

    setState(() {
      _saving = true;
      _savingStatus = 'Saving item…';
    });

    try {
      final supplierName = _supplierId != null
          ? _suppliers
              .where((s) => s.id == _supplierId)
              .map((s) => s.name)
              .firstOrNull ?? ''
          : '';

      final item = InventoryItem(
        sku: _sku.text.trim(),
        title: _title.text.trim(),
        gemType: _gemType.text.trim(),
        variety: _variety.text.trim(),
        originCountry: _originCountry.text.trim(),
        originRegion: _originRegion.text.trim(),
        shape: _shape.text.trim(),
        cutType: _cutType.text.trim(),
        weightValue: double.tryParse(_weightValue.text) ?? 0,
        weightUnit: _weightUnit,
        quantity: int.tryParse(_quantity.text) ?? 1,
        costPrice: double.tryParse(_costPrice.text) ?? 0,
        salePrice: double.tryParse(_salePrice.text) ?? 0,
        barcode: _barcode.text.trim(),
        qrCode: '',
        status: _status,
        notes: _notes.text.trim(),
        imageUrls: const [],
        supplierId: _supplierId,
        supplierName: supplierName,
        locationId: _locationId,
        isListed: _listOnMarketplace,
        sellingPrice: _listOnMarketplace
            ? double.tryParse(_sellingPrice.text)
            : null,
        listedAt: _listOnMarketplace ? DateTime.now() : null,
      );

      final created = await _repository.addItem(item);

      if (_photos.isNotEmpty && created.id != null) {
        final urls = <String>[];
        for (int i = 0; i < _photos.length; i++) {
          if (mounted) {
            setState(() =>
                _savingStatus = 'Uploading photo ${i + 1} of ${_photos.length}…');
          }
          final url = await _repository.uploadImage(
            created.id!,
            _photoBytes[i],
            _photos[i].name,
          );
          urls.add(url);
        }
        await _repository.updateItemImages(created.id!, urls);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Photo selector widget ─────────────────────────────────────────────────

  Widget _buildPhotoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _saving ? null : _pickPhotos,
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Add Photos'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        if (_photos.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Optional — photos can also be added after saving.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _photos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) => Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      _photoBytes[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
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
        title: const Text('Add Inventory Item'),
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildPhotoSelector(),

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
              FormTextField(
                'Weight',
                _weightValue,
                keyboardType: TextInputType.number,
              ),
              FormDropdownField<String>(
                label: 'Unit',
                value: _weightUnit,
                items: const ['ct', 'g', 'kg'],
                onChanged: (v) => setState(() => _weightUnit = v!),
              ),
              FormTextField(
                'Quantity',
                _quantity,
                keyboardType: TextInputType.number,
              ),

              const FormSection('Pricing'),
              FormTextField(
                'Cost Price',
                _costPrice,
                keyboardType: TextInputType.number,
              ),
              FormTextField(
                'Sale Price',
                _salePrice,
                keyboardType: TextInputType.number,
              ),

              const FormSection('Supplier'),
              _buildSupplierPicker(),

              const FormSection('Where is this item?'),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CascadingLocationPicker(
                  sellerId: svc.effectiveSellerId,
                  onChanged: (id) => _locationId = id,
                  enabled: !_saving,
                ),
              ),

              const FormSection('Marketplace'),
              SwitchListTile(
                title: const Text('List on marketplace now?'),
                subtitle: const Text('Makes this item visible to buyers'),
                value: _listOnMarketplace,
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _listOnMarketplace = v),
                contentPadding: EdgeInsets.zero,
              ),
              if (_listOnMarketplace)
                FormTextField(
                  'Selling Price *',
                  _sellingPrice,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                child: const Text('Save Item'),
              ),
              const SizedBox(height: 24),
            ],
          ),

          if (_saving)
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(_savingStatus),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
