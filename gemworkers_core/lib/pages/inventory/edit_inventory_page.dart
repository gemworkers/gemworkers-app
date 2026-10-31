import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/utils/decimal_input.dart';
import '../../models/inventory_item.dart';
import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/supplier_repository.dart';
import 'widgets/inventory_form_widgets.dart';
import 'widgets/cascading_location_picker.dart';
import 'widgets/gem_and_variety_fields.dart';
import 'widgets/item_photo_manager.dart';
import 'widgets/item_video_picker.dart';
import 'widgets/maker_picker.dart';
import '../../models/consignor.dart';
import '../../repositories/consignor_repository.dart';
import '../../core/services/seller_service.dart';
import 'widgets/origin_country_field.dart';
import 'widgets/price_field.dart';
import 'widgets/protected_materials_section.dart';
import '../../core/utils/protected_materials.dart';

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

  late final TextEditingController _title;
  late final TextEditingController _gemType;
  late final TextEditingController _variety;
  late final TextEditingController _originCountry;
  late final TextEditingController _originRegion;
  late final TextEditingController _weightValue;
  late final TextEditingController _quantity;
  late final TextEditingController _costPrice;
  late final TextEditingController _sellingPrice;
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
  // Protected materials answers (sql/protected_materials.sql).
  String? _cites;
  String? _diamond;
  late final TextEditingController _permitNo;
  late final TextEditingController _kimberleyNo;
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

  // Maker credit — owner only; saved separately via setItemMaker.
  String? _makerId;

  // Who owns this stone (consignment) — owner only, My Shop stones only;
  // saved separately via ConsignorRepository.setItemConsignment.
  final _consignorRepo = ConsignorRepository();
  List<Consignor> _owners = [];
  String? _consignorId;
  late final TextEditingController _consignorPrice;
  late final TextEditingController _profitShare;

  bool get _canSetOwner =>
      UserProfileService.instance.isOwner &&
      (widget.item.sellerId == null || widget.item.sellerId == kCurrentSellerId);

  // ── Location ──────────────────────────────────────────────────────────────

  String? _locationId;
  String? _originalLocationId;

  // ── Photo selection ───────────────────────────────────────────────────────

  List<PhotoItem> _photos = [];
  late VideoChoice _video;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _cites = i.citesDeclaration;
    _diamond = i.diamondDeclaration;
    _permitNo = TextEditingController(text: i.citesPermitNo ?? '');
    _kimberleyNo = TextEditingController(text: i.kimberleyCertNo ?? '');
    _title = TextEditingController(text: i.title);
    _gemType = TextEditingController(text: i.gemType);
    _variety = TextEditingController(text: i.variety);
    _originCountry = TextEditingController(text: i.originCountry);
    _originRegion = TextEditingController(text: i.originRegion);
    _weightValue = TextEditingController(text: i.weightValue.toString());
    _quantity = TextEditingController(text: i.quantity.toString());
    _costPrice = TextEditingController(text: i.costPrice.toString());
    _sellingPrice = TextEditingController(
        text: i.sellingPrice != null && i.sellingPrice! > 0
            ? i.sellingPrice!.toStringAsFixed(2)
            : '');
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
    _makerId = i.makerId;
    _consignorId = i.consignorId;
    _consignorPrice = TextEditingController(text: i.consignorPrice?.toString() ?? '');
    _profitShare = TextEditingController(
        text: i.profitShare == null ? '50' : (i.profitShare! * 100).toStringAsFixed(0));
    _locationId = i.locationId;
    _originalLocationId = i.locationId;
    _photos = i.imageUrls.map(PhotoItem.existing).toList();
    _video = VideoChoice(currentUrl: i.videoUrl);
    _loadSuppliers();
    if (_canSetOwner) {
      _consignorRepo.getAll().then((o) {
        if (mounted) setState(() => _owners = o);
      }, onError: (Object e) => debugPrint('Owners not loaded: $e'));
    }
  }

  @override
  void dispose() {
    for (final c in [
      _permitNo, _kimberleyNo,
      _title, _gemType, _variety, _originCountry, _originRegion,
      _weightValue, _quantity, _costPrice, _sellingPrice,
      _barcode, _notes,
      _shapeOther, _cutTypeOther,
      _description, _certificationLab, _certificationNumber, _treatment,
      _lengthCtrl, _widthCtrl, _heightCtrl, _clarity, _species, _locality, _matrix,
      _weightGrams, _jewelryType, _metal, _metalPurity, _sizeOrLength,
      _gemstonesUsed, _totalWeightGrams, _consignorPrice, _profitShare,
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
    if (_title.text.trim().isEmpty) return 'Title is required.';
    final priceText = _sellingPrice.text.trim();
    if (priceText.isNotEmpty && parsePrice(priceText) == null) {
      return 'Price must be a number.';
    }
    if (widget.item.isListed &&
        widget.item.saleMethod != 'accept_offers' &&
        (parsePrice(priceText) ?? 0) <= 0) {
      return 'A listed item needs a price — or unlist it first.';
    }
    if (_productType == 'loose_stone' &&
        parseDecimalInput(_weightValue.text) == null) {
      return 'Weight must be a number.';
    }
    if (_productType == 'specimen' &&
        _weightGrams.text.isNotEmpty &&
        parseDecimalInput(_weightGrams.text) == null) {
      return 'Weight must be a number.';
    }
    if (_productType == 'jewelry' &&
        _totalWeightGrams.text.isNotEmpty &&
        parseDecimalInput(_totalWeightGrams.text) == null) {
      return 'Total weight must be a number.';
    }
    if (parseDecimalInput(_costPrice.text) == null) {
      return 'Cost price must be a number.';
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

      // A new video goes to Bunny and replaces the old one only once Bunny has
      // finished encoding it (Edge Function media), so keep the old URL here.
      String? finalVideoUrl = widget.item.videoUrl;
      if (_video.pending != null) {
        await _repository.uploadVideo(
          widget.item.id!,
          _video.pendingBytes!,
          _video.pending!.name,
        );
      } else if (_video.removed) {
        finalVideoUrl = null;
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
        sku: widget.item.sku, // immutable once assigned — never re-derived from form input
        title: _title.text.trim(),
        // Captured for all product types now — specimen/jewelry reuse the
        // same gem-type dropdown as loose_stone so their SKUs get a real
        // gem code instead of falling back to OTHR.
        gemType: _gemType.text.trim(),
        variety: _variety.text.trim(),
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
            isLooseStone ? parseDecimalInput(_weightValue.text)! : widget.item.weightValue,
        weightUnit: isLooseStone ? _weightUnit : widget.item.weightUnit,
        quantity: int.parse(_quantity.text),
        costPrice: parseDecimalInput(_costPrice.text)!,
        salePrice: widget.item.salePrice, // legacy column — no longer edited
        barcode: _barcode.text.trim(),
        qrCode: widget.item.qrCode,
        status: _status,
        notes: _notes.text.trim(),
        imageUrls: finalImageUrls,
        makerId: _makerId,
        // Keep the stone's seller — leaving it out saved seller_id = NULL and
        // hid the stone from the store (public views join sellers).
        sellerId: widget.item.sellerId,
        // Not edited on this page (listing panel / lot sorting own them) —
        // carried over so the full-row save doesn't reset them to defaults.
        saleMethod: widget.item.saleMethod,
        isUnsortedLot: widget.item.isUnsortedLot,
        lotRemainingCount: widget.item.lotRemainingCount,
        parentLotId: widget.item.parentLotId,
        courier: widget.item.courier,
        shippingCost: widget.item.shippingCost,
        deliveryDaysMin: widget.item.deliveryDaysMin,
        deliveryDaysMax: widget.item.deliveryDaysMax,
        prepDays: widget.item.prepDays,
        supplierId: _supplierId,
        supplierName: supplierName,
        locationId: _locationId,
        isListed: widget.item.isListed,
        sellingPrice: switch (parsePrice(_sellingPrice.text)) {
          final p? when p > 0 => p,
          _ => null,
        },
        listedAt: widget.item.listedAt,
        createdAt: widget.item.createdAt,
        productType: _productType,
        certificationLab: _orNull(_certificationLab),
        certificationNumber: _orNull(_certificationNumber),
        treatment: _orNull(_treatment),
        dimensionsMm: null,
        length: parseDecimalInput(_lengthCtrl.text),
        width: parseDecimalInput(_widthCtrl.text),
        height: parseDecimalInput(_heightCtrl.text),
        dimensionUnit: _dimensionUnit,
        description: _orNull(_description),
        videoUrl: finalVideoUrl,
        cut: null,
        clarity: isLooseStone ? _orNull(_clarity) : widget.item.clarity,
        species: isSpecimen ? _orNull(_species) : widget.item.species,
        locality: isSpecimen ? _orNull(_locality) : widget.item.locality,
        matrix: isSpecimen ? _orNull(_matrix) : widget.item.matrix,
        weightGrams: isSpecimen
            ? parseDecimalInput(_weightGrams.text)
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
            ? parseDecimalInput(_totalWeightGrams.text)
            : widget.item.totalWeightGrams,
        totalWeightGramsUnit: isJewelry ? _totalWeightGramsUnit : widget.item.totalWeightGramsUnit,
      );

      // Owner terms first, with the new price in the same update (the DB
      // refuses a price below the owner's price).
      if (_canSetOwner) {
        final price = _consignorId == null ? null : parseDecimalInput(_consignorPrice.text);
        final share = _consignorId == null ? null : (parseDecimalInput(_profitShare.text) ?? 50).clamp(0, 100) / 100;
        if (_consignorId != null && price == null) {
          throw Exception("Enter the owner's price for this stone.");
        }
        if (_consignorId != widget.item.consignorId ||
            price != widget.item.consignorPrice ||
            share != widget.item.profitShare) {
          await _consignorRepo.setItemConsignment(
            widget.item.id!,
            consignorId: _consignorId,
            consignorPrice: price,
            profitShare: share?.toDouble(),
            sellingPrice: updated.sellingPrice,
          );
        }
      }

      await _repository.updateItem(widget.item.id!, updated, before: widget.item);

      // Removed an uploaded video: delete the old file (best effort).
      if (finalVideoUrl != widget.item.videoUrl) {
        try {
          await _repository.deleteUploadedVideo(widget.item.videoUrl, itemId: widget.item.id);
        } catch (e) {
          debugPrint('Old video not deleted: $e');
        }
      }

      // Protected materials answers: saved separately (never in toMap).
      final permit = _permitNo.text.trim();
      final kimberley = _kimberleyNo.text.trim();
      if (_cites != widget.item.citesDeclaration || _diamond != widget.item.diamondDeclaration ||
          permit != (widget.item.citesPermitNo ?? '') || kimberley != (widget.item.kimberleyCertNo ?? '')) {
        await _repository.setItemCompliance(widget.item.id!,
            cites: _cites, permitNo: _cites == 'permit' ? permit : null,
            diamond: _diamond, kimberleyNo: _diamond == 'kimberley' ? kimberley : null);
      }

      if (_makerId != widget.item.makerId && UserProfileService.instance.isOwner) {
        await _repository.setItemMaker(widget.item.id!, _makerId);
      }

      if (_locationId != _originalLocationId && widget.item.id != null) {
        await _movementRepo.recordMovement(
          inventoryItemId: widget.item.id!,
          fromLocationId: _originalLocationId,
          toLocationId: _locationId,
          reason: 'Manual edit',
        );
      }

      // Fresh copy from the database (includes read-only fields such as the
      // protected materials answers, which aren't part of `updated`).
      final fresh = await _repository.getItem(widget.item.id!).catchError((_) => updated);
      if (mounted) Navigator.pop(context, fresh);
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

  /// Mine (GemWorkers' own) or held for someone else: owner, their price and
  /// their share of the profit (sql/consignment_setup.sql).
  Widget _buildOwnerSection() {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String?>(
            initialValue: _owners.any((o) => o.id == _consignorId) ? _consignorId : null,
            decoration: const InputDecoration(labelText: 'Owner'),
            items: [
              const DropdownMenuItem(value: null, child: Text("Mine — GemWorkers' own stone")),
              for (final o in _owners.where((o) => o.active || o.id == _consignorId))
                DropdownMenuItem(value: o.id, child: Text(o.name)),
            ],
            onChanged: _saving
                ? null
                : (v) => setState(() {
                      _consignorId = v;
                      final o = _owners.where((x) => x.id == v).firstOrNull;
                      if (o != null && widget.item.consignorId != v) {
                        _profitShare.text = (o.defaultShare * 100).toStringAsFixed(0);
                      }
                    }),
          ),
          if (_consignorId != null) ...[
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _consignorPrice,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: "Owner's price € *"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _profitShare,
                  enabled: !_saving,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Their share of profit %'),
                ),
              ),
            ]),
            const SizedBox(height: 6),
            Text(
              "They get their price + their share of what's left after postage and the Stripe fee. "
              "Offers below their price can't be accepted.",
              style: textTheme.bodySmall,
            ),
          ] else if (_owners.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text("Holding someone else's stone? Add them first under Owners.", style: textTheme.bodySmall),
            ),
        ],
      ),
    );
  }

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
            onChanged: (v) => setState(() => _weightGramsUnit = v!),
          ),
          OriginCountryField(controller: _originCountry, label: 'Origin Country'),
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
          FormTextField('Weight *', _weightValue, keyboardType: const TextInputType.numberWithOptions(decimal: true)),
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

          const FormSection('Video'),
          ItemVideoPicker(
            value: _video,
            onChanged: (v) => setState(() => _video = v),
            enabled: !_saving,
          ),

          const FormSection('Identification'),
          ReadOnlyFormField('SKU', widget.item.sku),
          FormTextField('Title *', _title),
          // Re-checked while typing: coral, ivory, shells, fossils, diamonds…
          AnimatedBuilder(
            animation: Listenable.merge([
              _title, _gemType, _variety, _species, _gemstonesUsed, _description,
              _jewelryType, _matrix, _shapeOther, _cutTypeOther,
            ]),
            builder: (context, _) => ProtectedMaterialsSection(
              flags: protectedFlags(
                text: [_title.text, _gemType.text, _variety.text, _species.text, _gemstonesUsed.text,
                       _description.text, _jewelryType.text, _matrix.text],
                shape: [_shapeSelection == 'Other' ? _shapeOther.text : _shapeSelection,
                        _cutTypeSelection == 'Other' ? _cutTypeOther.text : _cutTypeSelection],
                gemType: _gemType.text,
              ),
              cites: _cites,
              permitNo: _permitNo,
              diamond: _diamond,
              kimberleyNo: _kimberleyNo,
              onCites: (v) => setState(() => _cites = v),
              onDiamond: (v) => setState(() => _diamond = v),
              enabled: !_saving,
            ),
          ),

          const FormSection('Price'),
          PriceField(
            controller: _sellingPrice,
            sellerId: widget.item.sellerId ?? svc.effectiveSellerId,
            enabled: !_saving,
          ),

          ..._buildTypeSpecificFields(),

          const FormSection('Description & Certification'),
          FormTextField('Description', _description, maxLines: 3),
          FormTextField('Certification Lab', _certificationLab),
          FormTextField('Certification Number', _certificationNumber),
          FormTextField('Treatment', _treatment),

          const FormSection('Private — only you see this'),
          FormTextField('Cost Price *', _costPrice,
              keyboardType: const TextInputType.numberWithOptions(decimal: true)),

          if (UserProfileService.instance.isOwner) ...[
            const FormSection('Maker credit'),
            MakerPicker(
              productType: _productType,
              value: _makerId,
              onChanged: (v) => setState(() => _makerId = v),
              enabled: !_saving,
            ),
          ],

          if (_canSetOwner) ...[
            const FormSection('Who owns this stone?'),
            _buildOwnerSection(),
          ],

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
          FormTextField('Quantity in stock * (1 = one-of-a-kind; e.g. 10 identical bracelets)', _quantity, keyboardType: TextInputType.number),
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
