import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/inventory_item.dart';
import '../../models/item_movement.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/order_repository.dart';
import '../../theme/app_theme.dart';
import 'edit_inventory_page.dart';
import 'listing_sheet.dart';
import 'widgets/item_photo_manager.dart';
import 'widgets/price_field.dart';
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

  late InventoryItem _item;
  List<PhotoItem> _photoItems = [];
  bool _uploadingImage = false;
  bool _deleting = false;

  List<ItemMovement> _movements = [];
  String _locationBreadcrumb = '';
  bool _movementsLoading = false;

  /// Seller's commission rate (NULL / no seller = 0%). Null while loading.
  double? _commissionRate;

  /// Actual sale from the order, for sold items.
  ({String orderNumber, double soldFor, double received})? _sale;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _photoItems = _item.imageUrls.map(PhotoItem.existing).toList();
    _loadLocationAndMovements();
    _loadCommissionRate();
    _loadSale();
  }

  Future<void> _loadCommissionRate() async {
    final r = await loadSellerCommissionRate(_item.sellerId);
    if (mounted) setState(() => _commissionRate = r.rate);
  }

  Future<void> _loadSale() async {
    if (_item.id == null || _item.status != 'sold') return;
    try {
      final sale = await OrderRepository().getItemSale(_item.id!);
      if (mounted) setState(() => _sale = sale);
    } catch (e) {
      debugPrint('Sale lookup failed: $e');
    }
  }

  Future<void> _loadLocationAndMovements() async {
    if (_item.id == null) return;
    setState(() => _movementsLoading = true);
    try {
      // Breadcrumb is resolved across all visible locations (RLS scopes them)
      // — scoping to the item's seller left the raw id when the item has no
      // seller or the location belongs to another seller.
      final futures = <Future>[
        _movementRepo.getMovementsForItem(_item.id!),
        if (_item.locationId != null)
          _locationRepo.getBreadcrumb(_item.locationId!),
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
    _loadSale();

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

  // ── Photo sync (upload new picks, persist order/removals immediately) ────────

  Future<void> _syncPhotos(List<PhotoItem> updated) async {
    if (_item.id == null) return;
    setState(() => _uploadingImage = true);
    try {
      final finalUrls = <String>[];
      for (final photo in updated) {
        if (photo.isExisting) {
          finalUrls.add(photo.url!);
        } else {
          final url = await _repository.uploadImage(
              _item.id!, photo.bytes!, photo.file!.name);
          finalUrls.add(url);
        }
      }
      await _repository.updateItemImages(_item.id!, finalUrls);
      if (mounted) {
        setState(() {
          _item = _item.copyWith(imageUrls: finalUrls);
          _photoItems = finalUrls.map(PhotoItem.existing).toList();
          _uploadingImage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo update failed: $e')),
        );
        setState(() => _uploadingImage = false);
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

  static String _eur(double v) =>
      '${v < 0 ? '−' : ''}€${v.abs().toStringAsFixed(2)}';

  /// Cost and profit — owner/seller-only info, never shown to buyers.
  /// Sold items show the actual sale from the order; unsold items an
  /// estimate from price × commission rate.
  Widget _buildPrivateCard() {
    final cost = _item.costPrice;
    final hasCost = cost > 0;
    final sale = _sale;
    final List<Widget> rows;

    if (sale != null) {
      rows = [
        _row('Sold for',
            '${_eur(sale.soldFor)}'
                '${sale.orderNumber.isNotEmpty ? '  (${sale.orderNumber})' : ''}'),
        _row('You received', _eur(sale.received)),
        _row('Cost price', hasCost ? _eur(cost) : ''),
        if (hasCost) _row('Profit', _eur(sale.received - cost)),
      ];
    } else {
      final price = _item.sellingPrice;
      final rate = _commissionRate;
      final payout = price != null && price > 0 && rate != null
          ? payoutAfterCommission(price, rate)
          : null;
      rows = [
        _row('Cost price', hasCost ? _eur(cost) : ''),
        if (payout != null) _row('You receive', _eur(payout)),
        if (payout != null && hasCost)
          _row('Profit after commission', _eur(payout - cost)),
      ];
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.raised,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_outline, size: 16, color: AppColors.muted),
              SizedBox(width: 6),
              Text(
                'Private — only you see this',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          ...rows,
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
        ItemPhotoManager(
          photos: _photoItems,
          onChanged: _syncPhotos,
          enabled: !_uploadingImage,
          onPhotoTap: _item.imageUrls.isNotEmpty ? _openGallery : null,
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
                    : _movementsLoading
                        ? 'Loading…'
                        : 'Unknown location',
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
          if (_item.isListed && _item.sellingPrice != null)
            _row('Price', '€${_item.sellingPrice!.toStringAsFixed(2)}'),

          const SizedBox(height: 16),
          _buildPrivateCard(),

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
