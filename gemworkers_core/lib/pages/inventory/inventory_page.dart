import 'package:flutter/material.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';
import '../../models/location.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/location_repository.dart';
import 'add_inventory_page.dart';
import 'inventory_detail_page.dart';

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

enum _ListingTab { all, private, listed, sold }

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
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
                items.map((e) => e.salePrice).reduce((a, b) => a > b ? a : b);
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

  // ── Listing actions ───────────────────────────────────────────────────────

  Future<void> _showListDialog(InventoryItem item) async {
    final priceController = TextEditingController(
      text: item.sellingPrice != null
          ? item.sellingPrice!.toStringAsFixed(2)
          : '',
    );
    try {
      final price = await showDialog<double>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('List on Marketplace'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selling price for "${item.title}":'),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Selling Price',
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final p = double.tryParse(
                    priceController.text.replaceAll(',', '.'));
                if (p == null || p <= 0) return;
                Navigator.pop(ctx, p);
              },
              child: const Text('List'),
            ),
          ],
        ),
      );
      if (price == null || !mounted) return;
      await _repository.listItem(item.id!, price);
      _loadItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      priceController.dispose();
    }
  }

  Future<void> _unlistItem(InventoryItem item) async {
    try {
      await _repository.unlistItem(item.id!);
      _loadItems();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  // ── Computed display list ─────────────────────────────────────────────────

  List<InventoryItem> get _displayItems => _applySorting(_filtered);

  List<InventoryItem> get _filtered {
    return _all.where((item) {
      if (_showUnassignedOnly && item.locationId != null) return false;
      switch (_selectedTab) {
        case _ListingTab.private:
          if (item.isListed || item.status == 'sold') return false;
        case _ListingTab.listed:
          if (!item.isListed) return false;
        case _ListingTab.sold:
          if (item.status != 'sold') return false;
        case _ListingTab.all:
          break;
      }
      if (_query.isNotEmpty) {
        final hit = item.title.toLowerCase().contains(_query) ||
            item.gemType.toLowerCase().contains(_query) ||
            item.sku.toLowerCase().contains(_query) ||
            item.variety.toLowerCase().contains(_query);
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
      if (item.salePrice < _priceRange.start ||
          item.salePrice > _priceRange.end) {
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
        sorted.sort((a, b) => a.salePrice.compareTo(b.salePrice));
      case _SortOrder.priceHigh:
        sorted.sort((a, b) => b.salePrice.compareTo(a.salePrice));
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

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get _availableCount => _all.where((e) => e.status == 'available').length;

  double get _totalValue => _all.fold(0, (sum, e) => sum + e.salePrice);

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
      MaterialPageRoute(builder: (_) => const AddInventoryPage()),
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final display = _displayItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search name, gem type, SKU…',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: _searchController.clear,
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Private'),
                  Tab(text: 'Listed'),
                  Tab(text: 'Sold'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<_SortOrder>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            initialValue: _sortOrder,
            onSelected: (order) => setState(() => _sortOrder = order),
            itemBuilder: (_) => _SortOrder.values
                .map(
                  (o) => PopupMenuItem(
                    value: o,
                    child: Row(
                      children: [
                        if (_sortOrder == o)
                          const Icon(Icons.check, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(o.label),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          Badge(
            isLabelVisible: _hasFilters,
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _showFilterSheet,
              tooltip: 'Filter',
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_all.isNotEmpty)
                  _StatsStrip(_all.length, _availableCount, _totalValue),
                if (_unassignedCount > 0 && !_bannerDismissed)
                  _UnassignedBanner(
                    count: _unassignedCount,
                    onAssignNow: () => setState(() {
                      _showUnassignedOnly = true;
                      _bannerDismissed = true;
                    }),
                    onDismiss: () =>
                        setState(() => _bannerDismissed = true),
                  ),
                if (_hasFilters)
                  _FilterBar(
                    count: display.length,
                    total: _all.length,
                    onClear: _clearFilters,
                  ),
                Expanded(
                  child: display.isEmpty
                      ? _EmptyState(
                          hasSearch: _query.isNotEmpty || _hasFilters,
                          onClear: _clearFilters,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadItems,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(8, 4, 8, 80),
                            itemCount: display.length,
                            itemBuilder: (_, index) {
                              final item = display[index];
                              return _ItemCard(
                                item,
                                onTap: _openDetail,
                                onList: item.status != 'sold'
                                    ? () => _showListDialog(item)
                                    : null,
                                onUnlist: item.status != 'sold'
                                    ? () => _unlistItem(item)
                                    : null,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatsStrip extends StatelessWidget {
  final int total;
  final int available;
  final double totalValue;

  const _StatsStrip(this.total, this.available, this.totalValue);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      color: color.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _Stat(label: 'Total', value: total.toString()),
          _divider(),
          _Stat(label: 'Available', value: available.toString()),
          _divider(),
          _Stat(label: 'Value', value: '€${_formatValue(totalValue)}'),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.grey.shade300,
      );

  static String _formatValue(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Colors.grey),
        ),
      ],
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
    return Container(
      color: Theme.of(context)
          .colorScheme
          .secondaryContainer
          .withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            '$count of $total items',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
            ),
            child: const Text('Clear filters'),
          ),
        ],
      ),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.location_off_outlined,
              size: 18, color: cs.onTertiaryContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count item${count == 1 ? '' : 's'} have no physical location',
              style: TextStyle(
                  fontSize: 13, color: cs.onTertiaryContainer),
            ),
          ),
          TextButton(
            onPressed: onAssignNow,
            style: TextButton.styleFrom(
              foregroundColor: cs.onTertiaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 28),
            ),
            child: const Text('Assign now',
                style: TextStyle(fontSize: 12)),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: onDismiss,
            color: cs.onTertiaryContainer,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onClear;

  const _EmptyState({required this.hasSearch, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch
                ? 'No items match your search'
                : 'No inventory items yet',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (hasSearch) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onClear,
              child: const Text('Clear search & filters'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final InventoryItem item;
  final Future<void> Function(InventoryItem) onTap;
  final VoidCallback? onList;
  final VoidCallback? onUnlist;

  const _ItemCard(
    this.item, {
    required this.onTap,
    required this.onList,
    required this.onUnlist,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final listed = item.isListed && item.sellingPrice != null;
    final margin = listed ? item.sellingPrice! - item.costPrice : null;
    final marginPct = margin != null && item.costPrice > 0
        ? margin / item.costPrice * 100
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () => onTap(item),
            leading: item.imageUrls.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item.imageUrls.first,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.diamond_outlined, size: 36),
                    ),
                  )
                : const Icon(Icons.diamond_outlined, size: 36),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.isListed) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Listed',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(
              '${item.sku}  ·  ${item.gemType}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (listed) ...[
                  Text(
                    '€${item.sellingPrice!.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: cs.primary),
                  ),
                  Text(
                    'cost €${item.costPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  if (margin != null && marginPct != null)
                    Text(
                      '${margin >= 0 ? '+' : ''}€${margin.toStringAsFixed(0)} (${marginPct.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontSize: 10,
                        color: margin >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ] else
                  Text(
                    '€${item.costPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 4),
                _StatusChip(item.status),
              ],
            ),
          ),
          if (onList != null || onUnlist != null)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.isListed)
                    TextButton(
                      onPressed: onUnlist,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Unlist',
                          style: TextStyle(fontSize: 12)),
                    )
                  else
                    TextButton(
                      onPressed: onList,
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('List',
                          style: TextStyle(fontSize: 12)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  Color get _color => switch (status) {
        'available' => Colors.green,
        'reserved' => Colors.orange,
        'sold' => Colors.red,
        'draft' => Colors.grey,
        _ => Colors.grey,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
