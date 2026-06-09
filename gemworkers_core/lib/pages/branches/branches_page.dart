import 'package:flutter/material.dart';

import '../../models/branch.dart';
import '../../repositories/branch_repository.dart';
import 'add_edit_branch_page.dart';
import 'branch_detail_page.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  final _repo = BranchRepository();

  List<Branch> _branches = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final branches = await _repo.getBranches();
      // Load rollup counts for each branch in parallel.
      final withCounts = await Future.wait(
        branches.map((b) async {
          final inv = await _repo.getInventoryCount(b.id!);
          final sales = await _repo.getSalesCount(b.id!);
          return b.copyWith(inventoryCount: inv, salesCount: sales);
        }),
      );
      if (mounted) {
        setState(() {
          _branches = withCounts;
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
      MaterialPageRoute(builder: (_) => const AddEditBranchPage()),
    );
    if (saved == true) _load();
  }

  Future<void> _openDetail(Branch branch) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BranchDetailPage(branchId: branch.id!)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
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
          : _branches.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.store_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text('No branches yet',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
                    itemCount: _branches.length,
                    itemBuilder: (_, i) => _BranchCard(
                      branch: _branches[i],
                      onTap: () => _openDetail(_branches[i]),
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

// ── Branch card ───────────────────────────────────────────────────────────────

class _BranchCard extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;

  const _BranchCard({required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        branch.status == 'active' ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            branch.country.isNotEmpty
                ? branch.country.substring(0, branch.country.length.clamp(0, 2))
                : '??',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        title: Text(branch.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${branch.inventoryCount} items · ${branch.salesCount} sales',
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
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                branch.status,
                style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.chevron_right,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
