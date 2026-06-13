class PurchaseItem {
  final String? id;
  final String? purchaseId;

  /// 'individual' | 'multiple' | 'lot'
  final String lineType;

  // ── individual gem ──────────────────────────────────────────────────────────
  final String gemType;
  final String variety;
  final double? weightValue;
  final String weightUnit;
  final String originCountry;

  // ── multiple / lot ──────────────────────────────────────────────────────────
  /// Display name: item name for multiples, lot name for lots.
  final String itemName;

  // ── lot ─────────────────────────────────────────────────────────────────────
  /// Approximate stone count — also drives cost allocation (stored in quantity).
  final int? approxCount;

  // ── all ─────────────────────────────────────────────────────────────────────
  /// Used for cost allocation: 1 for individual, count for multiple, approxCount for lot.
  final int quantity;

  /// Price entered by the user. Not stored in DB — used for Method B cost allocation.
  /// In 'per_piece' mode: price per unit. In 'total' mode: total price for the line.
  final double unitPrice;

  /// How the price was entered: 'per_piece' or 'total'. Not stored in DB.
  /// Ignored for individual lines (qty is always 1, so both modes are equivalent).
  final String priceMode;

  /// Total gem value for this line. Used by the repository for overhead distribution.
  double get lineValue =>
      priceMode == 'per_piece' ? unitPrice * quantity : unitPrice;

  /// This line's share of the total landed cost (gem value + proportional overhead).
  /// Computed by the repository.
  final double allocatedCost;

  final String notes;

  const PurchaseItem({
    this.id,
    this.purchaseId,
    this.lineType = 'individual',
    required this.gemType,
    this.variety = '',
    this.weightValue,
    this.weightUnit = 'ct',
    this.originCountry = '',
    this.itemName = '',
    this.approxCount,
    this.quantity = 1,
    this.unitPrice = 0,
    this.priceMode = 'total',
    required this.allocatedCost,
    this.notes = '',
  });

  double get costPerUnit => quantity > 0 ? allocatedCost / quantity : 0;
  double get costPerGem => costPerUnit;

  factory PurchaseItem.fromMap(Map<String, dynamic> map) {
    final lineType = map['line_type']?.toString() ?? 'individual';
    final approxCount = map['approx_count'] as int?;
    return PurchaseItem(
      id: map['id']?.toString(),
      purchaseId: map['purchase_id']?.toString(),
      lineType: lineType,
      gemType: map['gem_type'] ?? '',
      variety: map['variety'] ?? '',
      weightValue: map['weight_value'] != null
          ? (map['weight_value'] as num).toDouble()
          : null,
      weightUnit: map['weight_unit'] ?? 'ct',
      originCountry: map['origin_country'] ?? '',
      itemName: map['item_name'] ?? '',
      // approxCount is only meaningful for lots; multiples store their count
      // in approx_count in the DB but expose it via quantity in the model.
      approxCount: lineType == 'lot' ? approxCount : null,
      // quantity is derived, not stored in DB.
      quantity: lineType == 'individual' ? 1 : (approxCount ?? 1),
      // unitPrice and priceMode are UI-only, not stored in DB.
      unitPrice: 0,
      priceMode: 'total',
      allocatedCost: (map['allocated_cost'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        if (purchaseId != null) 'purchase_id': purchaseId,
        'line_type': lineType,
        'gem_type': gemType,
        'variety': variety,
        'weight_value': weightValue,
        'weight_unit': weightUnit,
        'origin_country': originCountry,
        'item_name': itemName,
        // quantity is not a DB column — approx_count stores the count for both
        // multiples (their item count) and lots (the stone estimate).
        'approx_count': lineType == 'multiple' ? quantity : approxCount,
        'allocated_cost': allocatedCost,
        'notes': notes,
      };

  PurchaseItem copyWith({
    String? id,
    String? purchaseId,
    String? lineType,
    String? gemType,
    String? variety,
    double? weightValue,
    String? weightUnit,
    String? originCountry,
    String? itemName,
    int? approxCount,
    int? quantity,
    double? unitPrice,
    String? priceMode,
    double? allocatedCost,
    String? notes,
  }) {
    return PurchaseItem(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      lineType: lineType ?? this.lineType,
      gemType: gemType ?? this.gemType,
      variety: variety ?? this.variety,
      weightValue: weightValue ?? this.weightValue,
      weightUnit: weightUnit ?? this.weightUnit,
      originCountry: originCountry ?? this.originCountry,
      itemName: itemName ?? this.itemName,
      approxCount: approxCount ?? this.approxCount,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      priceMode: priceMode ?? this.priceMode,
      allocatedCost: allocatedCost ?? this.allocatedCost,
      notes: notes ?? this.notes,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class Purchase {
  final String? id;
  final String? supplierId;

  // Join-derived from suppliers table.
  final String supplierName;

  // Auto-generated by DB sequence — not sent on insert.
  final String purchaseNumber;

  final DateTime purchaseDate;
  final double gemCost;
  final double shippingCost;
  final double customsCost;
  final double otherFees;
  final String notes;

  // Populated when loaded via getPurchaseDetail.
  final List<PurchaseItem> items;

  final String? sellerId;
  final DateTime? createdAt;

  const Purchase({
    this.id,
    this.supplierId,
    this.supplierName = '',
    this.purchaseNumber = '',
    required this.purchaseDate,
    required this.gemCost,
    this.shippingCost = 0,
    this.customsCost = 0,
    this.otherFees = 0,
    required this.notes,
    this.items = const [],
    this.sellerId,
    this.createdAt,
  });

  double get totalCost => gemCost + shippingCost + customsCost + otherFees;

  int get totalGems => items.fold(0, (sum, i) => sum + i.quantity);

  double get costPerGem => totalGems > 0 ? totalCost / totalGems : 0;

  factory Purchase.fromMap(Map<String, dynamic> map) {
    List<PurchaseItem> parseItems(dynamic value) {
      if (value is! List) return const [];
      return value
          .map<PurchaseItem>(
              (e) => PurchaseItem.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    final supplier = map['suppliers'] as Map<String, dynamic>?;
    return Purchase(
      id: map['id']?.toString(),
      supplierId: map['supplier_id']?.toString(),
      supplierName: supplier?['name']?.toString() ?? '',
      purchaseNumber: map['purchase_number']?.toString() ?? '',
      purchaseDate: map['purchase_date'] != null
          ? DateTime.parse(map['purchase_date'].toString())
          : DateTime.now(),
      gemCost: (map['gem_cost'] ?? 0).toDouble(),
      shippingCost: (map['shipping_cost'] ?? 0).toDouble(),
      customsCost: (map['customs_cost'] ?? 0).toDouble(),
      otherFees: (map['other_fees'] ?? 0).toDouble(),
      notes: map['notes'] ?? '',
      items: parseItems(map['purchase_items']),
      sellerId: map['seller_id']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  /// Does NOT include purchase_number (auto-generated by DB) or items.
  Map<String, dynamic> toMap() => {
        'supplier_id': supplierId,
        'purchase_date':
            '${purchaseDate.year.toString().padLeft(4, '0')}-'
            '${purchaseDate.month.toString().padLeft(2, '0')}-'
            '${purchaseDate.day.toString().padLeft(2, '0')}',
        'gem_cost': gemCost,
        'shipping_cost': shippingCost,
        'customs_cost': customsCost,
        'other_fees': otherFees,
        'total_cost': totalCost,
        'notes': notes,
        'seller_id': sellerId,
      };

  Purchase copyWith({
    String? id,
    Object? supplierId = _omitted,
    String? supplierName,
    String? purchaseNumber,
    DateTime? purchaseDate,
    double? gemCost,
    double? shippingCost,
    double? customsCost,
    double? otherFees,
    String? notes,
    List<PurchaseItem>? items,
    Object? sellerId = _omitted,
    DateTime? createdAt,
  }) {
    return Purchase(
      id: id ?? this.id,
      supplierId: identical(supplierId, _omitted)
          ? this.supplierId
          : supplierId as String?,
      supplierName: supplierName ?? this.supplierName,
      purchaseNumber: purchaseNumber ?? this.purchaseNumber,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      gemCost: gemCost ?? this.gemCost,
      shippingCost: shippingCost ?? this.shippingCost,
      customsCost: customsCost ?? this.customsCost,
      otherFees: otherFees ?? this.otherFees,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      sellerId:
          identical(sellerId, _omitted) ? this.sellerId : sellerId as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

const _omitted = Object();
