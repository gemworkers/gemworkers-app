import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../../models/inventory_item.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';
import 'widgets/gem_and_variety_fields.dart';
import 'widgets/item_photo_manager.dart';
import 'widgets/origin_country_field.dart';

class AddInventoryPage extends StatefulWidget {
  final String productType;

  const AddInventoryPage({super.key, required this.productType});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _repository = InventoryRepository();
  final _supplierRepository = SupplierRepository();

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
  final _barcode = TextEditingController();
  final _notes = TextEditingController();

  String _weightUnit = 'ct';
  String _status = 'available';

  bool _listOnMarketplace = false;
  final _sellingPrice = TextEditingController();

  // ── Shared product-detail controllers ───────────────────────────────────

  final _description = TextEditingController();
  final _certificationLab = TextEditingController();
  final _certificationNumber = TextEditingController();
  final _treatment = TextEditingController();
  final _dimensionsMm = TextEditingController();

  // ── Loose stone specific ─────────────────────────────────────────────────

  final _cut = TextEditingController();
  final _clarity = TextEditingController();

  // ── Specimen specific ────────────────────────────────────────────────────

  final _species = TextEditingController();
  final _locality = TextEditingController();
  final _matrix = TextEditingController();
  final _weightGrams = TextEditingController();

  // ── Jewelry specific ─────────────────────────────────────────────────────

  final _jewelryType = TextEditingController();
  final _metal = TextEditingController();
  final _metalPurity = TextEditingController();
  final _sizeOrLength = TextEditingController();
  final _gemstonesUsed = TextEditingController();
  final _totalWeightGrams = TextEditingController();

  // ── Supplier ──────────────────────────────────────────────────────────────

  List<Supplier> _suppliers = [];
  bool _loadingSuppliers = false;
  String? _supplierId;

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;

  // ── Photo selection ───────────────────────────────────────────────────────

  List<PhotoItem> _photos = [];

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
      _shape, _cutType, _weightValue, _quantity, _costPrice,
      _barcode, _notes, _sellingPrice,
      _description, _certificationLab, _certificationNumber, _treatment,
      _dimensionsMm, _cut, _clarity, _species, _locality, _matrix,
      _weightGrams, _jewelryType, _metal, _metalPurity, _sizeOrLength,
      _gemstonesUsed, _totalWeightGrams,
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

  // ── Validation & save ─────────────────────────────────────────────────────

  String? _validate() {
    if (_sku.text.trim().isEmpty) return 'SKU is required.';
    if (_title.text.trim().isEmpty) return 'Title is required.';
    if (widget.productType == 'loose_stone' &&
        _weightValue.text.isNotEmpty &&
        double.tryParse(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (widget.productType == 'specimen' &&
        _weightGrams.text.isNotEmpty &&
        double.tryParse(_weightGrams.text) == null) {
      return 'Weight (grams) must be a number.';
    }
    if (widget.productType == 'jewelry' &&
        _totalWeightGrams.text.isNotEmpty &&
        double.tryParse(_totalWeightGrams.text) == null) {
      return 'Total weight (grams) must be a number.';
    }
    if (_costPrice.text.isNotEmpty &&
        double.tryParse(_costPrice.text) == null) {
      return 'Cost price must be a number.';
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

  String? _orNull(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
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

      final isLooseStone = widget.productType == 'loose_stone';
      final isSpecimen = widget.productType == 'specimen';
      final isJewelry = widget.productType == 'jewelry';

      final item = InventoryItem(
        sku: _sku.text.trim(),
        title: _title.text.trim(),
        gemType: isLooseStone ? _gemType.text.trim() : '',
        variety: isLooseStone ? _variety.text.trim() : '',
        originCountry: (isLooseStone || isSpecimen)
            ? _originCountry.text.trim()
            : '',
        originRegion: isLooseStone ? _originRegion.text.trim() : '',
        shape: isLooseStone ? _shape.text.trim() : '',
        cutType: isLooseStone ? _cutType.text.trim() : '',
        weightValue: isLooseStone ? (double.tryParse(_weightValue.text) ?? 0) : 0,
        weightUnit: isLooseStone ? _weightUnit : 'ct',
        quantity: int.tryParse(_quantity.text) ?? 1,
        costPrice: double.tryParse(_costPrice.text) ?? 0,
        salePrice: 0,
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
        productType: widget.productType,
        certificationLab: _orNull(_certificationLab),
        certificationNumber: _orNull(_certificationNumber),
        treatment: _orNull(_treatment),
        dimensionsMm: _orNull(_dimensionsMm),
        description: _orNull(_description),
        cut: isLooseStone ? _orNull(_cut) : null,
        clarity: isLooseStone ? _orNull(_clarity) : null,
        species: isSpecimen ? _orNull(_species) : null,
        locality: isSpecimen ? _orNull(_locality) : null,
        matrix: isSpecimen ? _orNull(_matrix) : null,
        weightGrams: isSpecimen ? double.tryParse(_weightGrams.text) : null,
        jewelryType: isJewelry ? _orNull(_jewelryType) : null,
        metal: isJewelry ? _orNull(_metal) : null,
        metalPurity: isJewelry ? _orNull(_metalPurity) : null,
        sizeOrLength: isJewelry ? _orNull(_sizeOrLength) : null,
        gemstonesUsed: isJewelry ? _orNull(_gemstonesUsed) : null,
        totalWeightGrams:
            isJewelry ? double.tryParse(_totalWeightGrams.text) : null,
      );

      final created = await _repository.addItem(item);

      if (_photos.isNotEmpty && created.id != null) {
        final urls = <String>[];
        int uploadNum = 0;
        for (final photo in _photos) {
          if (photo.isExisting) {
            urls.add(photo.url!);
          } else {
            uploadNum++;
            if (mounted) {
              setState(() =>
                  _savingStatus = 'Uploading photo $uploadNum…');
            }
            final url = await _repository.uploadImage(
              created.id!,
              photo.bytes!,
              photo.file!.name,
            );
            urls.add(url);
          }
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
    return ItemPhotoManager(
      photos: _photos,
      onChanged: (updated) => setState(() => _photos = updated),
      enabled: !_saving,
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

  // ── Type-specific fields ──────────────────────────────────────────────────

  List<Widget> _buildTypeSpecificFields() {
    switch (widget.productType) {
      case 'specimen':
        return [
          const FormSection('Specimen Details'),
          FormTextField('Species', _species),
          FormTextField('Locality', _locality),
          FormTextField('Matrix', _matrix),
          FormTextField(
            'Weight (grams)',
            _weightGrams,
            keyboardType: TextInputType.number,
          ),
          OriginCountryField(controller: _originCountry, label: 'Origin Country'),
        ];
      case 'jewelry':
        return [
          const FormSection('Jewelry Details'),
          FormTextField('Jewelry Type', _jewelryType),
          FormTextField('Metal', _metal),
          FormTextField('Metal Purity', _metalPurity),
          FormTextField('Size / Length', _sizeOrLength),
          FormTextField('Gemstones Used', _gemstonesUsed),
          FormTextField(
            'Total Weight (grams)',
            _totalWeightGrams,
            keyboardType: TextInputType.number,
          ),
        ];
      case 'loose_stone':
      default:
        return [
          const FormSection('Gem Details'),
          GemAndVarietyFields(
            gemTypeController: _gemType,
            varietyController: _variety,
          ),
          FormTextField('Shape', _shape),
          FormTextField('Cut Type', _cutType),
          FormTextField('Cut (finish)', _cut),
          FormTextField('Clarity', _clarity),
          const FormSection('Origin'),
          OriginCountryField(controller: _originCountry),
          FormTextField('Region', _originRegion),
          const FormSection('Weight'),
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
        ];
    }
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

              ..._buildTypeSpecificFields(),

              const FormSection('Description & Certification'),
              FormTextField('Description', _description, maxLines: 3),
              FormTextField('Certification Lab', _certificationLab),
              FormTextField('Certification Number', _certificationNumber),
              FormTextField('Treatment', _treatment),
              FormTextField('Dimensions (mm)', _dimensionsMm),

              const FormSection('Pricing'),
              FormTextField(
                'Cost Price',
                _costPrice,
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
              FormTextField(
                'Quantity',
                _quantity,
                keyboardType: TextInputType.number,
              ),
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
