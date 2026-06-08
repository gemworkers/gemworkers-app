import 'package:flutter/material.dart';

import '../../models/supplier.dart';
import '../../repositories/supplier_repository.dart';
import 'add_edit_supplier_page.dart';
import 'supplier_detail_page.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final _repository = SupplierRepository();
  final _searchController = TextEditingController();

  List<Supplier> _all = [];
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

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final suppliers = await _repository.getSuppliers();
      if (mounted) setState(() { _all = suppliers; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Supplier> get _filtered {
    if (_query.isEmpty) return _all;
    return _all
        .where((s) =>
            s.name.toLowerCase().contains(_query) ||
            s.country.toLowerCase().contains(_query) ||
            s.contactName.toLowerCase().contains(_query))
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditSupplierPage()),
    );
    if (added == true) _load();
  }

  Future<void> _openDetail(Supplier supplier) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SupplierDetailPage(supplier: supplier)),
    );
    _load();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search name, country, contact…',
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
                    itemBuilder: (_, i) => _SupplierCard(
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
            hasSearch ? Icons.search_off : Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No suppliers match your search' : 'No suppliers yet',
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

class _SupplierCard extends StatelessWidget {
  final Supplier supplier;
  final Future<void> Function(Supplier) onTap;
  const _SupplierCard(this.supplier, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: () => onTap(supplier),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            supplier.name.isNotEmpty
                ? supplier.name[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          supplier.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          supplier.country.isNotEmpty ? supplier.country : 'No country',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: _StarRating(supplier.reliabilityScore),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  const _StarRating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final full = i < rating.floor();
        final half = !full && i < rating;
        return Icon(
          full
              ? Icons.star
              : half
                  ? Icons.star_half
                  : Icons.star_border,
          size: 14,
          color: Colors.amber,
        );
      }),
    );
  }
}
