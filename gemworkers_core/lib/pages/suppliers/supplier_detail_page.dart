import 'package:flutter/material.dart';

import '../../models/supplier.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/supplier_repository.dart';
import 'add_edit_supplier_page.dart';

class SupplierDetailPage extends StatefulWidget {
  final Supplier supplier;

  const SupplierDetailPage({super.key, required this.supplier});

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  final _repository = SupplierRepository();
  final _inventoryRepository = InventoryRepository();

  late Supplier _supplier;
  bool _deleting = false;
  int _inventoryCount = 0;
  bool _loadingInventory = false;

  @override
  void initState() {
    super.initState();
    _supplier = widget.supplier;
    if (_supplier.id != null) {
      _loadInventoryCount();
    }
  }

  Future<void> _loadInventoryCount() async {
    setState(() => _loadingInventory = true);
    try {
      final items = await _inventoryRepository.getItemsBySupplier(_supplier.id!);
      if (mounted) setState(() { _inventoryCount = items.length; _loadingInventory = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingInventory = false);
    }
  }

  // ── Edit ──────────────────────────────────────────────────────────────────

  Future<void> _openEdit() async {
    final updated = await Navigator.push<Supplier>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditSupplierPage(supplier: _supplier),
      ),
    );
    if (updated != null && mounted) {
      setState(() => _supplier = updated);
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Delete "${_supplier.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _repository.deleteSupplier(_supplier.id!);
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
        setState(() => _deleting = false);
      }
    }
  }

  // ── Build helpers ─────────────────────────────────────────────────────────

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '—' : value),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_supplier.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _openEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: _deleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            onPressed: _deleting ? null : _confirmDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + name header
          Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    _supplier.name.isNotEmpty
                        ? _supplier.name[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _supplier.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                if (_supplier.country.isNotEmpty)
                  Text(
                    _supplier.country,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                const SizedBox(height: 8),
                _StarRating(_supplier.reliabilityScore),
                const SizedBox(height: 4),
                Text(
                  '${_supplier.reliabilityScore.toStringAsFixed(1)} / 5',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 16),

                // Inventory count chip
                _loadingInventory
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Chip(
                        avatar: Icon(
                          Icons.inventory_2_outlined,
                          size: 16,
                          color: cs.onSecondaryContainer,
                        ),
                        label: Text(
                          '$_inventoryCount item${_inventoryCount == 1 ? '' : 's'} in inventory',
                          style: TextStyle(
                            fontSize: 13,
                            color: cs.onSecondaryContainer,
                          ),
                        ),
                        backgroundColor: cs.secondaryContainer,
                        side: BorderSide.none,
                      ),

                const SizedBox(height: 12),
                const Divider(),
              ],
            ),
          ),

          _sectionLabel('Contact'),
          _row('Contact Name', _supplier.contactName),
          _row('Email', _supplier.email),
          _row('Phone', _supplier.phone),

          _sectionLabel('Details'),
          _row('Country', _supplier.country),

          if (_supplier.notes.isNotEmpty) ...[
            _sectionLabel('Notes'),
            Text(_supplier.notes),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Star rating display ───────────────────────────────────────────────────────

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
          full ? Icons.star : half ? Icons.star_half : Icons.star_border,
          size: 22,
          color: Colors.amber,
        );
      }),
    );
  }
}
