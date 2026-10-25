import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/utils/decimal_input.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/supplier_repository.dart';
import '../../models/inventory_item.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';
import 'widgets/gem_and_variety_fields.dart';
import 'widgets/item_photo_manager.dart';
import 'widgets/item_video_picker.dart';
import 'widgets/maker_picker.dart';
import 'widgets/origin_country_field.dart';
import 'widgets/price_field.dart';
import 'listing_sheet.dart';

class AddInventoryPage extends StatefulWidget {
  final String productType;

  /// Duplicate stone: the form starts as a copy of this item (no photos,
  /// video or certificate number — those belong to one physical stone).
  final InventoryItem? template;

  const AddInventoryPage({super.key, required this.productType, this.template});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final _repository = InventoryRepository();
  final _supplierRepository = SupplierRepository();

  // ── Controllers ───────────────────────────────────────────────────────────

  final _title = TextEditingController();
  final _gemType = TextEditingController();
  final _variety = TextEditingController();
  final _originCountry = TextEditingController();
  final _originRegion = TextEditingController();
  final _weightValue = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _costPrice = TextEditingController();
  final _sellingPrice = TextEditingController();
  final _barcode = TextEditingController();
  final _notes = TextEditingController();

  String _weightUnit = 'ct';
  String _weightGramsUnit = 'g';
  String _totalWeightGramsUnit = 'g';
  String _status = 'available';

  bool _listOnMarketplace = false;

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

  String _shapeSelection = '';
  final _shapeOther = TextEditingController();
  String _cutTypeSelection = '';
  final _cutTypeOther = TextEditingController();

  // ── Shared product-detail controllers ───────────────────────────────────

  final _description = TextEditingController();
  final _certificationLab = TextEditingController();
  final _certificationNumber = TextEditingController();
  final _treatment = TextEditingController();

  // ── Structured dimensions (loose_stone & specimen) ───────────────────────

  final _lengthCtrl = TextEditingController();
  final _widthCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  String _dimensionUnit = 'mm';

  // ── Loose stone specific ─────────────────────────────────────────────────

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

  // ── Video (uploaded after the item exists) ─────────────────────────────────

  VideoChoice _video = const VideoChoice();

  // ── Maker (owner only) ────────────────────────────────────────────────────

  String? _makerId;

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;

  // ── Photo selection ───────────────────────────────────────────────────────

  List<PhotoItem> _photos = [];

  // ── Save state ────────────────────────────────────────────────────────────

  bool _saving = false;
  String _savingStatus = '';

  // ── Shipping (no fields here — carried over so the listing sheet is
  //    already filled in) ────────────────────────────────────────────────────

  String? _courier;
  double? _shippingCost;
  int? _deliveryDaysMin;
  int? _deliveryDaysMax;
  int? _prepDays;

  // ── Automatic title / remembered defaults ─────────────────────────────────

  /// The last title we filled in. While the title still equals it, the user
  /// hasn't typed their own, so we keep updating it.
  String _autoTitle = '';
  String? _prefillNote;
  int _prefillVersion = 0;   // rebuilds the fields that read their value once

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    final t = widget.template;
    if (t != null) {
      _applyTemplate(t);
    } else {
      _loadRememberedDefaults();
    }
    for (final c in [
      _gemType, _variety, _weightValue, _shapeOther, _species, _locality,
      _jewelryType, _metal, _gemstonesUsed, _weightGrams,
    ]) {
      c.addListener(_refreshTitle);
    }
  }

  // ── Automatic title ───────────────────────────────────────────────────────

  /// e.g. "Blue Sapphire 2.15 ct Oval", "Tourmaline specimen, Minas Gerais",
  /// "Silver ring with Ruby".
  String _suggestTitle() {
    String clean(String s) => s.trim() == 'Other' ? '' : s.trim();
    final gemRaw = clean(_gemType.text);
    final gem = gemRaw == 'Diamonds' ? 'Diamond' : gemRaw;
    final variety = clean(_variety.text);
    final name = variety.isEmpty
        ? gem
        : (gem.isEmpty || variety.toLowerCase().contains(gem.toLowerCase()))
            ? variety
            : '$variety $gem';
    String weight(String text, String unit) {
      final v = parseDecimalInput(text);
      if (v == null || v <= 0) return '';
      final s = v.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
      return '$s $unit';
    }

    final List<String> parts;
    switch (widget.productType) {
      case 'specimen':
        final species = _species.text.trim();
        final locality = _locality.text.trim();
        final base = [species.isNotEmpty ? species : name, 'specimen']
            .where((s) => s.isNotEmpty).join(' ');
        parts = [
          locality.isEmpty ? base : '$base, $locality',
          weight(_weightGrams.text, _weightGramsUnit),
        ];
      case 'jewelry':
        final type = _jewelryType.text.trim();
        final metal = _metal.text.trim();
        final stones = _gemstonesUsed.text.trim().isNotEmpty ? _gemstonesUsed.text.trim() : name;
        final piece = [metal, type.isNotEmpty ? type.toLowerCase() : 'jewellery']
            .where((s) => s.isNotEmpty).join(' ');
        parts = [stones.isEmpty ? piece : '$piece with $stones'];
      default:
        final shape = _shapeSelection == 'Other' ? _shapeOther.text.trim() : _shapeSelection;
        parts = [name, weight(_weightValue.text, _weightUnit), shape];
    }
    final title = parts.where((s) => s.isNotEmpty).join(' ');
    if (title.isEmpty || title == 'jewellery') return '';
    return title[0].toUpperCase() + title.substring(1);
  }

  void _refreshTitle() {
    final current = _title.text.trim();
    if (current.isNotEmpty && current != _autoTitle) return;   // typed by hand
    final next = _suggestTitle();
    _autoTitle = next;
    if (_title.text != next) _title.text = next;
  }

  // ── Duplicate / remembered defaults ───────────────────────────────────────

  String _fmt(double? v) =>
      v == null ? '' : v.toStringAsFixed(4).replaceFirst(RegExp(r'\.?0+$'), '');

  void _applyShipping(InventoryItem t) {
    _courier = t.courier;
    _shippingCost = t.shippingCost;
    _deliveryDaysMin = t.deliveryDaysMin;
    _deliveryDaysMax = t.deliveryDaysMax;
    _prepDays = t.prepDays;
  }

  void _applyTemplate(InventoryItem t) {
    _gemType.text = t.gemType;
    _variety.text = t.variety;
    _originCountry.text = t.originCountry;
    _originRegion.text = t.originRegion;
    if (_shapeOptions.contains(t.shape)) {
      _shapeSelection = t.shape;
    } else if (t.shape.isNotEmpty) {
      _shapeSelection = 'Other';
      _shapeOther.text = t.shape;
    }
    if (_cutOptions.contains(t.cutType)) {
      _cutTypeSelection = t.cutType;
    } else if (t.cutType.isNotEmpty) {
      _cutTypeSelection = 'Other';
      _cutTypeOther.text = t.cutType;
    }
    if (t.weightValue > 0) _weightValue.text = _fmt(t.weightValue);
    _weightUnit = t.weightUnit.isEmpty ? 'ct' : t.weightUnit;
    _costPrice.text = t.costPrice > 0 ? _fmt(t.costPrice) : '';
    _sellingPrice.text = t.sellingPrice != null ? _fmt(t.sellingPrice) : '';
    _barcode.text = t.barcode;
    _notes.text = t.notes;
    _description.text = t.description ?? '';
    _certificationLab.text = t.certificationLab ?? '';
    _treatment.text = t.treatment ?? '';
    _lengthCtrl.text = _fmt(t.length);
    _widthCtrl.text = _fmt(t.width);
    _heightCtrl.text = _fmt(t.height);
    _dimensionUnit = t.dimensionUnit.isEmpty ? 'mm' : t.dimensionUnit;
    _clarity.text = t.clarity ?? '';
    _species.text = t.species ?? '';
    _locality.text = t.locality ?? '';
    _matrix.text = t.matrix ?? '';
    _weightGrams.text = _fmt(t.weightGrams);
    _weightGramsUnit = t.weightGramsUnit;
    _jewelryType.text = t.jewelryType ?? '';
    _metal.text = t.metal ?? '';
    _metalPurity.text = t.metalPurity ?? '';
    _sizeOrLength.text = t.sizeOrLength ?? '';
    _gemstonesUsed.text = t.gemstonesUsed ?? '';
    _totalWeightGrams.text = _fmt(t.totalWeightGrams);
    _totalWeightGramsUnit = t.totalWeightGramsUnit;
    _supplierId = t.supplierId;
    _locationId = t.locationId;
    _makerId = t.makerId;
    _applyShipping(t);
    _title.text = t.title;
    // Keep updating the title only if it was the automatic one.
    _autoTitle = _suggestTitle() == t.title ? t.title : '';
    _prefillNote = 'Copy of ${t.sku.isEmpty ? t.title : t.sku}. Change the weight, '
        'price and anything else that differs (check treatment and certificate!), '
        'and add this stone\'s own photos. Photos, video and certificate number '
        'are not copied.';
  }

  /// Fills the "where / how" fields from the seller's last stone of this
  /// type, so a batch of similar stones doesn't need them typed every time.
  Future<void> _loadRememberedDefaults() async {
    try {
      final last = await _repository.getLastItemOfType(
        UserProfileService.instance.effectiveSellerId, widget.productType);
      if (last == null || !mounted) return;
      setState(() {
        if (_originCountry.text.trim().isEmpty) _originCountry.text = last.originCountry;
        if (_originRegion.text.trim().isEmpty) _originRegion.text = last.originRegion;
        // Treatment and certificate are NOT remembered: a wrong one would
        // misdescribe the stone to the buyer.
        _weightUnit = last.weightUnit.isEmpty ? _weightUnit : last.weightUnit;
        _weightGramsUnit = last.weightGramsUnit;
        _totalWeightGramsUnit = last.totalWeightGramsUnit;
        _dimensionUnit = last.dimensionUnit.isEmpty ? _dimensionUnit : last.dimensionUnit;
        _supplierId ??= last.supplierId;
        _locationId ??= last.locationId;
        _applyShipping(last);
        _prefillVersion++;
        _prefillNote = 'Origin, location, supplier and shipping are filled in from your '
            'last ${widget.productType == 'jewelry' ? 'piece' : 'stone'} '
            '(${last.sku}). Change them if this one is different.';
      });
      _refreshTitle();
    } catch (_) {
      // No defaults — the form simply starts empty.
    }
  }

  @override
  void dispose() {
    for (final c in [
      _title, _gemType, _variety, _originCountry, _originRegion,
      _weightValue, _quantity, _costPrice, _sellingPrice,
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
    if (_title.text.trim().isEmpty) return 'Title is required.';
    if (_sellingPrice.text.trim().isNotEmpty &&
        parsePrice(_sellingPrice.text) == null) {
      return 'Price must be a number.';
    }
    if (widget.productType == 'loose_stone' &&
        _weightValue.text.isNotEmpty &&
        parseDecimalInput(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (widget.productType == 'specimen' &&
        _weightGrams.text.isNotEmpty &&
        parseDecimalInput(_weightGrams.text) == null) {
      return 'Weight must be a number.';
    }
    if (widget.productType == 'jewelry' &&
        _totalWeightGrams.text.isNotEmpty &&
        parseDecimalInput(_totalWeightGrams.text) == null) {
      return 'Total weight must be a number.';
    }
    if (_costPrice.text.isNotEmpty &&
        parseDecimalInput(_costPrice.text) == null) {
      return 'Cost price must be a number.';
    }

    if (_quantity.text.isNotEmpty && int.tryParse(_quantity.text) == null) {
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
        // sku intentionally omitted — DB trigger (trg_set_sku) generates it.
        title: _title.text.trim(),
        // Captured for all product types now — specimen/jewelry reuse the
        // same gem-type dropdown as loose_stone so their SKUs get a real
        // gem code instead of falling back to OTHR.
        gemType: _gemType.text.trim(),
        variety: _variety.text.trim(),
        originCountry: (isLooseStone || isSpecimen)
            ? _originCountry.text.trim()
            : '',
        originRegion: isLooseStone ? _originRegion.text.trim() : '',
        shape: isLooseStone
            ? (_shapeSelection == 'Other' ? _shapeOther.text.trim() : _shapeSelection)
            : '',
        cutType: isLooseStone
            ? (_cutTypeSelection == 'Other' ? _cutTypeOther.text.trim() : _cutTypeSelection)
            : '',
        weightValue: isLooseStone ? (parseDecimalInput(_weightValue.text) ?? 0) : 0,
        weightUnit: isLooseStone ? _weightUnit : 'ct',
        quantity: int.tryParse(_quantity.text) ?? 1,
        costPrice: parseDecimalInput(_costPrice.text) ?? 0,
        salePrice: 0,
        barcode: _barcode.text.trim(),
        qrCode: '',
        status: _status,
        notes: _notes.text.trim(),
        imageUrls: const [],
        supplierId: _supplierId,
        supplierName: supplierName,
        // A duplicate stays with the same seller (owner copying a brother's stone).
        sellerId: widget.template?.sellerId,
        locationId: _locationId,
        isListed: false,
        sellingPrice: switch (parsePrice(_sellingPrice.text)) {
          final p? when p > 0 => p,
          _ => null,
        },
        listedAt: null,
        productType: widget.productType,
        certificationLab: _orNull(_certificationLab),
        certificationNumber: _orNull(_certificationNumber),
        treatment: _orNull(_treatment),
        dimensionsMm: null,
        length: parseDecimalInput(_lengthCtrl.text),
        width: parseDecimalInput(_widthCtrl.text),
        height: parseDecimalInput(_heightCtrl.text),
        dimensionUnit: _dimensionUnit,
        description: _orNull(_description),
        cut: null,
        clarity: isLooseStone ? _orNull(_clarity) : null,
        species: isSpecimen ? _orNull(_species) : null,
        locality: isSpecimen ? _orNull(_locality) : null,
        matrix: isSpecimen ? _orNull(_matrix) : null,
        weightGrams: isSpecimen ? parseDecimalInput(_weightGrams.text) : null,
        weightGramsUnit: _weightGramsUnit,
        jewelryType: isJewelry ? _orNull(_jewelryType) : null,
        metal: isJewelry ? _orNull(_metal) : null,
        metalPurity: isJewelry ? _orNull(_metalPurity) : null,
        sizeOrLength: isJewelry ? _orNull(_sizeOrLength) : null,
        gemstonesUsed: isJewelry ? _orNull(_gemstonesUsed) : null,
        totalWeightGrams:
            isJewelry ? parseDecimalInput(_totalWeightGrams.text) : null,
        totalWeightGramsUnit: _totalWeightGramsUnit,
        courier: _courier,
        shippingCost: _shippingCost,
        deliveryDaysMin: _deliveryDaysMin,
        deliveryDaysMax: _deliveryDaysMax,
        prepDays: _prepDays,
      );

      final created = await _repository.addItem(item);

      if (_makerId != null &&
          created.id != null &&
          UserProfileService.instance.isOwner) {
        await _repository.setItemMaker(created.id!, _makerId);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved — SKU: ${created.sku}'),
            duration: const Duration(seconds: 4),
          ),
        );
      }

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

      var listed = created;
      if (_video.pending != null && created.id != null) {
        if (mounted) setState(() => _savingStatus = 'Uploading video…');
        final videoUrl = await _repository.uploadVideo(
          created.id!,
          _video.pendingBytes!,
          _video.pending!.name,
        );
        await _repository.updateItemVideo(created.id!, videoUrl);
        listed = created.copyWith(videoUrl: videoUrl);
      }

      if (!mounted) return;
      if (_listOnMarketplace && listed.id != null) {
        await showListingSheet(context, listed);
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
      // A remembered supplier that no longer exists shows as "No supplier".
      value: _suppliers.any((s) => s.id == _supplierId) ? _supplierId : null,
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
          GemAndVarietyFields(
            gemTypeController: _gemType,
            varietyController: _variety,
          ),
          FormTextField('Species', _species),
          FormTextField('Locality', _locality),
          FormTextField('Matrix (host rock the specimen is embedded in)', _matrix),
          FormTextField(
            'Weight',
            _weightGrams,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _weightGramsUnit,
            items: const ['ct', 'g', 'kg'],
            itemLabel: (v) => v == 'ct' ? 'ct (carat)' : v == 'g' ? 'g (grams)' : 'kg',
            onChanged: (v) { setState(() => _weightGramsUnit = v!); _refreshTitle(); },
          ),
          OriginCountryField(key: ValueKey('origin$_prefillVersion'), controller: _originCountry, label: 'Origin Country'),
          const FormSection('Dimensions'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: FormTextField('Length', _lengthCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Width', _widthCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Height', _heightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
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
          GemAndVarietyFields(
            gemTypeController: _gemType,
            varietyController: _variety,
          ),
          FormTextField('Jewelry Type', _jewelryType),
          FormTextField('Metal', _metal),
          FormTextField('Metal Purity', _metalPurity),
          FormTextField('Size / Length', _sizeOrLength),
          FormTextField('Gemstones Used', _gemstonesUsed),
          FormTextField(
            'Total Weight',
            _totalWeightGrams,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onChanged: (v) { setState(() => _shapeSelection = v ?? ''); _refreshTitle(); },
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
          OriginCountryField(key: ValueKey('origin$_prefillVersion'), controller: _originCountry),
          FormTextField('Region', _originRegion),
          const FormSection('Weight'),
          FormTextField(
            'Weight',
            _weightValue,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          FormDropdownField<String>(
            label: 'Unit',
            value: _weightUnit,
            items: const ['ct', 'g', 'kg'],
            itemLabel: (v) => v == 'ct' ? 'ct (carat)' : v == 'g' ? 'g (grams)' : 'kg',
            onChanged: (v) { setState(() => _weightUnit = v!); _refreshTitle(); },
          ),
          const FormSection('Dimensions'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: FormTextField('Length', _lengthCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Width', _widthCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
              const SizedBox(width: 8),
              Expanded(child: FormTextField('Height', _heightCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true))),
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
              if (_prefillNote != null)
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_fix_high, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(_prefillNote!)),
                      ],
                    ),
                  ),
                ),
              _buildPhotoSelector(),

              const FormSection('Video'),
              ItemVideoPicker(
                value: _video,
                onChanged: (v) => setState(() => _video = v),
                enabled: !_saving,
              ),

              const FormSection('Identification'),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  'SKU will be generated automatically',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              FormTextField('Title *', _title),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  'Fills in by itself from the gem, weight and shape below — '
                  'type your own title to change it.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),

              const FormSection('Price'),
              PriceField(
                controller: _sellingPrice,
                sellerId: svc.effectiveSellerId,
              ),

              ..._buildTypeSpecificFields(),

              const FormSection('Description & Certification'),
              FormTextField('Description', _description, maxLines: 3),
              FormTextField('Certification Lab', _certificationLab),
              FormTextField('Certification Number', _certificationNumber),
              FormTextField('Treatment', _treatment),

              const FormSection('Private — only you see this'),
              FormTextField(
                'Cost Price',
                _costPrice,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),


              if (UserProfileService.instance.isOwner) ...[
                const FormSection('Maker credit'),
                MakerPicker(
                  productType: widget.productType,
                  value: _makerId,
                  onChanged: (v) => setState(() => _makerId = v),
                  enabled: !_saving,
                ),
              ],

              const FormSection('Supplier'),
              _buildSupplierPicker(),

              const FormSection('Where is this item?'),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: CascadingLocationPicker(
                  key: ValueKey('location$_prefillVersion'),
                  sellerId: svc.effectiveSellerId,
                  initialLocationId: _locationId,
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

              const FormSection('Other'),
              FormTextField(
                'Quantity',
                _quantity,
                keyboardType: TextInputType.number,
              ),
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
