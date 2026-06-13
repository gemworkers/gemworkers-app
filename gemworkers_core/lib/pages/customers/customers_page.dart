import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../repositories/customer_repository.dart';
import 'add_edit_customer_page.dart';
import 'customer_detail_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final _repository = CustomerRepository();
  final _searchController = TextEditingController();

  List<Customer> _all = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearch);
    _load();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  void _onSearch() =>
      setState(() => _query = _searchController.text.toLowerCase().trim());

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final customers = await _repository.getCustomers();
      if (mounted) setState(() { _all = customers; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Customer> get _filtered {
    if (_query.isEmpty) return _all;
    return _all
        .where((c) =>
            c.name.toLowerCase().contains(_query) ||
            c.email.toLowerCase().contains(_query) ||
            c.country.toLowerCase().contains(_query))
        .toList();
  }

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditCustomerPage()),
    );
    if (added == true) _load();
  }

  Future<void> _openDetail(Customer customer) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerDetailPage(customer: customer)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search name, email, country…',
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
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
              ? _EmptyState(
                  hasSearch: _query.isNotEmpty,
                  onClear: _searchController.clear,
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 80),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _CustomerCard(
                      filtered[i],
                      onTap: _openDetail,
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

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
            hasSearch ? Icons.search_off : Icons.person_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No customers match your search' : 'No customers yet',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          if (hasSearch) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onClear, child: const Text('Clear search')),
          ],
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final Future<void> Function(Customer) onTap;
  const _CustomerCard(this.customer, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tier = customer.effectiveTier;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: () => onTap(customer),
        leading: CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Text(
            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              customer.email.isNotEmpty ? customer.email : customer.country,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            if (customer.orderCount > 0)
              Text(
                '${customer.orderCount} order${customer.orderCount == 1 ? '' : 's'}'
                '  ·  €${_fmt(customer.totalSpent)}',
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              ),
          ],
        ),
        isThreeLine: customer.orderCount > 0,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TypeBadge(customer.type),
            const SizedBox(width: 6),
            _TierChip(tier),
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge(this.type);

  @override
  Widget build(BuildContext context) {
    final isBusiness = type == 'business';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: (isBusiness ? Colors.blue : Colors.green).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: (isBusiness ? Colors.blue : Colors.green).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        isBusiness ? 'Biz' : 'Ind',
        style: TextStyle(
          fontSize: 11,
          color: isBusiness ? Colors.blue.shade700 : Colors.green.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  final String tier;
  const _TierChip(this.tier);

  Color get _color => switch (tier) {
        'Silver'    => const Color(0xFF9E9E9E),
        'Gold'      => const Color(0xFFF9A825),
        'Premium'   => const Color(0xFF7B1FA2),
        'Collector' => const Color(0xFF00897B),
        _           => const Color(0xFF9E9E9E),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Text(
        tier,
        style: TextStyle(
          fontSize: 11,
          color: _color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
