import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/location.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/item_movement_repository.dart';
import '../../repositories/location_repository.dart';
import '../../theme/app_theme.dart';
import 'add_item_type_picker_page.dart';
import 'edit_inventory_page.dart';
import 'inventory_detail_page.dart';
import 'listing_sheet.dart';
import 'record_sale_sheet.dart';
import 'widgets/cascading_location_picker.dart';

// ── Sort options ──────────────────────────────────────────────────────────────

enum _SortOrder {
  newestFirst('Newest first'),
  oldestFirst('Oldest first'),
  nameAZ('Name A → Z'),
  priceLow('Price: low → high'),
  priceHigh('Price: high → low');

  final String label;
  const _SortOrder(this.label);
}

// ── Listing tab ───────────────────────────────────────────────────────────────

enum _ListingTab {
  all('All'),
  active('Active'),
  draft('Draft'),
  reserved('Reserved'),
  sold('Sold');

  final String label;
  const _ListingTab(this.label);
}

/// The tab (and status chip) an item belongs to. Each item maps to exactly
/// one non-All tab so tab counts add up to All.
_ListingTab _listingStatus(InventoryItem item) {
  if (item.status == 'sold') return _ListingTab.sold;
  if (item.status == 'reserved') return _ListingTab.reserved;
  if (item.isListed && item.status == 'available') return _ListingTab.active;
  return _ListingTab.draft;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with SingleTickerProviderStateMixin {
  final _repository = InventoryRepository();
  final _locationRepo = LocationRepository();
  final _movementRepo = ItemMovementRepository();
  final _searchController = TextEditingController();
  late final TabController _tabController;

  List<InventoryItem> _all = [];
  List<Location> _allLocations = [];
  bool _loading = true;

  // ── Filter & sort state ───────────────────────────────────────────────────

  String _query = '';
  _ListingTab _selectedTab = _ListingTab.all;
  String? _gemTypeFilter;
  Location? _locationFilter;
  Set<String> _locationDescendantIds = {};
  double _maxPrice = 10000;
  RangeValues _priceRange = const RangeValues(0, 10000);
  bool _priceRangeInitialized = false;
  _SortOrder _sortOrder = _SortOrder.newestFirst;

  bool _bannerDismissed = false;
  bool _showUnassignedOnly = false;

  // ── Selection state ───────────────────────────────────────────────────────

  bool _selectionMode = false;
  Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _ListingTab.values.length, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(
              () => _selectedTab = _ListingTab.values[_tabController.index]);
        }
      });
    _searchController.addListener(_onSearchChanged);
    _loadItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _query = _searchController.text.toLowerCase().trim());
  }

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      final svc = UserProfileService.instance;
      final results = await Future.wait([
        _repository.getItems(),
        _locationRepo.getLocationsFlat(svc.effectiveSellerId),
      ]);
      var items = results[0] as List<InventoryItem>;
      final locs = results[1] as List<Location>;
      if (svc.shouldFilterBySeller) {
        items = items.where((e) => e.sellerId == svc.sellerId).toList();
      }
      if (mounted) {
        setState(() {
          _all = items;
          _allLocations = locs;
          if (!_priceRangeInitialized && items.isNotEmpty) {
            final max =
                items.map((e) => e.sellingPrice ?? 0).reduce((a, b) => a > b ? a : b);
            _maxPrice = max < 1 ? 10000 : max;
            _priceRange = RangeValues(0, _maxPrice);
            _priceRangeInitialized = true;
          }
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _applyLocationFilter(Location? loc) async {
    if (loc == null) {
      setState(() {
        _locationFilter = null;
        _locationDescendantIds = {};
      });
      return;
    }
    final ids = await _locationRepo.getDescendantIds(
        loc.id!, UserProfileService.instance.effectiveSellerId);
    if (mounted) {
      setState(() {
        _locationFilter = loc;
        _locationDescendantIds = ids.toSet();
      });
    }
  }

  // ── Location breadcrumb helper ─────────────────────────────────────────────

  String? _locationLabel(String? locationId) {
    if (locationId == null) return null;
    final path = <String>[];
    String? current = locationId;
    while (current != null) {
      final loc = _allLocations.where((l) => l.id == current).firstOrNull;
      if (loc == null) break;
      path.add(loc.name);
      current = loc.parentId;
    }
    return path.reversed.join(' › ');
  }

  // ── Selection ─────────────────────────────────────────────────────────────

  void _enterSelectionMode({Set<String>? preSelected}) {
    setState(() {
      _selectionMode = true;
      _selectedIds = preSelected ?? {};
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedIds = {};
      _showUnassignedOnly = false;
    });
  }

  void _toggleItem(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds = {..._selectedIds}..remove(id);
      } else {
        _selectedIds = {..._selectedIds, id};
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedIds = _displayItems
          .where((i) => i.id != null)
          .map((i) => i.id!)
          .toSet();
    });
  }

  // ── Bulk assign ───────────────────────────────────────────────────────────

  void _showBulkAssignSheet() {
    final svc = UserProfileService.instance;
    final count = _selectedIds.length;
    String? pickedId;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assign location to $count item${count == 1 ? '' : 's'}',
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CascadingLocationPicker(
                sellerId: svc.effectiveSellerId,
                onChanged: (id) => setSheet(() => pickedId = id),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: pickedId != null
                      ? () {
                          Navigator.pop(ctx);
                          _applyBulkAssign(pickedId!);
                        }
                      : null,
                  child: Text(
                      'Assign to $count item${count == 1 ? '' : 's'}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _applyBulkAssign(String locationId) async {
    final affected = _all
        .where((i) => i.id != null && _selectedIds.contains(i.id))
        .toList();
    final count = affected.length;

    try {
      await _repository.batchSetLocation(_selectedIds.toList(), locationId);

      for (final item in affected) {
        if (item.locationId != locationId) {
          await _movementRepo.recordMovement(
            inventoryItemId: item.id!,
            fromLocationId: item.locationId,
            toLocationId: locationId,
            reason: 'Bulk assign',
          );
        }
      }

      // Reload so _allLocations is fresh (may include newly created locations).
      await _loadItems();

      if (!mounted) return;

      final locName = _allLocations
              .where((l) => l.id == locationId)
              .firstOrNull
              ?.name ??
          'location';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '$count item${count == 1 ? '' : 's'} assigned to $locName'),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assignment failed: $e')),
        );
      }
    }

    if (mounted) _exitSelectionMode();
  }

  // ── Record sale ───────────────────────────────────────────────────────────

  Future<void> _showRecordSaleSheet() => _recordSale(_all
      .where((i) =>
          i.id != null && _selectedIds.contains(i.id) && i.status != 'sold')
      .toList());

  Future<void> _recordSale(List<InventoryItem> sellable) async {
    if (sellable.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No sellable items selected')),
      );
      return;
    }

    final result = await showRecordSaleSheet(context, sellable);
    if (result == null || !mounted) return;

    _exitSelectionMode();
    await _loadItems();

    if (mounted) {
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
  }

  // ── Listing actions ───────────────────────────────────────────────────────

  Future<void> _openListingSheet(InventoryItem item) async {
    final result = await showListingSheet(context, item);
    if (result == null || !mounted) return;
    _loadItems();
    if (result.listed && result.price != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Item listed at €${result.price!.toStringAsFixed(2)}')));
    } else if (!result.listed) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from marketplace')));
    }
  }

  // ── Computed display list ─────────────────────────────────────────────────

  List<InventoryItem> get _displayItems => _applySorting(_filtered);

  List<InventoryItem> get _filtered {
    return _all.where((item) {
      if (_showUnassignedOnly && item.locationId != null) return false;
      if (_selectedTab != _ListingTab.all &&
          _listingStatus(item) != _selectedTab) {
        return false;
      }
      if (_query.isNotEmpty) {
        final hit = item.title.toLowerCase().contains(_query) ||
            item.gemType.toLowerCase().contains(_query) ||
            item.sku.toLowerCase().contains(_query) ||
            item.variety.toLowerCase().contains(_query) ||
            item.originCountry.toLowerCase().contains(_query);
        if (!hit) return false;
      }
      if (_gemTypeFilter != null && _gemTypeFilter!.isNotEmpty) {
        if (!item.gemType
            .toLowerCase()
            .contains(_gemTypeFilter!.toLowerCase())) {
          return false;
        }
      }
      if (_locationFilter != null) {
        if (!_locationDescendantIds.contains(item.locationId ?? '')) {
          return false;
        }
      }
      if ((item.sellingPrice ?? 0) < _priceRange.start ||
          (item.sellingPrice ?? 0) > _priceRange.end) {
        return false;
      }
      return true;
    }).toList();
  }

  List<InventoryItem> _applySorting(List<InventoryItem> items) {
    final sorted = [...items];
    switch (_sortOrder) {
      case _SortOrder.newestFirst:
        sorted.sort((a, b) => (b.createdAt ?? DateTime(0))
            .compareTo(a.createdAt ?? DateTime(0)));
      case _SortOrder.oldestFirst:
        sorted.sort((a, b) => (a.createdAt ?? DateTime(0))
            .compareTo(b.createdAt ?? DateTime(0)));
      case _SortOrder.nameAZ:
        sorted.sort((a, b) => a.title.compareTo(b.title));
      case _SortOrder.priceLow:
        sorted.sort((a, b) =>
            (a.sellingPrice ?? 0).compareTo(b.sellingPrice ?? 0));
      case _SortOrder.priceHigh:
        sorted.sort((a, b) =>
            (b.sellingPrice ?? 0).compareTo(a.sellingPrice ?? 0));
    }
    return sorted;
  }

  int get _unassignedCount =>
      _all.where((e) => e.locationId == null).length;

  bool get _hasFilters =>
      (_gemTypeFilter?.isNotEmpty ?? false) ||
      _locationFilter != null ||
      _showUnassignedOnly ||
      _priceRange.start > 0 ||
      _priceRange.end < _maxPrice;

  void _clearFilters() {
    setState(() {
      _gemTypeFilter = null;
      _locationFilter = null;
      _locationDescendantIds = {};
      _priceRange = RangeValues(0, _maxPrice);
      _showUnassignedOnly = false;
    });
  }

  // ── Gem type chips ────────────────────────────────────────────────────────

  List<String> get _gemTypes => _all
      .map((e) => e.gemType)
      .where((g) => g.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get _availableCount => _all.where((e) => e.status == 'available').length;

  double get _listedValue => _all
      .where((e) => _listingStatus(e) == _ListingTab.active)
      .fold(0, (sum, e) => sum + (e.sellingPrice ?? 0));

  // ── Filter bottom sheet ───────────────────────────────────────────────────

  void _showFilterSheet() {
    final gemController = TextEditingController(text: _gemTypeFilter ?? '');
    Location? tempLocation = _locationFilter;
    RangeValues tempPrice = _priceRange;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Filter', style: Theme.of(ctx).textTheme.titleMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setSheet(() {
                      gemController.clear();
                      tempLocation = null;
                      tempPrice = RangeValues(0, _maxPrice);
                    }),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: gemController,
                decoration: const InputDecoration(
                  labelText: 'Gem Type',
                  hintText: 'e.g. Ruby, Sapphire…',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              if (_allLocations.isNotEmpty)
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButton<Location?>(
                    value: tempLocation,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('All locations')),
                      ..._allLocations.map((l) => DropdownMenuItem(
                            value: l,
                            child:
                                Text(l.name, overflow: TextOverflow.ellipsis),
                          )),
                    ],
                    onChanged: (v) => setSheet(() => tempLocation = v),
                  ),
                ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sale Price'),
                  Text(
                    '€${tempPrice.start.toStringAsFixed(0)} – €${tempPrice.end.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              RangeSlider(
                values: tempPrice,
                min: 0,
                max: _maxPrice,
                onChanged: (v) => setSheet(() => tempPrice = v),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      _gemTypeFilter = gemController.text.trim().isEmpty
                          ? null
                          : gemController.text.trim();
                      _priceRange = tempPrice;
                    });
                    _applyLocationFilter(tempLocation);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(gemController.dispose);
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddItemTypePickerPage()),
    );
    if (added == true) _loadItems();
  }

  Future<void> _openDetail(InventoryItem item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InventoryDetailPage(item: item)),
    );
    _loadItems();
  }

  Future<void> _openEdit(InventoryItem item) async {
    final updated = await Navigator.push<InventoryItem>(
      context,
      MaterialPageRoute(builder: (_) => EditInventoryPage(item: item)),
    );
    if (updated != null) _loadItems();
  }

  Map<_ListingTab, int> get _tabCounts {
    final counts = {for (final t in _ListingTab.values) t: 0};
    for (final item in _all) {
      counts[_listingStatus(item)] = counts[_listingStatus(item)]! + 1;
    }
    counts[_ListingTab.all] = _all.length;
    return counts;
  }

  void _onRowAction(_RowAction action, InventoryItem item) {
    switch (action) {
      case _RowAction.list:
      case _RowAction.unlist:
        _openListingSheet(item);
      case _RowAction.recordSale:
        _recordSale([item]);
      case _RowAction.select:
        if (item.id != null) _enterSelectionMode(preSelected: {item.id!});
      case _RowAction.details:
        _openDetail(item);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final display = _displayItems;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final gutter = wide ? 32.0 : 16.0;

    return Scaffold(
      bottomNavigationBar: _selectionMode ? _buildSelectionBar() : null,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadItems,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.fromLTRB(gutter, wide ? 28 : 20, gutter, 16),
                    sliver: SliverToBoxAdapter(child: _buildTop(wide)),
                  ),
                  if (display.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        tab: _selectedTab,
                        query: _query,
                        hasFilters: _hasFilters,
                        onClear: _clearFilters,
                        onAdd: _openAdd,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 32),
                      sliver: _buildList(display, wide),
                    ),
                ],
              ),
            ),
    );
  }

  /// Header, tabs, search + controls, banners.
  Widget _buildTop(bool wide) {
    final textTheme = Theme.of(context).textTheme;
    final counts = _tabCounts;
    final summary = _selectionMode
        ? '${_selectedIds.length} selected'
        : '${_all.length} items · $_availableCount available · '
            '€${_formatValue(_listedValue)} listed value';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Listings',
                      style: textTheme.headlineLarge?.copyWith(
                          fontSize: wide ? 40 : 32, height: 1.1)),
                  if (_all.isNotEmpty || _selectionMode) ...[
                    const SizedBox(height: 2),
                    Text(summary,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: AppColors.muted)),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add, size: 20),
              label: Text(wide ? 'Add a listing' : 'Add'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── Status tabs ──
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.only(right: 28),
          tabs: [
            for (final t in _ListingTab.values)
              Tab(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: t.label),
                  TextSpan(
                    text: '  ${counts[t]}',
                    style: const TextStyle(
                        color: AppColors.muted, fontWeight: FontWeight.w400),
                  ),
                ])),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Search + controls ──
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: wide ? 360 : double.infinity,
              height: 44,
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Search by name, gem type, SKU…',
                  prefixIcon: const Icon(Icons.search,
                      size: 20, color: AppColors.muted),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: _searchController.clear,
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: _pillBorder(AppColors.borderStrong),
                  enabledBorder: _pillBorder(AppColors.borderStrong),
                  focusedBorder: _pillBorder(AppColors.ink, 1.5),
                ),
              ),
            ),
            if (_gemTypes.isNotEmpty) _buildGemPill(),
            _Pill(
              icon: Icons.tune,
              label: 'Filters',
              active: _hasFilters,
              onTap: _showFilterSheet,
            ),
            _buildSortPill(),
            if (_selectionMode)
              _Pill(
                icon: Icons.done_all,
                label: 'Select all',
                onTap: _selectAll,
              ),
            _Pill(
              icon: _selectionMode ? Icons.close : Icons.checklist,
              label: _selectionMode ? 'Done' : 'Select',
              active: _selectionMode,
              onTap: _selectionMode
                  ? _exitSelectionMode
                  : () => _enterSelectionMode(),
            ),
          ],
        ),

        if (_unassignedCount > 0 && !_bannerDismissed) ...[
          const SizedBox(height: 12),
          _UnassignedBanner(
            count: _unassignedCount,
            onAssignNow: () {
              final unassignedIds = _all
                  .where((i) => i.locationId == null && i.id != null)
                  .map((i) => i.id!)
                  .toSet();
              setState(() {
                _bannerDismissed = true;
                _selectionMode = true;
                _selectedIds = unassignedIds;
                _showUnassignedOnly = true;
              });
            },
            onDismiss: () => setState(() => _bannerDismissed = true),
          ),
        ],
        if (_hasFilters) ...[
          const SizedBox(height: 8),
          _FilterBar(
            count: _displayItems.length,
            total: _all.length,
            onClear: _clearFilters,
          ),
        ],
      ],
    );
  }

  static OutlineInputBorder _pillBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide(color: color, width: width),
      );

  static String _formatValue(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }

  Widget _buildGemPill() {
    return PopupMenuButton<String>(
      tooltip: 'Gem type',
      position: PopupMenuPosition.under,
      onSelected: (g) =>
          setState(() => _gemTypeFilter = g.isEmpty ? null : g),
      itemBuilder: (_) => [
        CheckedPopupMenuItem(
          value: '',
          checked: _gemTypeFilter == null,
          child: const Text('All gems'),
        ),
        ..._gemTypes.map((g) => CheckedPopupMenuItem(
              value: g,
              checked: _gemTypeFilter == g,
              child: Text(g),
            )),
      ],
      child: _Pill(
        icon: Icons.diamond_outlined,
        label: _gemTypeFilter ?? 'All gems',
        active: _gemTypeFilter != null,
        trailingCaret: true,
      ),
    );
  }

  Widget _buildSortPill() {
    return PopupMenuButton<_SortOrder>(
      tooltip: 'Sort',
      position: PopupMenuPosition.under,
      initialValue: _sortOrder,
      onSelected: (order) => setState(() => _sortOrder = order),
      itemBuilder: (_) => _SortOrder.values
          .map((o) => CheckedPopupMenuItem(
                value: o,
                checked: _sortOrder == o,
                child: Text(o.label),
              ))
          .toList(),
      child: _Pill(
        icon: Icons.sort,
        label: _sortOrder.label,
        trailingCaret: true,
      ),
    );
  }

  /// The white card holding the rows (header row on wide screens).
  Widget _buildList(List<InventoryItem> display, bool wide) {
    final headerOffset = wide ? 1 : 0;
    final allSelected = display.isNotEmpty &&
        display.every((i) => i.id != null && _selectedIds.contains(i.id));

    return DecoratedSliver(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      sliver: SliverList.builder(
        itemCount: display.length + headerOffset,
        itemBuilder: (_, index) {
          if (wide && index == 0) {
            return _HeaderRow(
              selectionMode: _selectionMode,
              allSelected: allSelected,
              onToggleAll: () => allSelected
                  ? setState(() => _selectedIds = {})
                  : _selectAll(),
            );
          }
          final i = index - headerOffset;
          final item = display[i];
          final isSelected =
              item.id != null && _selectedIds.contains(item.id);
          return _ListingRow(
            item,
            wide: wide,
            isFirst: i == 0 && !wide,
            isLast: i == display.length - 1,
            locationLabel: _locationLabel(item.locationId),
            selectionMode: _selectionMode,
            isSelected: isSelected,
            onToggleSelect:
                item.id != null ? () => _toggleItem(item.id!) : null,
            onTap: _openDetail,
            onEdit: _openEdit,
            onAction: _onRowAction,
          );
        },
      ),
    );
  }

  Widget _buildSelectionBar() {
    final count = _selectedIds.length;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Text(
                '$count item${count == 1 ? '' : 's'} selected',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              TextButton(
                onPressed: _exitSelectionMode,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: count > 0 ? _showBulkAssignSheet : null,
                icon: const Icon(Icons.location_on_outlined, size: 18),
                label: const Text('Assign Location'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: count > 0 ? _showRecordSaleSheet : null,
                icon: const Icon(Icons.sell_outlined, size: 18),
                label: const Text('Record Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

enum _RowAction { list, unlist, recordSale, select, details }

/// Outline pill used for the filter/sort/select controls. With [onTap] null
/// it is purely visual (e.g. as a PopupMenuButton child).
class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final bool trailingCaret;
  final VoidCallback? onTap;

  const _Pill({
    required this.icon,
    required this.label,
    this.active = false,
    this.trailingCaret = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: BorderSide(
        color: active ? AppColors.ink : AppColors.borderStrong,
        width: active ? 1.5 : 1,
      ),
    );
    final content = Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.ink),
          const SizedBox(width: 8),
          Text(label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500)),
          if (trailingCaret) ...[
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 18, color: AppColors.muted),
          ],
        ],
      ),
    );
    return Material(
      color: active ? AppColors.raised : AppColors.surface,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, child: content),
    );
  }
}

// Column layout shared by the header row and wide listing rows.
const double _kCheckboxWidth = 40;
const double _kPhotoSize = 64;
const double _kActionsWidth = 128;
const int _kListingFlex = 5;
const int _kSkuFlex = 2;
const int _kPriceFlex = 2;
const int _kStatusFlex = 2;

class _HeaderRow extends StatelessWidget {
  final bool selectionMode;
  final bool allSelected;
  final VoidCallback onToggleAll;

  const _HeaderRow({
    required this.selectionMode,
    required this.allSelected,
    required this.onToggleAll,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.muted,
          letterSpacing: 1.0,
        );
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (selectionMode)
            SizedBox(
              width: _kCheckboxWidth,
              child: Checkbox(
                value: allSelected,
                onChanged: (_) => onToggleAll(),
              ),
            ),
          const SizedBox(width: _kPhotoSize + 16),
          Expanded(flex: _kListingFlex, child: Text('LISTING', style: style)),
          Expanded(flex: _kSkuFlex, child: Text('SKU', style: style)),
          Expanded(flex: _kPriceFlex, child: Text('PRICE', style: style)),
          Expanded(flex: _kStatusFlex, child: Text('STATUS', style: style)),
          const SizedBox(width: _kActionsWidth),
        ],
      ),
    );
  }
}

class _ListingRow extends StatelessWidget {
  final InventoryItem item;
  final bool wide;
  final bool isFirst;
  final bool isLast;
  final String? locationLabel;
  final bool selectionMode;
  final bool isSelected;
  final VoidCallback? onToggleSelect;
  final Future<void> Function(InventoryItem) onTap;
  final Future<void> Function(InventoryItem) onEdit;
  final void Function(_RowAction, InventoryItem) onAction;

  const _ListingRow(
    this.item, {
    required this.wide,
    required this.isFirst,
    required this.isLast,
    required this.locationLabel,
    required this.selectionMode,
    required this.isSelected,
    required this.onToggleSelect,
    required this.onTap,
    required this.onEdit,
    required this.onAction,
  });

  static const _productTypeLabels = {
    'loose_stone': 'Loose stone',
    'specimen': 'Specimen',
    'jewelry': 'Jewelry',
  };

  String get _weightLabel {
    final (value, unit) = switch (item.productType) {
      'specimen' => (item.weightGrams ?? item.weightValue,
          item.weightGrams != null ? item.weightGramsUnit : item.weightUnit),
      'jewelry' => (item.totalWeightGrams ?? item.weightValue,
          item.totalWeightGrams != null
              ? item.totalWeightGramsUnit
              : item.weightUnit),
      _ => (item.weightValue, item.weightUnit),
    };
    if (value <= 0) return '';
    final n = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(2);
    return '$n $unit'.trim();
  }

  String get _meta => [
        _productTypeLabels[item.productType] ?? item.gemType,
        _weightLabel,
        item.originCountry,
      ].where((s) => s.isNotEmpty).join(' · ');

  /// Buyer price only — cost is private and never shown in the list.
  double? get _price =>
      (item.sellingPrice ?? 0) > 0 ? item.sellingPrice : null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final radius = BorderRadius.vertical(
      top: Radius.circular(isFirst ? 16 : 0),
      bottom: Radius.circular(isLast ? 16 : 0),
    );

    final checkbox = SizedBox(
      width: _kCheckboxWidth,
      child: Checkbox(
        value: isSelected,
        onChanged: (_) => onToggleSelect?.call(),
      ),
    );

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyLarge
                    ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            if (item.isUnsortedLot) ...[
              const SizedBox(width: 8),
              _Tag('Lot · ${item.lotRemainingCount ?? 0}'),
            ],
          ],
        ),
        if (_meta.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            _meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium
                ?.copyWith(fontSize: 13, color: AppColors.muted),
          ),
        ],
        const SizedBox(height: 2),
        Text(
          locationLabel?.isNotEmpty == true
              ? locationLabel!
              : item.locationId == null
                  ? 'No location set'
                  : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: item.locationId == null
                ? AppColors.error
                : AppColors.muted,
          ),
        ),
      ],
    );

    final price = _price;
    final priceBlock = price != null
        ? Text('€${price.toStringAsFixed(2)}',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))
        : Text('No price yet',
            style: textTheme.bodySmall?.copyWith(color: AppColors.muted));

    final moreMenu = PopupMenuButton<_RowAction>(
      tooltip: 'More actions',
      icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
      onSelected: (a) => onAction(a, item),
      itemBuilder: (_) => [
        if (item.status != 'sold')
          item.isListed
              ? const PopupMenuItem(
                  value: _RowAction.unlist,
                  child: Text('Remove from marketplace'))
              : const PopupMenuItem(
                  value: _RowAction.list, child: Text('List on marketplace')),
        if (item.status != 'sold')
          const PopupMenuItem(
              value: _RowAction.recordSale, child: Text('Record sale')),
        if (!selectionMode)
          const PopupMenuItem(value: _RowAction.select, child: Text('Select')),
        const PopupMenuItem(
            value: _RowAction.details, child: Text('View details')),
      ],
    );

    final Widget content = wide
        ? Row(
            children: [
              if (selectionMode) checkbox,
              _Photo(item),
              const SizedBox(width: 16),
              Expanded(flex: _kListingFlex, child: titleBlock),
              const SizedBox(width: 12),
              Expanded(
                flex: _kSkuFlex,
                child: Text(item.sku,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
              ),
              Expanded(flex: _kPriceFlex, child: priceBlock),
              Expanded(
                flex: _kStatusFlex,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _StatusChip(_listingStatus(item)),
                ),
              ),
              SizedBox(
                width: _kActionsWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => onEdit(item),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                      ),
                      child: const Text('Edit'),
                    ),
                    moreMenu,
                  ],
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectionMode) checkbox,
              _Photo(item),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleBlock,
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatusChip(_listingStatus(item)),
                        const Spacer(),
                        priceBlock,
                      ],
                    ),
                  ],
                ),
              ),
              moreMenu,
            ],
          );

    return Material(
      color: isSelected
          ? AppColors.raised.withValues(alpha: 0.7)
          : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        hoverColor: AppColors.raised.withValues(alpha: 0.4),
        onTap: selectionMode
            ? () => onToggleSelect?.call()
            : () => onTap(item),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: wide ? 20 : 12, vertical: 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: AppColors.rowDivider)),
          ),
          child: content,
        ),
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  final InventoryItem item;
  const _Photo(this.item);

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.raised,
      child: Center(
        child: Icon(Icons.diamond_outlined, size: 26, color: AppColors.muted),
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: _kPhotoSize,
        height: _kPhotoSize,
        child: item.imageUrls.isNotEmpty
            ? Image.network(
                item.imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              )
            : placeholder,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.raised,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final int count;
  final int total;
  final VoidCallback onClear;

  const _FilterBar({
    required this.count,
    required this.total,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Showing $count of $total items',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 32),
          ),
          child: const Text('Clear filters'),
        ),
      ],
    );
  }
}

class _UnassignedBanner extends StatelessWidget {
  final int count;
  final VoidCallback onAssignNow;
  final VoidCallback onDismiss;

  const _UnassignedBanner({
    required this.count,
    required this.onAssignNow,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
      decoration: BoxDecoration(
        color: AppColors.raised,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off_outlined,
              size: 18, color: AppColors.accent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count item${count == 1 ? '' : 's'} have no physical location',
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
          ),
          TextButton(
            onPressed: onAssignNow,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 32),
            ),
            child: const Text('Assign now'),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDismiss,
            color: AppColors.muted,
            tooltip: 'Dismiss',
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final _ListingTab tab;
  final String query;
  final bool hasFilters;
  final VoidCallback onClear;
  final VoidCallback onAdd;

  const _EmptyState({
    required this.tab,
    required this.query,
    required this.hasFilters,
    required this.onClear,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearch = query.isNotEmpty || hasFilters;
    final message = query.isNotEmpty
        ? 'No listings found for "$query".'
        : hasFilters
            ? 'No listings match your filters.'
            : switch (tab) {
                _ListingTab.all => 'No listings yet.',
                _ListingTab.active => 'No active listings.',
                _ListingTab.draft => 'No draft listings.',
                _ListingTab.reserved => 'No reserved listings.',
                _ListingTab.sold => 'No sold listings.',
              };
    final showAdd = !hasSearch &&
        (tab == _ListingTab.all || tab == _ListingTab.active);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.muted),
          ),
          if (hasSearch) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onClear,
              child: const Text('Clear search & filters'),
            ),
          ],
          if (showAdd) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add a listing'),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _ListingTab status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = switch (status) {
      _ListingTab.active => (
          AppColors.success,
          AppColors.success.withValues(alpha: 0.1)
        ),
      _ListingTab.reserved => (AppColors.accent, AppColors.raised),
      _ => (AppColors.muted, AppColors.raised),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: ShapeDecoration(color: bg, shape: const StadiumBorder()),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
