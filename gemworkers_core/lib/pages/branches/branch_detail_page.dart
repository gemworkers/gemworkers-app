import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/branch.dart';
import '../../models/location.dart';
import '../../repositories/branch_repository.dart';
import '../../repositories/location_repository.dart';
import 'add_edit_branch_page.dart';

class BranchDetailPage extends StatefulWidget {
  final String branchId;
  const BranchDetailPage({super.key, required this.branchId});

  @override
  State<BranchDetailPage> createState() => _BranchDetailPageState();
}

class _BranchDetailPageState extends State<BranchDetailPage> {
  final _branchRepo = BranchRepository();
  final _locationRepo = LocationRepository();

  Branch? _branch;
  List<Location> _locationTree = [];
  bool _loading = true;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _branchRepo.getBranch(widget.branchId),
        _branchRepo.getInventoryCount(widget.branchId),
        _branchRepo.getSalesCount(widget.branchId),
        _locationRepo.getTree(widget.branchId),
      ]);
      if (mounted) {
        final branch = results[0] as Branch;
        setState(() {
          _branch = branch.copyWith(
            inventoryCount: results[1] as int,
            salesCount: results[2] as int,
          );
          _locationTree = results[3] as List<Location>;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEdit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
          builder: (_) => AddEditBranchPage(branch: _branch)),
    );
    if (saved == true) _load();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Branch'),
        content: Text(
            'Delete "${_branch!.name}"? This will also delete all its locations. '
            'Inventory items, orders, and purchases will have their branch reference cleared.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _branchRepo.deleteBranch(widget.branchId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
        setState(() => _deleting = false);
      }
    }
  }

  Future<void> _addLocation() async {
    await _showAddEditLocationDialog(null);
  }

  Future<void> _showAddEditLocationDialog(Location? existing) async {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    final codeCtrl =
        TextEditingController(text: existing?.code ?? '');
    final noteCtrl =
        TextEditingController(text: existing?.managerNote ?? '');
    String type = existing?.type ?? 'zone';
    bool isStatusZone = existing?.isStatusZone ?? false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: Text(existing == null ? 'Add Location' : 'Edit Location'),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Name *', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Code (short label / QR)',
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4)),
                  child: DropdownButton<String>(
                    value: type,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                          value: 'country', child: Text('Country')),
                      DropdownMenuItem(
                          value: 'shop', child: Text('Shop')),
                      DropdownMenuItem(
                          value: 'zone', child: Text('Zone')),
                      DropdownMenuItem(
                          value: 'unit', child: Text('Unit')),
                      DropdownMenuItem(
                          value: 'slot', child: Text('Slot')),
                      DropdownMenuItem(
                          value: 'other', child: Text('Other')),
                    ],
                    onChanged: (v) {
                      if (v != null) setDlg(() => type = v);
                    },
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: const Text('Is a status zone',
                      style: TextStyle(fontSize: 14)),
                  value: isStatusZone,
                  onChanged: (v) =>
                      setDlg(() => isStatusZone = v ?? false),
                ),
                TextField(
                  controller: noteCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Manager note',
                      border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
    codeCtrl.dispose();
    noteCtrl.dispose();

    if (saved != true || !mounted) return;

    try {
      final location = Location(
        id: existing?.id,
        branchId: widget.branchId,
        name: nameCtrl.text.trim(),
        code: codeCtrl.text.trim(),
        parentId: existing?.parentId,
        type: type,
        isStatusZone: isStatusZone,
        managerNote: noteCtrl.text.trim(),
      );
      final locationRepo = LocationRepository();
      if (existing == null) {
        await locationRepo.addLocation(location);
      } else {
        await locationRepo.updateLocation(existing.id!, location);
      }
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _confirmDeleteLocation(Location loc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Location'),
        content: Text(
            'Delete "${loc.name}"? Items placed here will lose their location.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style:
                FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await LocationRepository().deleteLocation(loc.id!);
      _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final branch = _branch;

    return Scaffold(
      appBar: AppBar(
        title: Text(branch?.name ?? 'Branch'),
        actions: [
          if (!_loading && branch != null) ...[
            IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: _deleting ? null : _openEdit),
            IconButton(
              icon: _deleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _deleting ? null : _confirmDelete,
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : branch == null
              ? const Center(child: Text('Branch not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(branch),
                    const SizedBox(height: 12),
                    _buildStats(branch),
                    const SizedBox(height: 12),
                    _buildFeeSettings(branch),
                    const SizedBox(height: 12),
                    _buildLocations(),
                    if (branch.notes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildNotes(branch),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
    );
  }

  Widget _buildHeader(Branch branch) {
    final statusColor =
        branch.status == 'active' ? Colors.green : Colors.orange;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    branch.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StatusChip(branch.status, statusColor),
              ],
            ),
            const Divider(height: 20),
            _row('Country', branch.country.isEmpty ? '—' : branch.country),
            if (branch.joinedDate != null)
              _row(
                'Joined',
                '${branch.joinedDate!.day.toString().padLeft(2, '0')}/'
                    '${branch.joinedDate!.month.toString().padLeft(2, '0')}/'
                    '${branch.joinedDate!.year}',
              ),
            if (branch.contactNote.isNotEmpty)
              _row('Contact', branch.contactNote),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Branch branch) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${branch.inventoryCount}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Inventory items',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '${branch.salesCount}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Sales (paid)',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeeSettings(Branch branch) {
    final hasFees = branch.commissionRate != null ||
        branch.userFee != null ||
        branch.startingFee != null;
    if (!hasFees) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fee Settings',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (branch.commissionRate != null)
              _row('Commission',
                  '${(branch.commissionRate! * 100).toStringAsFixed(2)}%'),
            if (branch.userFee != null)
              _row(
                'User Fee',
                '€${branch.userFee!.toStringAsFixed(2)}'
                    '${branch.userFeePeriod != null ? ' / ${branch.userFeePeriod}' : ''}',
              ),
            if (branch.startingFee != null)
              _row('Starting Fee',
                  '€${branch.startingFee!.toStringAsFixed(2)} (one-time)'),
          ],
        ),
      ),
    );
  }

  Widget _buildLocations() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Locations',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addLocation,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8)),
                ),
              ],
            ),
            if (_locationTree.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child: Text('No locations yet',
                        style: TextStyle(color: Colors.grey))),
              )
            else
              ..._buildLocationNodes(_locationTree, 0),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLocationNodes(
      List<Location> nodes, int depth) {
    final widgets = <Widget>[];
    for (final loc in nodes) {
      widgets.add(_LocationTile(
        location: loc,
        depth: depth,
        onEdit: () => _showAddEditLocationDialog(loc),
        onDelete: () => _confirmDeleteLocation(loc),
        onQR: () => _showLocationQR(loc),
      ));
      if (loc.children.isNotEmpty) {
        widgets.addAll(_buildLocationNodes(loc.children, depth + 1));
      }
    }
    return widgets;
  }

  void _showLocationQR(Location loc) {
    final data = loc.code.isNotEmpty ? loc.code : (loc.id ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(data: data, version: QrVersions.auto, size: 200),
            const SizedBox(height: 8),
            Text(loc.code.isNotEmpty ? loc.code : 'No code',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildNotes(Branch branch) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(branch.notes),
            ],
          ),
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 13)),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusChip(this.status, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
            fontSize: 12, color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final Location location;
  final int depth;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onQR;

  const _LocationTile({
    required this.location,
    required this.depth,
    required this.onEdit,
    required this.onDelete,
    required this.onQR,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 20.0),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: Icon(
          location.isStatusZone
              ? Icons.flag_outlined
              : Icons.place_outlined,
          size: 18,
          color: location.isStatusZone ? Colors.blue : Colors.grey,
        ),
        title: Text(location.name,
            style: const TextStyle(fontSize: 14)),
        subtitle: location.code.isNotEmpty
            ? Text(location.code,
                style: const TextStyle(fontSize: 11))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.qr_code, size: 18),
              onPressed: onQR,
              visualDensity: VisualDensity.compact,
              tooltip: 'QR code',
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: onEdit,
              visualDensity: VisualDensity.compact,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: onDelete,
              visualDensity: VisualDensity.compact,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
