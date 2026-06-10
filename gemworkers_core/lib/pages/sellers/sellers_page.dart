import 'package:flutter/material.dart';

import '../../models/seller.dart';
import '../../repositories/seller_repository.dart';
import 'add_edit_seller_page.dart';
import 'seller_detail_page.dart';

class SellersPage extends StatefulWidget {
  const SellersPage({super.key});

  @override
  State<SellersPage> createState() => _SellersPageState();
}

class _SellersPageState extends State<SellersPage> {
  final _repo = SellerRepository();

  List<Seller> _sellers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final sellers = await _repo.getSellers();
      final withCounts = await Future.wait(
        sellers.map((s) async {
          final inv = await _repo.getInventoryCount(s.id!);
          final listed = await _repo.getListedCount(s.id!);
          final sales = await _repo.getSalesCount(s.id!);
          return s.copyWith(
            inventoryCount: inv,
            listedCount: listed,
            salesCount: sales,
          );
        }),
      );
      if (mounted) {
        setState(() {
          _sellers = withCounts;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openAdd() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditSellerPage()),
    );
    if (saved == true) _load();
  }

  Future<void> _openDetail(Seller seller) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => SellerDetailPage(sellerId: seller.id!)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sellers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text('No sellers yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    itemCount: _sellers.length,
                    itemBuilder: (_, i) => _SellerCard(
                      seller: _sellers[i],
                      onTap: () => _openDetail(_sellers[i]),
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

// ── Seller card ───────────────────────────────────────────────────────────────

class _SellerCard extends StatelessWidget {
  final Seller seller;
  final VoidCallback onTap;

  const _SellerCard({required this.seller, required this.onTap});

  Color get _statusColor => switch (seller.status) {
        'active' => Colors.green,
        'pending' => Colors.orange,
        _ => Colors.red, // suspended
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            seller.country.isNotEmpty
                ? seller.country
                    .substring(0, seller.country.length.clamp(0, 2))
                    .toUpperCase()
                : '??',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(seller.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${seller.inventoryCount} items · '
          '${seller.listedCount} listed · '
          '${seller.salesCount} sales',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: _statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                seller.status,
                style: TextStyle(
                    fontSize: 11,
                    color: _statusColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
