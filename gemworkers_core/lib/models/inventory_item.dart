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

  final DateTime? createdAt;

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
    this.createdAt,
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
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
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
    DateTime? createdAt,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
