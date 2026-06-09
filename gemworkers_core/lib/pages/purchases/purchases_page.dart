import 'package:flutter/material.dart';

import '../../models/purchase.dart';
import '../../repositories/purchase_repository.dart';
import 'add_edit_purchase_page.dart';
import 'purchase_detail_page.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  final _repository = PurchaseRepository();

  List<Purchase> _purchases = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final purchases = await _repository.getPurchases();
      if (mounted) {
        setState(() {
          _purchases = purchases;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPurchasePage()),
    );
    if (added == true) _load();
  }

  Future<void> _openDetail(Purchase purchase) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PurchaseDetailPage(purchaseId: purchase.id!)),
    );
    _load();
  }

  List<Purchase> get _filtered {
    if (_query.isEmpty) return _purchases;
    final q = _query.toLowerCase();
    return _purchases
        .where((p) =>
            p.purchaseNumber.toLowerCase().contains(q) ||
            p.supplierName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v.trim()),
              decoration: InputDecoration(
                hintText: 'Search by number or supplier…',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () => setState(() => _query = ''),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
              ? _EmptyState(hasSearch: _query.isNotEmpty)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 80),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _PurchaseCard(
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
  const _EmptyState({required this.hasSearch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch ? 'No purchases match that search' : 'No purchases yet',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _PurchaseCard extends StatelessWidget {
  final Purchase purchase;
  final Future<void> Function(Purchase) onTap;
  const _PurchaseCard(this.purchase, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: () => onTap(purchase),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.shopping_bag_outlined,
              color: cs.onPrimaryContainer, size: 22),
        ),
        title: Text(
          purchase.purchaseNumber.isNotEmpty
              ? purchase.purchaseNumber
              : 'Draft',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          purchase.supplierName.isNotEmpty
              ? purchase.supplierName
              : 'No supplier',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '€${purchase.totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: cs.primary),
            ),
            const SizedBox(height: 2),
            Text(
              '${purchase.purchaseDate.day.toString().padLeft(2, '0')}/'
              '${purchase.purchaseDate.month.toString().padLeft(2, '0')}/'
              '${purchase.purchaseDate.year}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
