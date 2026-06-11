import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/location.dart';
import '../../models/seller.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/seller_repository.dart';
import 'add_edit_location_page.dart';
import 'location_detail_page.dart';

// ── Type helpers ──────────────────────────────────────────────────────────────

IconData _iconForType(String type) => switch (type) {
      'safe' => Icons.lock_outlined,
      'cabinet' => Icons.grid_view_outlined,
      'shelf' => Icons.view_list_outlined,
      'drawer' => Icons.inbox_outlined,
      'tray' => Icons.inbox_outlined,
      'box' => Icons.inventory_2_outlined,
      'section' => Icons.table_rows_outlined,
      'slot' => Icons.radio_button_unchecked,
      _ => Icons.place_outlined,
    };

// ── Page ──────────────────────────────────────────────────────────────────────

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  final _repo = LocationRepository();
  final _sellerRepo = SellerRepository();

  List<Location> _flat = [];
  List<Location> _storageRoots = [];
  List<Location> _workflowNodes = [];
  Map<String, int> _itemCounts = {};
  bool _loading = true;

  // Owner-only seller filter.
  List<Seller> _sellers = [];
  String? _selectedSellerId;

  bool get _isOwner => UserProfileService.instance.isOwner;

  String? get _effectiveSellerId =>
      _isOwner ? _selectedSellerId : UserProfileService.instance.sellerId;

  @override
  void initState() {
    super.initState();
    if (_isOwner) _loadSellers();
    _load();
  }

  Future<void> _loadSellers() async {
    try {
      final sellers = await _sellerRepo.getSellers();
      if (mounted) setState(() => _sellers = sellers);
    } catch (_) {}
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _repo.getLocationsFlat(_effectiveSellerId),
        _repo.getItemCountsByLocation(sellerId: _effectiveSellerId),
      ]);
      final flat = results[0] as List<Location>;
      final counts = results[1] as Map<String, int>;
      final tree = _buildTree(flat, null);

      if (mounted) {
        setState(() {
          _flat = flat;
          _storageRoots = tree.where((l) => !l.isStatusZone).toList();
          _workflowNodes = flat.where((l) => l.isStatusZone).toList();
          _itemCounts = counts;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('LocationsPage load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Location> _buildTree(List<Location> all, String? parentId) {
    return all
        .where((l) => l.parentId == parentId)
        .map((l) => l.copyWith(children: _buildTree(all, l.id)))
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAdd({String? parentId}) async {
    final sellerId = _effectiveSellerId ??
        UserProfileService.instance.effectiveSellerId;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditLocationPage(
          sellerId: sellerId,
          existingFlat: _flat,
          parentId: parentId,
        ),
      ),
    );
    if (result == true) _load();
  }

  Future<void> _openEdit(Location loc) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditLocationPage(
          sellerId: loc.sellerId,
          existingFlat: _flat,
          location: loc,
        ),
      ),
    );
    if (result == true) _load();
  }

  Future<void> _openDetail(Location loc) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationDetailPage(location: loc, flat: _flat),
      ),
    );
    _load();
  }

  Future<void> _confirmDelete(Location loc) async {
    final children = _flat.where((l) => l.parentId == loc.id).toList();
    final itemCount = _itemCounts[loc.id] ?? 0;

    if (children.isNotEmpty || itemCount > 0) {
      final reason = children.isNotEmpty
          ? 'It has ${children.length} child location(s).'
          : 'It has $itemCount item(s) assigned to it.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot delete "${loc.name}". $reason')),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text('Delete "${loc.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    try {
      await _repo.deleteLocation(loc.id!);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  void _showNodeActions(Location loc) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add child location'),
              onTap: () {
                Navigator.pop(ctx);
                _openAdd(parentId: loc.id);
              },
            ),
            if (!loc.isStatusZone) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(ctx);
                  _openEdit(loc);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(ctx).colorScheme.error),
                title: Text('Delete',
                    style:
                        TextStyle(color: Theme.of(ctx).colorScheme.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _confirmDelete(loc);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAdd(),
            tooltip: 'Add top-level location',
          ),
        ],
        bottom: _isOwner && _sellers.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text('Seller:',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<String?>(
                          value: _selectedSellerId,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [
                            const DropdownMenuItem(
                                value: null, child: Text('All sellers')),
                            ..._sellers.map((s) => DropdownMenuItem(
                                  value: s.id,
                                  child: Text(s.name,
                                      overflow: TextOverflow.ellipsis),
                                )),
                          ],
                          onChanged: (v) {
                            setState(() => _selectedSellerId = v);
                            _load();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  // Workflow section
                  if (_workflowNodes.isNotEmpty) ...[
                    _SectionHeader('Workflow',
                        subtitle: 'Status zones — read-only'),
                    ..._workflowNodes.map((loc) => _LocationTile(
                          location: loc,
                          depth: 0,
                          itemCounts: _itemCounts,
                          onTap: _openDetail,
                          onLongPress: _showNodeActions,
                          readOnly: true,
                        )),
                  ],

                  // Storage section
                  _SectionHeader('Storage',
                      subtitle: _storageRoots.isEmpty
                          ? 'No locations yet — tap + to add'
                          : null),
                  ..._storageRoots.map((root) => _LocationTile(
                        location: root,
                        depth: 0,
                        itemCounts: _itemCounts,
                        onTap: _openDetail,
                        onLongPress: _showNodeActions,
                        readOnly: false,
                      )),
                ],
              ),
            ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionHeader(this.title, {this.subtitle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.surfaceContainerLow,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: cs.primary,
              letterSpacing: 0.5,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}

// ── Recursive tree tile ───────────────────────────────────────────────────────

class _LocationTile extends StatefulWidget {
  final Location location;
  final int depth;
  final Map<String, int> itemCounts;
  final void Function(Location) onTap;
  final void Function(Location) onLongPress;
  final bool readOnly;

  const _LocationTile({
    required this.location,
    required this.depth,
    required this.itemCounts,
    required this.onTap,
    required this.onLongPress,
    required this.readOnly,
  });

  @override
  State<_LocationTile> createState() => _LocationTileState();
}

class _LocationTileState extends State<_LocationTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = widget.location;
    final cs = Theme.of(context).colorScheme;
    final hasChildren = loc.children.isNotEmpty;
    final itemCount = widget.itemCounts[loc.id] ?? 0;
    final indent = widget.depth * 20.0;

    return Column(
      children: [
        GestureDetector(
          onLongPress: () => widget.onLongPress(loc),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 16 + indent, right: 8),
            leading: Icon(
              _iconForType(loc.type),
              size: 20,
              color: loc.isStatusZone
                  ? cs.secondary
                  : cs.onSurfaceVariant,
            ),
            title: Text(loc.name, style: const TextStyle(fontSize: 14)),
            subtitle: loc.code.isNotEmpty
                ? Text(
                    loc.code,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: cs.onSurfaceVariant,
                    ),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (itemCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$itemCount',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                if (hasChildren) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
              ],
            ),
            onTap: () => widget.onTap(loc),
          ),
        ),
        if (hasChildren && _expanded)
          ...loc.children.map((child) => _LocationTile(
                location: child,
                depth: widget.depth + 1,
                itemCounts: widget.itemCounts,
                onTap: widget.onTap,
                onLongPress: widget.onLongPress,
                readOnly: widget.readOnly,
              )),
        if (widget.depth == 0)
          const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
