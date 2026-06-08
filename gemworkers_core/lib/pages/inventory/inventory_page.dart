import 'package:flutter/material.dart';

import '../../models/inventory_item.dart';
import '../../repositories/inventory_repository.dart';
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

// ── Page ──────────────────────────────────────────────────────────────────────

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final _repository = InventoryRepository();
  final _searchController = TextEditingController();

  List<InventoryItem> _all = [];
  bool _loading = true;

  // ── Filter & sort state ───────────────────────────────────────────────────

  String _query = '';
  String? _statusFilter;
  String? _gemTypeFilter;
  double _maxPrice = 10000;
  RangeValues _priceRange = const RangeValues(0, 10000);
  bool _priceRangeInitialized = false;
  _SortOrder _sortOrder = _SortOrder.newestFirst;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadItems();
  }

  @override
  void dispose() {
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
      final items = await _repository.getItems();
      setState(() {
        _all = items;
        if (!_priceRangeInitialized && items.isNotEmpty) {
          final max = items
              .map((e) => e.salePrice)
              .reduce((a, b) => a > b ? a : b);
          _maxPrice = max < 1 ? 10000 : max;
          _priceRange = RangeValues(0, _maxPrice);
          _priceRangeInitialized = true;
        }
        _loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Computed display list ─────────────────────────────────────────────────

  List<InventoryItem> get _displayItems => _applySorting(_filtered);

  List<InventoryItem> get _filtered {
    return _all.where((item) {
      if (_query.isNotEmpty) {
        final hit = item.title.toLowerCase().contains(_query) ||
            item.gemType.toLowerCase().contains(_query) ||
            item.sku.toLowerCase().contains(_query) ||
            item.variety.toLowerCase().contains(_query);
        if (!hit) return false;
      }
      if (_statusFilter != null && item.status != _statusFilter) return false;
      if (_gemTypeFilter != null && _gemTypeFilter!.isNotEmpty) {
        if (!item.gemType
            .toLowerCase()
            .contains(_gemTypeFilter!.toLowerCase())) {
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

  bool get _hasFilters =>
      _statusFilter != null ||
      (_gemTypeFilter?.isNotEmpty ?? false) ||
      _priceRange.start > 0 ||
      _priceRange.end < _maxPrice;

  void _clearFilters() {
    setState(() {
      _statusFilter = null;
      _gemTypeFilter = null;
      _priceRange = RangeValues(0, _maxPrice);
    });
  }

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get _availableCount =>
      _all.where((e) => e.status == 'available').length;

  double get _totalValue =>
      _all.fold(0, (sum, e) => sum + e.salePrice);

  // ── Filter bottom sheet ───────────────────────────────────────────────────

  void _showFilterSheet() {
    String? tempStatus = _statusFilter;
    final gemController = TextEditingController(text: _gemTypeFilter ?? '');
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
                      tempStatus = null;
                      gemController.clear();
                      tempPrice = RangeValues(0, _maxPrice);
                    }),
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButton<String?>(
                  value: tempStatus,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                        value: null, child: Text('All statuses')),
                    DropdownMenuItem(
                        value: 'available', child: Text('Available')),
                    DropdownMenuItem(
                        value: 'reserved', child: Text('Reserved')),
                    DropdownMenuItem(value: 'sold', child: Text('Sold')),
                    DropdownMenuItem(value: 'draft', child: Text('Draft')),
                  ],
                  onChanged: (v) => setSheet(() => tempStatus = v),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: gemController,
                decoration: const InputDecoration(
                  labelText: 'Gem Type',
                  hintText: 'e.g. Ruby, Sapphire…',
                  border: OutlineInputBorder(),
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
                      _statusFilter = tempStatus;
                      _gemTypeFilter = gemController.text.trim().isEmpty
                          ? null
                          : gemController.text.trim();
                      _priceRange = tempPrice;
                    });
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
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
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
        ),
        actions: [
          // Sort menu
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
          // Filter button with active indicator
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
                // ── Stats strip ─────────────────────────────────────────
                if (_all.isNotEmpty) _StatsStrip(_all.length, _availableCount, _totalValue),

                // ── Active filter bar ───────────────────────────────────
                if (_hasFilters)
                  _FilterBar(
                    count: display.length,
                    total: _all.length,
                    onClear: _clearFilters,
                  ),

                // ── List ────────────────────────────────────────────────
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
                            itemBuilder: (_, index) =>
                                _ItemCard(display[index], onTap: _openDetail),
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
          _Stat(
            label: 'Value',
            value: '€${_formatValue(totalValue)}',
          ),
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

  const _ItemCard(this.item, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
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
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
          children: [
            Text(
              '€${item.salePrice.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            _StatusChip(item.status),
          ],
        ),
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
