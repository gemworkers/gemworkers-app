import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/services/seller_service.dart';
import '../../models/inventory_item.dart';
import '../../models/item_movement.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/location_repository.dart';
import 'edit_inventory_page.dart';
import 'listing_sheet.dart';
import 'lot_sort_page.dart';
import 'record_sale_sheet.dart';

class InventoryDetailPage extends StatefulWidget {
  final InventoryItem item;

  const InventoryDetailPage({super.key, required this.item});

  @override
  State<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends State<InventoryDetailPage> {
  final _repository = InventoryRepository();
  final _movementRepo = ItemMovementRepository();
  final _locationRepo = LocationRepository();
  final _picker = ImagePicker();

  late InventoryItem _item;
  bool _uploadingImage = false;
  bool _deleting = false;

  List<ItemMovement> _movements = [];
  String _locationBreadcrumb = '';
  bool _movementsLoading = false;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _loadLocationAndMovements();
  }

  Future<void> _loadLocationAndMovements() async {
    if (_item.id == null) return;
    setState(() => _movementsLoading = true);
    try {
      final sellerId = _item.sellerId ?? kCurrentSellerId;
      final futures = <Future>[
        _movementRepo.getMovementsForItem(_item.id!),
        if (_item.locationId != null)
          _locationRepo.getBreadcrumb(_item.locationId!, sellerId),
      ];
      final results = await Future.wait(futures);
      if (mounted) {
        setState(() {
          _movements = results[0] as List<ItemMovement>;
          if (_item.locationId != null && results.length > 1) {
            _locationBreadcrumb = results[1] as String;
          }
          _movementsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _movementsLoading = false);
    }
  }

  // ── Record sale ───────────────────────────────────────────────────────────

  Future<void> _recordSale() async {
    if (_item.id == null || _item.status == 'sold') return;
    final result = await showRecordSaleSheet(context, [_item]);
    if (result == null || !mounted) return;

    setState(() => _item = _item.copyWith(status: 'sold', isListed: false));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sale recorded · ${result.orderNumber} · '
          'payout €${result.sellerPayout.toStringAsFixed(2)}',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ── List / Unlist ─────────────────────────────────────────────────────────

  Future<void> _openListingSheet() async {
    if (_item.id == null) return;
    final result = await showListingSheet(context, _item);
    if (result == null || !mounted) return;
    if (result.listed && result.price != null) {
      setState(() => _item = _item.copyWith(
            isListed: true,
            sellingPrice: result.price,
            listedAt: DateTime.now(),
          ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Item listed at €${result.price!.toStringAsFixed(2)}')));
    } else if (!result.listed) {
      setState(() => _item = _item.copyWith(isListed: false, listedAt: null));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from marketplace')));
    }
  }

  // ── Lot sorting ───────────────────────────────────────────────────────────

  Future<void> _openLotSort() async {
    if (_item.id == null) return;
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => LotSortPage(lot: _item)),
    );
    if (updated == true && mounted) {
      try {
        final fresh = await _repository.getItem(_item.id!);
        if (mounted) {
          setState(() => _item = fresh);
          _loadLocationAndMovements();
        }
      } catch (_) {}
    }
  }

  // ── Edit ──────────────────────────────────────────────────────────────────

  Future<void> _openEdit() async {
    final updated = await Navigator.push<InventoryItem>(
      context,
      MaterialPageRoute(builder: (_) => EditInventoryPage(item: _item)),
    );
    if (updated != null && mounted) {
      setState(() => _item = updated);
      _loadLocationAndMovements();
    }
  }

  // ── Delete item ───────────────────────────────────────────────────────────

  Future<void> _confirmDeleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Delete "${_item.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _repository.deleteItem(_item.id!);
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
        setState(() => _deleting = false);
      }
    }
  }

  // ── QR code ───────────────────────────────────────────────────────────────

  void _showQRCode() {
    final data = _item.sku.isNotEmpty ? _item.sku : (_item.id ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 220,
              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square),
              dataModuleStyle:
                  const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square),
            ),
            const SizedBox(height: 8),
            Text(
              _item.sku.isNotEmpty ? _item.sku : 'No SKU',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            if (_item.title.isNotEmpty)
              Text(
                _item.title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ── Photo upload ──────────────────────────────────────────────────────────

  Future<void> _pickAndUpload() async {
    if (_item.id == null) return;

    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !mounted) return;

    setState(() => _uploadingImage = true);
    try {
      final bytes = await file.readAsBytes();
      final url = await _repository.uploadImage(_item.id!, bytes, file.name);
      final updatedUrls = [..._item.imageUrls, url];
      await _repository.updateItemImages(_item.id!, updatedUrls);
      if (mounted) setState(() => _item = _item.copyWith(imageUrls: updatedUrls));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  // ── Photo deletion ────────────────────────────────────────────────────────

  Future<void> _confirmDeletePhoto(int index) async {
    final url = _item.imageUrls[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text('Remove this photo from the item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _repository.deleteImageByUrl(_item.id!, url, _item.imageUrls);
      final updatedUrls = [..._item.imageUrls]..removeAt(index);
      if (mounted) setState(() => _item = _item.copyWith(imageUrls: updatedUrls));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Remove failed: $e')),
        );
      }
    }
  }

  // ── Gallery ───────────────────────────────────────────────────────────────

  void _openGallery(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ImageGalleryPage(
          imageUrls: _item.imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  // ── Build helpers ─────────────────────────────────────────────────────────

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '—' : value),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _uploadingImage ? null : _pickAndUpload,
              icon: _uploadingImage
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_a_photo_outlined, size: 18),
              label: Text(_uploadingImage ? 'Uploading…' : 'Add Photo'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_item.imageUrls.isEmpty)
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('No photos yet', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _item.imageUrls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) => GestureDetector(
                onTap: () => _openGallery(index),
                onLongPress: () => _confirmDeletePhoto(index),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _item.imageUrls[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 4),
          child: Text(
            'Tap to view · Long press to remove',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.grey),
          ),
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildMovementTimeline() {
    if (_movementsLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_movements.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Movement History'),
        ..._movements.map((m) {
          final from = m.fromLocationName.isNotEmpty
              ? m.fromLocationName
              : 'None';
          final to = m.toLocationName.isNotEmpty ? m.toLocationName : 'None';
          final date = '${m.movedAt.day.toString().padLeft(2, '0')}/'
              '${m.movedAt.month.toString().padLeft(2, '0')}/'
              '${m.movedAt.year}';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$from → $to',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        m.reason.isNotEmpty
                            ? '$date · ${m.reason}'
                            : date,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                      if (m.note.isNotEmpty)
                        Text(m.note,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_outlined),
            onPressed: _showQRCode,
            tooltip: 'QR Code',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _openEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: _deleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            onPressed: _deleting ? null : _confirmDeleteItem,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPhotoSection(),

          _sectionLabel('Identification'),
          _row('SKU', _item.sku),
          _row('Title', _item.title),

          _sectionLabel('Gem Details'),
          _row('Gem Type', _item.gemType),
          _row('Variety', _item.variety),
          _row('Shape', _item.shape),
          _row('Cut Type', _item.cutType),

          _sectionLabel('Origin'),
          _row('Country', _item.originCountry),
          _row('Region', _item.originRegion),

          _sectionLabel('Weight & Quantity'),
          _row('Weight', '${_item.weightValue} ${_item.weightUnit}'),
          _row('Quantity', _item.quantity.toString()),

          _sectionLabel('Pricing'),
          _row('Cost Price', '€${_item.costPrice.toStringAsFixed(2)}'),
          _row('Sale Price', '€${_item.salePrice.toStringAsFixed(2)}'),

          if (_item.isUnsortedLot) ...[
            _sectionLabel('Lot'),
            _row('Stones remaining', '~${_item.lotRemainingCount ?? 0}'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openLotSort,
                icon: const Icon(Icons.sort, size: 18),
                label: const Text('Sort this lot'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],

          _sectionLabel('Supplier'),
          _row(
            'Supplier',
            _item.supplierName.isNotEmpty ? _item.supplierName : '—',
          ),

          _sectionLabel('Where is this item?'),
          _row(
            'Location',
            _item.locationId == null
                ? 'No location set'
                : _locationBreadcrumb.isNotEmpty
                    ? _locationBreadcrumb
                    : _item.locationId!,
          ),

          _sectionLabel('Marketplace'),
          Row(
            children: [
              Expanded(
                child: _row(
                  'Listing',
                  _item.isListed
                      ? 'Listed · €${_item.sellingPrice?.toStringAsFixed(2) ?? ''}'
                      : 'Private (not listed)',
                ),
              ),
              if (_item.status != 'sold')
                _item.isListed
                    ? OutlinedButton(
                        onPressed: _openListingSheet,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('Unlist'),
                      )
                    : FilledButton(
                        onPressed: _openListingSheet,
                        style: FilledButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: const Text('List'),
                      ),
            ],
          ),
          if (_item.isListed && _item.sellingPrice != null) ...[
            _row('Selling Price',
                '€${_item.sellingPrice!.toStringAsFixed(2)}'),
            _row(
              'Margin',
              () {
                final m = _item.sellingPrice! - _item.costPrice;
                final p = _item.costPrice > 0
                    ? m / _item.costPrice * 100
                    : 0.0;
                return '${m >= 0 ? '+' : ''}€${m.toStringAsFixed(2)} (${p.toStringAsFixed(1)}%)';
              }(),
            ),
          ],

          _sectionLabel('Other'),
          _row('Status', _item.status),
          _row('Barcode', _item.barcode),

          if (_item.notes.isNotEmpty) ...[
            _sectionLabel('Notes'),
            Text(_item.notes),
          ],

          if (_item.status != 'sold') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _recordSale,
                icon: const Icon(Icons.sell_outlined, size: 18),
                label: const Text('Record Sale'),
                style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade700),
              ),
            ),
          ],

          const SizedBox(height: 24),
          _buildMovementTimeline(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Full-screen image gallery ─────────────────────────────────────────────────

class _ImageGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _ImageGalleryPage({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<_ImageGalleryPage> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_current + 1} / ${widget.imageUrls.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, index) => InteractiveViewer(
          child: Center(
            child: Image.network(
              widget.imageUrls[index],
              fit: BoxFit.contain,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
              errorBuilder: (_, _, _) => const Center(
                child: Icon(Icons.broken_image, color: Colors.white, size: 80),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
