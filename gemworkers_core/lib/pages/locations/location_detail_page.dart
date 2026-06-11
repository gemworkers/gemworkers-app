import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/inventory_item.dart';
import '../../models/location.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/location_repository.dart';
import '../locations/location_picker_dialog.dart';
import 'add_edit_location_page.dart';

class LocationDetailPage extends StatefulWidget {
  final Location location;
  final List<Location> flat;

  const LocationDetailPage({
    super.key,
    required this.location,
    required this.flat,
  });

  @override
  State<LocationDetailPage> createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final _inventoryRepo = InventoryRepository();
  final _locationRepo = LocationRepository();
  final _movementRepo = ItemMovementRepository();

  late Location _location;
  List<InventoryItem> _items = [];
  List<Location> _slotChildren = [];
  Map<String, InventoryItem> _itemBySlot = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final slotChildren = widget.flat
          .where((l) =>
              l.parentId == _location.id && l.type == 'slot')
          .toList();

      final allSlotIds = slotChildren
          .where((l) => l.id != null)
          .map((l) => l.id!)
          .toList();

      final fetchIds = [
        if (_location.id != null) _location.id!,
        ...allSlotIds,
      ];

      final items = fetchIds.isNotEmpty
          ? await _inventoryRepo.getItemsByLocations(fetchIds)
          : <InventoryItem>[];

      final itemBySlot = <String, InventoryItem>{};
      final directItems = <InventoryItem>[];
      for (final item in items) {
        if (item.locationId == _location.id) {
          directItems.add(item);
        } else if (item.locationId != null) {
          itemBySlot[item.locationId!] = item;
        }
      }

      if (mounted) {
        setState(() {
          _items = directItems;
          _slotChildren = slotChildren;
          _itemBySlot = itemBySlot;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('LocationDetailPage load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Breadcrumb from flat list ─────────────────────────────────────────────

  String get _breadcrumb {
    final path = <String>[];
    String? current = _location.id;
    while (current != null) {
      try {
        final loc = widget.flat.firstWhere((l) => l.id == current);
        path.add(loc.name);
        current = loc.parentId;
      } catch (_) {
        break;
      }
    }
    return path.reversed.join(' › ');
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _openEdit() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditLocationPage(
          sellerId: _location.sellerId,
          existingFlat: widget.flat,
          location: _location,
        ),
      ),
    );
    if (result == true && mounted) {
      // Reload the location from DB to get updated fields.
      try {
        final flat = await _locationRepo.getLocationsFlat(_location.sellerId);
        final updated = flat.where((l) => l.id == _location.id).firstOrNull;
        if (updated != null && mounted) {
          setState(() => _location = updated);
        }
      } catch (_) {}
      _load();
    }
  }

  Future<void> _openAddChild() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditLocationPage(
          sellerId: _location.sellerId,
          existingFlat: widget.flat,
          parentId: _location.id,
        ),
      ),
    );
    if (result == true) _load();
  }

  void _showQR() {
    final data = _location.code.isNotEmpty
        ? _location.code
        : (_location.id ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_location.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 220,
              eyeStyle:
                  const QrEyeStyle(eyeShape: QrEyeShape.square),
              dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square),
            ),
            const SizedBox(height: 8),
            Text(
              _location.code.isNotEmpty ? _location.code : 'No code',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
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

  Future<void> _moveAllItems() async {
    if (_items.isEmpty) return;
    final picked = await showLocationPicker(
      context,
      sellerId: _location.sellerId,
      currentLocationId: _location.id,
    );
    if (picked == null || !mounted) return;

    try {
      final itemIds = _items.map((i) => i.id!).toList();
      await _inventoryRepo.batchSetLocation(itemIds, picked.id);

      for (final item in _items) {
        await _movementRepo.recordMovement(
          inventoryItemId: item.id!,
          fromLocationId: _location.id,
          toLocationId: picked.id,
          reason: 'Bulk move',
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Moved ${_items.length} item(s) to ${picked.name}.'),
          ),
        );
        _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Move failed: $e')));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final showSlotGrid = (_location.slotCount ?? 0) > 0 &&
        _slotChildren.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_location.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_outlined),
            onPressed: _showQR,
            tooltip: 'QR Code',
          ),
          if (!_location.isStatusZone)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: _openEdit,
              tooltip: 'Edit',
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ── Breadcrumb ────────────────────────────────────────────
                if (_breadcrumb.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _breadcrumb,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),

                // ── Code card ─────────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _location.code.isNotEmpty
                              ? _location.code
                              : 'No code',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: cs.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Text(
                        _location.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onPrimaryContainer
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                if (_location.managerNote.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _location.managerNote,
                    style: TextStyle(
                        fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                ],

                // ── Action buttons ────────────────────────────────────────
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (!_location.isStatusZone)
                      OutlinedButton.icon(
                        onPressed: _openAddChild,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add child'),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12)),
                      ),
                    if (!_location.isStatusZone) const SizedBox(width: 8),
                    if (_items.isNotEmpty)
                      OutlinedButton.icon(
                        onPressed: _moveAllItems,
                        icon: const Icon(Icons.move_down_outlined,
                            size: 16),
                        label: Text('Move all (${_items.length})'),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12)),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Slot grid ─────────────────────────────────────────────
                if (showSlotGrid) ...[
                  _sectionLabel('Slots', cs),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _slotChildren.length,
                    itemBuilder: (_, i) {
                      final slot = _slotChildren[i];
                      final occupant = _itemBySlot[slot.id];
                      return _SlotCard(
                          slot: slot, occupant: occupant);
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Items at this location ────────────────────────────────
                _sectionLabel(
                  'Items here (${_items.length})',
                  cs,
                ),
                if (_items.isEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'No items assigned to this location.',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  )
                else
                  ..._items.map((item) => _ItemTile(item)),

                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _sectionLabel(String title, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.primary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Slot card ─────────────────────────────────────────────────────────────────

class _SlotCard extends StatelessWidget {
  final Location slot;
  final InventoryItem? occupant;

  const _SlotCard({required this.slot, this.occupant});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final occupied = occupant != null;

    return Container(
      decoration: BoxDecoration(
        color: occupied
            ? cs.primaryContainer
            : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: occupied
              ? cs.primary.withValues(alpha: 0.4)
              : cs.outline.withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            slot.name,
            style: TextStyle(
              fontSize: 10,
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            occupied ? occupant!.title : 'empty',
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  occupied ? FontWeight.w600 : FontWeight.normal,
              color: occupied
                  ? cs.onPrimaryContainer
                  : cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Item tile ─────────────────────────────────────────────────────────────────

class _ItemTile extends StatelessWidget {
  final InventoryItem item;
  const _ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: item.imageUrls.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.imageUrls.first,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.diamond_outlined, size: 28),
              ),
            )
          : const Icon(Icons.diamond_outlined, size: 28),
      title: Text(item.title,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis),
      subtitle: Text(
        '${item.sku}  ·  ${item.weightValue}${item.weightUnit}',
        style: const TextStyle(fontSize: 11),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
