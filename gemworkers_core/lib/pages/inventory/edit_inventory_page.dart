import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/supplier_repository.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';
import 'widgets/gem_and_variety_fields.dart';
import 'widgets/item_photo_manager.dart';
import 'widgets/origin_country_field.dart';

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
  late final TextEditingController _weightValue;
  late final TextEditingController _quantity;
  late final TextEditingController _costPrice;
  late final TextEditingController _salePrice;
  late final TextEditingController _barcode;
  late final TextEditingController _notes;

  late String _weightUnit;
  late String _weightGramsUnit;
  late String _totalWeightGramsUnit;
  late String _status;
  late final String _productType;

  // ── Shape & Cut dropdowns ─────────────────────────────────────────────────

  static const _shapeOptions = <String>[
    '', 'Round', 'Oval', 'Pear', 'Cushion', 'Emerald', 'Marquise', 'Heart',
    'Trillion', 'Princess', 'Octagon', 'Baguette', 'Cabochon', 'Rough / Uncut',
    'Bead', 'Other',
  ];
  static const _cutOptions = <String>[
    '', 'Brilliant', 'Step', 'Mixed', 'Faceted', 'Cabochon', 'Rose cut',
    'Rough / Uncut', 'Carved', 'Other',
  ];

  late String _shapeSelection;
  late final TextEditingController _shapeOther;
  late String _cutTypeSelection;
  late final TextEditingController _cutTypeOther;

  // ── Shared product-detail controllers ───────────────────────────────────

  late final TextEditingController _description;
  late final TextEditingController _certificationLab;
  late final TextEditingController _certificationNumber;
  late final TextEditingController _treatment;

  // ── Structured dimensions (loose_stone & specimen) ───────────────────────

  late final TextEditingController _lengthCtrl;
  late final TextEditingController _widthCtrl;
  late final TextEditingController _heightCtrl;
  late String _dimensionUnit;

  // ── Loose stone specific ─────────────────────────────────────────────────

  late final TextEditingController _clarity;

  // ── Specimen specific ────────────────────────────────────────────────────

  late final TextEditingController _species;
  late final TextEditingController _locality;
  late final TextEditingController _matrix;
  late final TextEditingController _weightGrams;

  // ── Jewelry specific ─────────────────────────────────────────────────────

  late final TextEditingController _jewelryType;
  late final TextEditingController _metal;
  late final TextEditingController _metalPurity;
  late final TextEditingController _sizeOrLength;
  late final TextEditingController _gemstonesUsed;
  late final TextEditingController _totalWeightGrams;

  // ── Supplier ──────────────────────────────────────────────────────────────

  List<Supplier> _suppliers = [];
  bool _loadingSuppliers = false;
  String? _supplierId;

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;
  String? _originalLocationId;

  // ── Photo selection ───────────────────────────────────────────────────────

  List<PhotoItem> _photos = [];

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
    _weightValue = TextEditingController(text: i.weightValue.toString());
    _quantity = TextEditingController(text: i.quantity.toString());
    _costPrice = TextEditingController(text: i.costPrice.toString());
    _salePrice = TextEditingController(text: i.salePrice.toString());
    _barcode = TextEditingController(text: i.barcode);
    _notes = TextEditingController(text: i.notes);
    _weightUnit = i.weightUnit;
    _weightGramsUnit = i.weightGramsUnit;
    _totalWeightGramsUnit = i.totalWeightGramsUnit;
    _status = i.status;
    _productType = i.productType;
    final shapeInList = _shapeOptions.contains(i.shape);
    _shapeSelection = shapeInList ? i.shape : 'Other';
    _shapeOther = TextEditingController(text: shapeInList ? '' : i.shape);
    final cutInList = _cutOptions.contains(i.cutType);
    _cutTypeSelection = cutInList ? i.cutType : 'Other';
    _cutTypeOther = TextEditingController(text: cutInList ? '' : i.cutType);
    _description = TextEditingController(text: i.description ?? '');
    _certificationLab = TextEditingController(text: i.certificationLab ?? '');
    _certificationNumber =
        TextEditingController(text: i.certificationNumber ?? '');
    _treatment = TextEditingController(text: i.treatment ?? '');
    _lengthCtrl = TextEditingController(text: i.length?.toString() ?? '');
    _widthCtrl = TextEditingController(text: i.width?.toString() ?? '');
    _heightCtrl = TextEditingController(text: i.height?.toString() ?? '');
    _dimensionUnit = i.dimensionUnit;
    _clarity = TextEditingController(text: i.clarity ?? '');
    _species = TextEditingController(text: i.species ?? '');
    _locality = TextEditingController(text: i.locality ?? '');
    _matrix = TextEditingController(text: i.matrix ?? '');
    _weightGrams =
        TextEditingController(text: i.weightGrams?.toString() ?? '');
    _jewelryType = TextEditingController(text: i.jewelryType ?? '');
    _metal = TextEditingController(text: i.metal ?? '');
    _metalPurity = TextEditingController(text: i.metalPurity ?? '');
    _sizeOrLength = TextEditingController(text: i.sizeOrLength ?? '');
    _gemstonesUsed = TextEditingController(text: i.gemstonesUsed ?? '');
    _totalWeightGrams =
        TextEditingController(text: i.totalWeightGrams?.toString() ?? '');
    _supplierId = i.supplierId;
    _locationId = i.locationId;
    _originalLocationId = i.locationId;
    _photos = i.imageUrls.map(PhotoItem.existing).toList();
    _loadSuppliers();
  }

  @override
  void dispose() {
    for (final c in [
      _sku, _title, _gemType, _variety, _originCountry, _originRegion,
      _weightValue, _quantity, _costPrice, _salePrice,
      _barcode, _notes,
      _shapeOther, _cutTypeOther,
      _description, _certificationLab, _certificationNumber, _treatment,
      _lengthCtrl, _widthCtrl, _heightCtrl, _clarity, _species, _locality, _matrix,
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
    if (_productType == 'loose_stone' &&
        double.tryParse(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (_productType == 'specimen' &&
        _weightGrams.text.isNotEmpty &&
        double.tryParse(_weightGrams.text) == null) {
      return 'Weight must be a number.';
    }
    if (_productType == 'jewelry' &&
        _totalWeightGrams.text.isNotEmpty &&
        double.tryParse(_totalWeightGrams.text) == null) {
      return 'Total weight must be a number.';
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

    setState(() => _saving = true);

    try {
      final finalImageUrls = <String>[];
      for (final photo in _photos) {
        if (photo.isExisting) {
          finalImageUrls.add(photo.url!);
        } else {
          final url = await _repository.uploadImage(
            widget.item.id!,
            photo.bytes!,
            photo.file!.name,
          );
          finalImageUrls.add(url);
        }
      }

      final supplierName = _supplierId != null
          ? _suppliers
              .where((s) => s.id == _supplierId)
              .map((s) => s.name)
              .firstOrNull ?? widget.item.supplierName
          : '';

      final isLooseStone = _productType == 'loose_stone';
      final isSpecimen = _productType == 'specimen';
      final isJewelry = _productType == 'jewelry';

      final updated = InventoryItem(
        id: widget.item.id,
        sku: _sku.text.trim(),
        title: _title.text.trim(),
        gemType: isLooseStone ? _gemType.text.trim() : widget.item.gemType,
        variety: isLooseStone ? _variety.text.trim() : widget.item.variety,
        originCountry: (isLooseStone || isSpecimen)
            ? _originCountry.text.trim()
            : widget.item.originCountry,
        originRegion:
            isLooseStone ? _originRegion.text.trim() : widget.item.originRegion,
        shape: isLooseStone
            ? (_shapeSelection == 'Other' ? _shapeOther.text.trim() : _shapeSelection)
            : widget.item.shape,
        cutType: isLooseStone
            ? (_cutTypeSelection == 'Other' ? _cutTypeOther.text.trim() : _cutTypeSelection)
            : widget.item.cutType,
        weightValue:
            isLooseStone ? double.parse(_weightValue.text) : widget.item.weightValue,
        weightUnit: isLooseStone ? _weightUnit : widget.item.weightUnit,
        quantity: int.parse(_quantity.text),
        costPrice: double.parse(_costPrice.text),
        salePrice: double.parse(_salePrice.text),
        barcode: _barcode.text.trim(),
        qrCode: widget.item.qrCode,
        status: _status,
        notes: _notes.text.trim(),
        imageUrls: finalImageUrls,
        supplierId: _supplierId,
        supplierName: supplierName,
        locationId: _locationId,
        isListed: widget.item.isListed,
        sellingPrice: widget.item.sellingPrice,
        listedAt: widget.item.listedAt,
        createdAt: widget.item.createdAt,
        productType: _productType,
        certificationLab: _orNull(_certificationLab),
        certificationNumber: _orNull(_certificationNumber),
        treatment: _orNull(_treatment),
        dimensionsMm: null,
        length: double.tryParse(_lengthCtrl.text),
        width: double.tryParse(_widthCtrl.text),
        height: double.tryParse(_heightCtrl.text),
        dimensionUnit: _dimensionUnit,
        description: _orNull(_description),
        videoUrl: widget.item.videoUrl,
        cut: null,
        clarity: isLooseStone ? _orNull(_clarity) : widget.item.clarity,
        species: isSpecimen ? _orNull(_species) : widget.item.species,
        locality: isSpecimen ? _orNull(_locality) : widget.item.locality,
        matrix: isSpecimen ? _orNull(_matrix) : widget.item.matrix,
        weightGrams: isSpecimen
            ? double.tryParse(_weightGrams.text)
            : widget.item.weightGrams,
        weightGramsUnit: isSpecimen ? _weightGramsUnit : widget.item.weightGramsUnit,
        jewelryType:
            isJewelry ? _orNull(_jewelryType) : widget.item.jewelryType,
        metal: isJewelry ? _orNull(_metal) : widget.item.metal,
        metalPurity:
            isJewelry ? _orNull(_metalPurity) : widget.item.metalPurity,
        sizeOrLength:
            isJewelry ? _orNull(_sizeOrLength) : widget.item.sizeOrLength,
        gemstonesUsed:
            isJewelry ? _orNull(_gemstonesUsed) : widget.item.gemstonesUsed,
        totalWeightGrams: isJewelry
            ? double.tryParse(_totalWeightGrams.text)
            : widget.item.totalWeightGrams,
        totalWeightGramsUnit: isJewelry ? _totalWeightGramsUnit : widget.item.totalWeightGramsUnit,
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
    switch (_productType) {
      case 'specimen':
        return [
          const FormSection('Specimen Details'),
          FormTextField('Species', _species),
          FormTextField('Locality', _locality),
          FormTextField('Matrix', _matrix),
          FormTextField(
            'Weight',
            _weightGrams,
            keyboardType: TextInputType.number,
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _weightGramsUnit,
            items: const ['ct', 'g', 'kg'],
            itemLabel: (v) => v == 'ct' ? 'ct (carat)' : v == 'g' ? 'g (grams)' : 'kg',
            onChanged: (v) => setState(() => _weightGramsUnit = v!),
          ),
          OriginCountryField(controller: _originCountry, label: 'Origin Country'),
          const FormSection('Dimensions'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: FormTextField('Length', _lengthCtrl, keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Width', _widthCtrl, keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Height', _heightCtrl, keyboardType: TextInputType.number)),
            ],
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _dimensionUnit,
            items: const ['mm', 'cm'],
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _dimensionUnit = v!),
          ),
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
            'Total Weight',
            _totalWeightGrams,
            keyboardType: TextInputType.number,
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _totalWeightGramsUnit,
            items: const ['ct', 'g', 'kg'],
            itemLabel: (v) => v == 'ct' ? 'ct (carat)' : v == 'g' ? 'g (grams)' : 'kg',
            onChanged: (v) => setState(() => _totalWeightGramsUnit = v!),
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
          FormDropdownField<String>(
            label: 'Shape',
            value: _shapeSelection,
            items: _shapeOptions,
            itemLabel: (v) => v.isEmpty ? '—' : v,
            onChanged: (v) => setState(() => _shapeSelection = v ?? ''),
          ),
          if (_shapeSelection == 'Other')
            FormTextField('Shape (custom)', _shapeOther),
          FormDropdownField<String>(
            label: 'Cut',
            value: _cutTypeSelection,
            items: _cutOptions,
            itemLabel: (v) => v.isEmpty ? '—' : v,
            onChanged: (v) => setState(() => _cutTypeSelection = v ?? ''),
          ),
          if (_cutTypeSelection == 'Other')
            FormTextField('Cut (custom)', _cutTypeOther),
          FormTextField('Clarity', _clarity),
          const FormSection('Origin'),
          OriginCountryField(controller: _originCountry),
          FormTextField('Region', _originRegion),
          const FormSection('Weight'),
          FormTextField('Weight *', _weightValue, keyboardType: TextInputType.number),
          FormDropdownField<String>(
            label: 'Unit',
            value: _weightUnit,
            items: const ['ct', 'g', 'kg'],
            itemLabel: (v) => v == 'ct' ? 'ct (carat)' : v == 'g' ? 'g (grams)' : 'kg',
            onChanged: (v) => setState(() => _weightUnit = v!),
          ),
          const FormSection('Dimensions'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: FormTextField('Length', _lengthCtrl, keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Width', _widthCtrl, keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Height', _heightCtrl, keyboardType: TextInputType.number)),
            ],
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _dimensionUnit,
            items: const ['mm', 'cm'],
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _dimensionUnit = v!),
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
          FormTextField('Quantity *', _quantity, keyboardType: TextInputType.number),
          FormTextField('Barcode / product code (optional — for repeatable items)', _barcode),
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
