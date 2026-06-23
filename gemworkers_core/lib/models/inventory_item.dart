class _Omitted {
  const _Omitted();
}

const _omitted = _Omitted();

class InventoryItem {
  final String? id;

  final String sku;
  final String title;

  final String gemType;
  final String variety;

  final String originCountry;
  final String originRegion;

  final String shape;
  final String cutType;

  final double weightValue;
  final String weightUnit;

  final int quantity;

  final double costPrice;
  final double salePrice;

  final String barcode;
  final String qrCode;

  final String status;

  final String notes;

  final List<String> imageUrls;

  // Supplier link — supplierId stored in DB; supplierName is join-derived (not in toMap).
  final String? supplierId;
  final String supplierName;

  // Seller & location ownership.
  final String? sellerId;
  final String? locationId;

  // Marketplace listing (is_listed feeds a future public storefront).
  final bool isListed;
  final double? sellingPrice;
  final DateTime? listedAt;
  // 'buy_now' | 'accept_offers' | 'both' — mirrors CHECK constraint on inventory_items.
  final String saleMethod;

  // Unsorted lot tracking — set when created from a 'lot' purchase line.
  final bool isUnsortedLot;
  final int? lotRemainingCount;
  final String? parentLotId;

  final DateTime? createdAt;

  // ── Product type (loose_stone | specimen | jewelry) ─────────────────────
  final String productType;

  // Shared/common fields across all product types.
  final String? certificationLab;
  final String? certificationNumber;
  final String? treatment;
  final String? dimensionsMm;
  final String? description;
  final String? videoUrl;

  // Loose stone specific.
  final String? cut;
  final String? clarity;

  // Specimen specific.
  final String? species;
  final String? locality;
  final String? matrix;
  final double? weightGrams;
  final String weightGramsUnit;        // unit for weight_grams (ct/g/kg)

  // Jewelry specific.
  final String? jewelryType;
  final String? metal;
  final String? metalPurity;
  final String? sizeOrLength;
  final String? gemstonesUsed;
  final double? totalWeightGrams;
  final String totalWeightGramsUnit;   // unit for total_weight_grams (ct/g/kg)

  // Shipping — set at listing time, persists when unlisted for relisting.
  final String? courier;
  final double? shippingCost;   // 0 = free, null = not specified
  final int? deliveryDaysMin;
  final int? deliveryDaysMax;
  final int? prepDays;

  const InventoryItem({
    this.id,
    required this.sku,
    required this.title,
    required this.gemType,
    required this.variety,
    required this.originCountry,
    required this.originRegion,
    required this.shape,
    required this.cutType,
    required this.weightValue,
    required this.weightUnit,
    required this.quantity,
    required this.costPrice,
    required this.salePrice,
    required this.barcode,
    required this.qrCode,
    required this.status,
    required this.notes,
    required this.imageUrls,
    this.supplierId,
    this.supplierName = '',
    this.sellerId,
    this.locationId,
    this.isListed = false,
    this.sellingPrice,
    this.listedAt,
    this.saleMethod = 'buy_now',
    this.isUnsortedLot = false,
    this.lotRemainingCount,
    this.parentLotId,
    this.createdAt,
    this.productType = 'loose_stone',
    this.certificationLab,
    this.certificationNumber,
    this.treatment,
    this.dimensionsMm,
    this.description,
    this.videoUrl,
    this.cut,
    this.clarity,
    this.species,
    this.locality,
    this.matrix,
    this.weightGrams,
    this.weightGramsUnit = 'g',
    this.jewelryType,
    this.metal,
    this.metalPurity,
    this.sizeOrLength,
    this.gemstonesUsed,
    this.totalWeightGrams,
    this.totalWeightGramsUnit = 'g',
    this.courier,
    this.shippingCost,
    this.deliveryDaysMin,
    this.deliveryDaysMax,
    this.prepDays,
  });

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    List<String> parseUrls(dynamic value) {
      if (value == null) return [];
      if (value is List) return value.map((e) => e.toString()).toList();
      return [];
    }

    return InventoryItem(
      id: map['id']?.toString(),
      sku: map['sku'] ?? '',
      title: map['title'] ?? '',
      gemType: map['gem_type'] ?? '',
      variety: map['variety'] ?? '',
      originCountry: map['origin_country'] ?? '',
      originRegion: map['origin_region'] ?? '',
      shape: map['shape'] ?? '',
      cutType: map['cut_type'] ?? '',
      weightValue: (map['weight_value'] ?? 0).toDouble(),
      weightUnit: map['weight_unit'] ?? 'ct',
      quantity: map['quantity'] ?? 1,
      costPrice: (map['cost_price'] ?? 0).toDouble(),
      salePrice: (map['sale_price'] ?? 0).toDouble(),
      barcode: map['barcode'] ?? '',
      qrCode: map['qr_code'] ?? '',
      status: map['status'] ?? 'available',
      notes: map['notes'] ?? '',
      imageUrls: parseUrls(map['image_urls']),
      supplierId: map['supplier_id']?.toString(),
      supplierName:
          (map['suppliers'] as Map<String, dynamic>?)?['name']?.toString() ??
              '',
      sellerId: map['seller_id']?.toString(),
      locationId: map['location_id']?.toString(),
      isListed: map['is_listed'] == true,
      sellingPrice: map['selling_price'] != null
          ? (map['selling_price'] as num).toDouble()
          : null,
      listedAt: map['listed_at'] != null
          ? DateTime.parse(map['listed_at'].toString())
          : null,
      saleMethod: map['sale_method']?.toString() ?? 'buy_now',
      isUnsortedLot: map['is_unsorted_lot'] == true,
      lotRemainingCount: map['lot_remaining_count'] as int?,
      parentLotId: map['parent_lot_id']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      productType: map['product_type']?.toString() ?? 'loose_stone',
      certificationLab: map['certification_lab']?.toString(),
      certificationNumber: map['certification_number']?.toString(),
      treatment: map['treatment']?.toString(),
      dimensionsMm: map['dimensions_mm']?.toString(),
      description: map['description']?.toString(),
      videoUrl: map['video_url']?.toString(),
      cut: map['cut']?.toString(),
      clarity: map['clarity']?.toString(),
      species: map['species']?.toString(),
      locality: map['locality']?.toString(),
      matrix: map['matrix']?.toString(),
      weightGrams: map['weight_grams'] != null
          ? (map['weight_grams'] as num).toDouble()
          : null,
      weightGramsUnit: map['weight_grams_unit']?.toString() ?? 'g',
      jewelryType: map['jewelry_type']?.toString(),
      metal: map['metal']?.toString(),
      metalPurity: map['metal_purity']?.toString(),
      sizeOrLength: map['size_or_length']?.toString(),
      gemstonesUsed: map['gemstones_used']?.toString(),
      totalWeightGrams: map['total_weight_grams'] != null
          ? (map['total_weight_grams'] as num).toDouble()
          : null,
      totalWeightGramsUnit: map['total_weight_grams_unit']?.toString() ?? 'g',
      courier: map['courier']?.toString(),
      shippingCost: map['shipping_cost'] != null
          ? (map['shipping_cost'] as num).toDouble()
          : null,
      deliveryDaysMin: map['delivery_days_min'] as int?,
      deliveryDaysMax: map['delivery_days_max'] as int?,
      prepDays: map['prep_days'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'title': title,
      'gem_type': gemType,
      'variety': variety,
      'origin_country': originCountry,
      'origin_region': originRegion,
      'shape': shape,
      'cut_type': cutType,
      'weight_value': weightValue,
      'weight_unit': weightUnit,
      'quantity': quantity,
      'cost_price': costPrice,
      'sale_price': salePrice,
      'barcode': barcode,
      'qr_code': qrCode,
      'status': status,
      'notes': notes,
      'image_urls': imageUrls,
      'supplier_id': supplierId,
      'seller_id': sellerId,
      'location_id': locationId,
      'is_listed': isListed,
      'selling_price': sellingPrice,
      'listed_at': listedAt?.toIso8601String(),
      'sale_method': saleMethod,
      'is_unsorted_lot': isUnsortedLot,
      'lot_remaining_count': lotRemainingCount,
      'parent_lot_id': parentLotId,
      'product_type': productType,
      'certification_lab': certificationLab,
      'certification_number': certificationNumber,
      'treatment': treatment,
      'dimensions_mm': dimensionsMm,
      'description': description,
      'video_url': videoUrl,
      'cut': cut,
      'clarity': clarity,
      'species': species,
      'locality': locality,
      'matrix': matrix,
      'weight_grams': weightGrams,
      'weight_grams_unit': weightGramsUnit,
      'jewelry_type': jewelryType,
      'metal': metal,
      'metal_purity': metalPurity,
      'size_or_length': sizeOrLength,
      'gemstones_used': gemstonesUsed,
      'total_weight_grams': totalWeightGrams,
      'total_weight_grams_unit': totalWeightGramsUnit,
      'courier': courier,
      'shipping_cost': shippingCost,
      'delivery_days_min': deliveryDaysMin,
      'delivery_days_max': deliveryDaysMax,
      'prep_days': prepDays,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? sku,
    String? title,
    String? gemType,
    String? variety,
    String? originCountry,
    String? originRegion,
    String? shape,
    String? cutType,
    double? weightValue,
    String? weightUnit,
    int? quantity,
    double? costPrice,
    double? salePrice,
    String? barcode,
    String? qrCode,
    String? status,
    String? notes,
    List<String>? imageUrls,
    // Use Object? with _omitted sentinel so callers can explicitly set null.
    Object? supplierId = _omitted,
    String? supplierName,
    Object? sellerId = _omitted,
    Object? locationId = _omitted,
    bool? isListed,
    Object? sellingPrice = _omitted,
    Object? listedAt = _omitted,
    String? saleMethod,
    bool? isUnsortedLot,
    Object? lotRemainingCount = _omitted,
    Object? parentLotId = _omitted,
    DateTime? createdAt,
    String? productType,
    Object? certificationLab = _omitted,
    Object? certificationNumber = _omitted,
    Object? treatment = _omitted,
    Object? dimensionsMm = _omitted,
    Object? description = _omitted,
    Object? videoUrl = _omitted,
    Object? cut = _omitted,
    Object? clarity = _omitted,
    Object? species = _omitted,
    Object? locality = _omitted,
    Object? matrix = _omitted,
    Object? weightGrams = _omitted,
    String? weightGramsUnit,
    Object? jewelryType = _omitted,
    Object? metal = _omitted,
    Object? metalPurity = _omitted,
    Object? sizeOrLength = _omitted,
    Object? gemstonesUsed = _omitted,
    Object? totalWeightGrams = _omitted,
    String? totalWeightGramsUnit,
    Object? courier = _omitted,
    Object? shippingCost = _omitted,
    Object? deliveryDaysMin = _omitted,
    Object? deliveryDaysMax = _omitted,
    Object? prepDays = _omitted,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      title: title ?? this.title,
      gemType: gemType ?? this.gemType,
      variety: variety ?? this.variety,
      originCountry: originCountry ?? this.originCountry,
      originRegion: originRegion ?? this.originRegion,
      shape: shape ?? this.shape,
      cutType: cutType ?? this.cutType,
      weightValue: weightValue ?? this.weightValue,
      weightUnit: weightUnit ?? this.weightUnit,
      quantity: quantity ?? this.quantity,
      costPrice: costPrice ?? this.costPrice,
      salePrice: salePrice ?? this.salePrice,
      barcode: barcode ?? this.barcode,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      supplierId:
          identical(supplierId, _omitted) ? this.supplierId : supplierId as String?,
      supplierName: supplierName ?? this.supplierName,
      sellerId:
          identical(sellerId, _omitted) ? this.sellerId : sellerId as String?,
      locationId:
          identical(locationId, _omitted) ? this.locationId : locationId as String?,
      isListed: isListed ?? this.isListed,
      sellingPrice: identical(sellingPrice, _omitted)
          ? this.sellingPrice
          : sellingPrice as double?,
      listedAt: identical(listedAt, _omitted)
          ? this.listedAt
          : listedAt as DateTime?,
      saleMethod: saleMethod ?? this.saleMethod,
      isUnsortedLot: isUnsortedLot ?? this.isUnsortedLot,
      lotRemainingCount: identical(lotRemainingCount, _omitted)
          ? this.lotRemainingCount
          : lotRemainingCount as int?,
      parentLotId: identical(parentLotId, _omitted)
          ? this.parentLotId
          : parentLotId as String?,
      createdAt: createdAt ?? this.createdAt,
      productType: productType ?? this.productType,
      certificationLab: identical(certificationLab, _omitted)
          ? this.certificationLab
          : certificationLab as String?,
      certificationNumber: identical(certificationNumber, _omitted)
          ? this.certificationNumber
          : certificationNumber as String?,
      treatment: identical(treatment, _omitted)
          ? this.treatment
          : treatment as String?,
      dimensionsMm: identical(dimensionsMm, _omitted)
          ? this.dimensionsMm
          : dimensionsMm as String?,
      description: identical(description, _omitted)
          ? this.description
          : description as String?,
      videoUrl:
          identical(videoUrl, _omitted) ? this.videoUrl : videoUrl as String?,
      cut: identical(cut, _omitted) ? this.cut : cut as String?,
      clarity: identical(clarity, _omitted) ? this.clarity : clarity as String?,
      species: identical(species, _omitted) ? this.species : species as String?,
      locality:
          identical(locality, _omitted) ? this.locality : locality as String?,
      matrix: identical(matrix, _omitted) ? this.matrix : matrix as String?,
      weightGrams: identical(weightGrams, _omitted)
          ? this.weightGrams
          : weightGrams as double?,
      weightGramsUnit: weightGramsUnit ?? this.weightGramsUnit,
      jewelryType: identical(jewelryType, _omitted)
          ? this.jewelryType
          : jewelryType as String?,
      metal: identical(metal, _omitted) ? this.metal : metal as String?,
      metalPurity: identical(metalPurity, _omitted)
          ? this.metalPurity
          : metalPurity as String?,
      sizeOrLength: identical(sizeOrLength, _omitted)
          ? this.sizeOrLength
          : sizeOrLength as String?,
      gemstonesUsed: identical(gemstonesUsed, _omitted)
          ? this.gemstonesUsed
          : gemstonesUsed as String?,
      totalWeightGrams: identical(totalWeightGrams, _omitted)
          ? this.totalWeightGrams
          : totalWeightGrams as double?,
      totalWeightGramsUnit: totalWeightGramsUnit ?? this.totalWeightGramsUnit,
      courier:
          identical(courier, _omitted) ? this.courier : courier as String?,
      shippingCost: identical(shippingCost, _omitted)
          ? this.shippingCost
          : shippingCost as double?,
      deliveryDaysMin: identical(deliveryDaysMin, _omitted)
          ? this.deliveryDaysMin
          : deliveryDaysMin as int?,
      deliveryDaysMax: identical(deliveryDaysMax, _omitted)
          ? this.deliveryDaysMax
          : deliveryDaysMax as int?,
      prepDays:
          identical(prepDays, _omitted) ? this.prepDays : prepDays as int?,
    );
  }
}
