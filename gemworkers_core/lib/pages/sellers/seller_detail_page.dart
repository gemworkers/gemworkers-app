import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../models/location.dart';
import '../../models/seller.dart';
import '../../repositories/location_repository.dart';
import '../../repositories/seller_repository.dart';
import 'add_edit_seller_page.dart';

class SellerDetailPage extends StatefulWidget {
  final String sellerId;
  const SellerDetailPage({super.key, required this.sellerId});

  @override
  State<SellerDetailPage> createState() => _SellerDetailPageState();
}

class _SellerDetailPageState extends State<SellerDetailPage> {
  final _sellerRepo = SellerRepository();
  final _locationRepo = LocationRepository();

  Seller? _seller;
  List<Location> _locationTree = [];
  bool _loading = true;
  bool _deleting = false;
  bool _inviting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _sellerRepo.getSeller(widget.sellerId),
        _sellerRepo.getInventoryCount(widget.sellerId),
        _sellerRepo.getListedCount(widget.sellerId),
        _sellerRepo.getSalesCount(widget.sellerId),
        _sellerRepo.getRevenue(widget.sellerId),
        _locationRepo.getTree(widget.sellerId),
      ]);
      if (mounted) {
        final seller = results[0] as Seller;
        setState(() {
          _seller = seller.copyWith(
            inventoryCount: results[1] as int,
            listedCount: results[2] as int,
            salesCount: results[3] as int,
            revenue: results[4] as double,
          );
          _locationTree = results[5] as List<Location>;
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
          builder: (_) => AddEditSellerPage(seller: _seller)),
    );
    if (saved == true) _load();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Seller'),
        content: Text(
            'Delete "${_seller!.name}"? This will also delete all its locations. '
            'Inventory items, orders, and purchases will have their seller reference cleared.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await _sellerRepo.deleteSeller(widget.sellerId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
        setState(() => _deleting = false);
      }
    }
  }

  Future<void> _confirmInvite() async {
    final seller = _seller;
    if (seller == null) return;

    if (seller.email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Add an email for this seller before inviting.')));
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invite seller?'),
        content: Text(
            'Send a login invitation to ${seller.email}? They will receive '
            'an email to set their password and access the GemWorkers admin app.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Send invite'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _inviting = true);
    try {
      final res = await Supabase.instance.client.functions.invoke(
        'seller-invite',
        body: {'seller_id': seller.id},
      );
      final data = res.data as Map<String, dynamic>?;

      String message;
      if (data?['alreadyInvited'] == true) {
        message = 'This seller was already invited.';
      } else if (data?['ok'] == true || data?['invited'] == true) {
        message = 'Invitation sent to ${seller.email}.';
      } else {
        message =
            data?['error']?.toString() ?? 'Invite failed. Please try again.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } on FunctionException catch (e) {
      final details = e.details;
      final message = details is Map && details['error'] != null
          ? details['error'].toString()
          : 'Invite failed: ${e.reasonPhrase ?? e.status}';
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invite failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _inviting = false);
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
          title:
              Text(existing == null ? 'Add Location' : 'Edit Location'),
          content: SizedBox(
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder()),
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
        sellerId: widget.sellerId,
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
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
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
    final seller = _seller;

    return Scaffold(
      appBar: AppBar(
        title: Text(seller?.name ?? 'Seller'),
        actions: [
          if (!_loading && seller != null) ...[
            if (UserProfileService.instance.isOwner)
              IconButton(
                icon: _inviting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.mail_outline),
                tooltip: 'Invite to log in',
                onPressed: _inviting ? null : _confirmInvite,
              ),
            IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: _deleting ? null : _openEdit),
            IconButton(
              icon: _deleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              onPressed: _deleting ? null : _confirmDelete,
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : seller == null
              ? const Center(child: Text('Seller not found'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(seller),
                    const SizedBox(height: 12),
                    _buildContact(seller),
                    const SizedBox(height: 12),
                    _buildStats(seller),
                    const SizedBox(height: 12),
                    _buildFeeSettings(seller),
                    const SizedBox(height: 12),
                    _buildLocations(),
                    if (seller.notes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildNotes(seller),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
    );
  }

  Widget _buildHeader(Seller seller) {
    final statusColor = switch (seller.status) {
      'active' => Colors.green,
      'pending' => Colors.orange,
      _ => Colors.red,
    };
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
                    seller.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                _StatusChip(seller.status, statusColor),
              ],
            ),
            const Divider(height: 20),
            _row('Country',
                seller.country.isEmpty ? '—' : seller.country),
            if (seller.joinedDate != null)
              _row(
                'Joined',
                '${seller.joinedDate!.day.toString().padLeft(2, '0')}/'
                    '${seller.joinedDate!.month.toString().padLeft(2, '0')}/'
                    '${seller.joinedDate!.year}',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContact(Seller seller) {
    final hasContact = seller.contactName.isNotEmpty ||
        seller.email.isNotEmpty ||
        seller.phone.isNotEmpty;
    if (!hasContact) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contact',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (seller.contactName.isNotEmpty)
              _row('Name', seller.contactName),
            if (seller.email.isNotEmpty) _row('Email', seller.email),
            if (seller.phone.isNotEmpty) _row('Phone', seller.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Seller seller) {
    return Row(
      children: [
        Expanded(child: _StatCard('${seller.inventoryCount}', 'Items')),
        const SizedBox(width: 8),
        Expanded(
            child: _StatCard('${seller.listedCount}', 'Listed')),
        const SizedBox(width: 8),
        Expanded(
            child: _StatCard('${seller.salesCount}', 'Sales')),
        const SizedBox(width: 8),
        Expanded(
            child:
                _StatCard('€${seller.revenue.toStringAsFixed(0)}', 'Revenue')),
      ],
    );
  }

  Widget _buildFeeSettings(Seller seller) {
    final hasFees = seller.commissionRate != null ||
        seller.userFee != null ||
        seller.startingFee != null;
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
            if (seller.commissionRate != null)
              _row('Commission',
                  '${(seller.commissionRate! * 100).toStringAsFixed(2)}%'),
            if (seller.userFee != null)
              _row(
                'User Fee',
                '€${seller.userFee!.toStringAsFixed(2)}'
                    '${seller.userFeePeriod != null ? ' / ${seller.userFeePeriod}' : ''}',
              ),
            if (seller.startingFee != null)
              _row('Starting Fee',
                  '€${seller.startingFee!.toStringAsFixed(2)} (one-time)'),
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

  List<Widget> _buildLocationNodes(List<Location> nodes, int depth) {
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

  Widget _buildNotes(Seller seller) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notes',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(seller.notes),
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

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  const _StatCard(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

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
        title:
            Text(location.name, style: const TextStyle(fontSize: 14)),
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
