import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../models/location.dart';
import '../../repositories/location_repository.dart';

/// Shows a modal dialog for picking a location within a branch.
///
/// Returns the selected [Location], or null if dismissed.
Future<Location?> showLocationPicker(
  BuildContext context, {
  required String sellerId,
  String? currentLocationId,
  bool statusZonesOnly = false,
}) {
  return showDialog<Location>(
    context: context,
    builder: (_) => _LocationPickerDialog(
      sellerId: sellerId,
      currentLocationId: currentLocationId,
      statusZonesOnly: statusZonesOnly,
    ),
  );
}

class _LocationPickerDialog extends StatefulWidget {
  final String sellerId;
  final String? currentLocationId;
  final bool statusZonesOnly;

  const _LocationPickerDialog({
    required this.sellerId,
    this.currentLocationId,
    required this.statusZonesOnly,
  });

  @override
  State<_LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<_LocationPickerDialog> {
  final _repo = LocationRepository();

  List<Location> _flat = [];
  String? _selectedId;
  bool _loading = true;
  bool _statusZonesOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentLocationId;
    _statusZonesOnly = widget.statusZonesOnly;
    _load();
  }

  Future<void> _load() async {
    try {
      final flat = await _repo.getLocationsFlat(widget.sellerId);
      if (mounted) {
        setState(() {
          _flat = flat;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Location> get _displayed =>
      _statusZonesOnly ? _flat.where((l) => l.isStatusZone).toList() : _flat;

  int _depthOf(String id) {
    int depth = 0;
    String? current = id;
    while (current != null) {
      try {
        final loc = _flat.firstWhere((l) => l.id == current);
        current = loc.parentId;
        if (current != null) depth++;
      } catch (_) {
        break;
      }
    }
    return depth;
  }

  @override
  Widget build(BuildContext context) {
    final selected = _flat.where((l) => l.id == _selectedId).firstOrNull;

    return AlertDialog(
      title: const Text('Pick Location'),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      content: SizedBox(
        width: 360,
        height: 420,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Status zones only',
                      style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  Switch(
                    value: _statusZonesOnly,
                    onChanged: (v) => setState(() => _statusZonesOnly = v),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _displayed.isEmpty
                      ? const Center(
                          child: Text('No locations found',
                              style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          itemCount: _displayed.length,
                          itemBuilder: (_, i) {
                            final loc = _displayed[i];
                            final depth = _depthOf(loc.id!);
                            final isSelected = loc.id == _selectedId;
                            return ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 16.0 + depth * 20.0, right: 8),
                              selected: isSelected,
                              selectedTileColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.3),
                              leading: isSelected
                                  ? Icon(Icons.check_circle,
                                      size: 18,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)
                                  : Icon(
                                      loc.isStatusZone
                                          ? Icons.flag_outlined
                                          : Icons.place_outlined,
                                      size: 18,
                                      color: Colors.grey),
                              title: Text(loc.name,
                                  style: const TextStyle(fontSize: 14)),
                              subtitle: loc.code.isNotEmpty
                                  ? Text(loc.code,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey))
                                  : null,
                              onTap: () =>
                                  setState(() => _selectedId = loc.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_selectedId != null && selected != null)
          TextButton(
            onPressed: () => _showQR(selected),
            child: const Text('QR'),
          ),
        FilledButton(
          onPressed: selected == null
              ? null
              : () => Navigator.pop(context, selected),
          child: const Text('Select'),
        ),
      ],
    );
  }

  void _showQR(Location loc) {
    final data = loc.code.isNotEmpty ? loc.code : (loc.id ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: data,
              version: QrVersions.auto,
              size: 200,
            ),
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
}
