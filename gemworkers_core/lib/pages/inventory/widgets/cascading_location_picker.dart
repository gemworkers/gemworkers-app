import 'package:flutter/material.dart';

import '../../../models/location.dart';
import '../../../repositories/location_repository.dart';

const _kAddNew = '__add__';

/// Three-level cascading picker: Furniture → Compartment → Slot (optional).
/// Calls [onChanged] with the deepest selected location ID, or null when cleared.
class CascadingLocationPicker extends StatefulWidget {
  final String? sellerId;
  final String? initialLocationId;
  final void Function(String? locationId) onChanged;
  final bool enabled;

  const CascadingLocationPicker({
    super.key,
    required this.sellerId,
    this.initialLocationId,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<CascadingLocationPicker> createState() =>
      _CascadingLocationPickerState();
}

class _CascadingLocationPickerState extends State<CascadingLocationPicker> {
  final _repo = LocationRepository();

  List<Location> _all = [];
  bool _loading = true;

  String? _furnitureId;
  String? _compartmentId;
  String? _slotId;

  List<Location> get _furniture =>
      _all.where((l) => l.parentId == null).toList();

  List<Location> get _compartments => _furnitureId == null
      ? []
      : _all.where((l) => l.parentId == _furnitureId).toList();

  List<Location> get _slots => _compartmentId == null
      ? []
      : _all.where((l) => l.parentId == _compartmentId).toList();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final flat = await _repo.getLocationsFlat(widget.sellerId);
      if (!mounted) return;
      setState(() {
        _all = flat.where((l) => !l.isStatusZone).toList();
        _loading = false;
      });
      if (widget.initialLocationId != null) {
        _initFromId(widget.initialLocationId!);
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _initFromId(String id) {
    final loc = _all.where((l) => l.id == id).firstOrNull;
    if (loc == null) return;

    if (loc.parentId == null) {
      setState(() => _furnitureId = id);
    } else {
      final parent = _all.where((l) => l.id == loc.parentId).firstOrNull;
      if (parent == null) return;
      if (parent.parentId == null) {
        setState(() {
          _furnitureId = parent.id;
          _compartmentId = id;
        });
      } else {
        final grandparent =
            _all.where((l) => l.id == parent.parentId).firstOrNull;
        if (grandparent != null) {
          setState(() {
            _furnitureId = grandparent.id;
            _compartmentId = parent.id;
            _slotId = id;
          });
        }
      }
    }
    _report();
  }

  void _report() {
    widget.onChanged(_slotId ?? _compartmentId ?? _furnitureId);
  }

  Future<void> _addInline(String level, String? parentId) async {
    if (widget.sellerId == null) return;
    final name = await _promptName(level);
    if (name == null || !mounted) return;
    try {
      final created = await _repo.addLocation(Location(
        sellerId: widget.sellerId!,
        name: name,
        code: '',
        parentId: parentId,
        type: 'other',
        isStatusZone: false,
      ));
      if (!mounted) return;
      setState(() {
        _all = [..._all, created];
        if (parentId == null) {
          _furnitureId = created.id;
          _compartmentId = null;
          _slotId = null;
        } else if (parentId == _furnitureId) {
          _compartmentId = created.id;
          _slotId = null;
        } else {
          _slotId = created.id;
        }
      });
      _report();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not add: $e')));
      }
    }
  }

  Future<String?> _promptName(String level) async {
    String value = '';
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add $level'),
        content: TextField(
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => value = v,
          onSubmitted: (_) {
            final n = value.trim();
            Navigator.pop(ctx, n.isEmpty ? null : n);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final n = value.trim();
              Navigator.pop(ctx, n.isEmpty ? null : n);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationDropdown(
          label: 'Storage furniture',
          hint: 'e.g. Safe, Cabinet, Shelf…',
          items: _furniture,
          selectedId: _furnitureId,
          enabled: widget.enabled,
          canAdd: widget.sellerId != null,
          onChanged: (id) {
            setState(() {
              _furnitureId = id;
              _compartmentId = null;
              _slotId = null;
            });
            _report();
          },
          onAddNew: () => _addInline('furniture', null),
          onClear: () {
            setState(() {
              _furnitureId = null;
              _compartmentId = null;
              _slotId = null;
            });
            _report();
          },
        ),
        if (_furnitureId != null) ...[
          const SizedBox(height: 12),
          _LocationDropdown(
            label: 'Compartment',
            hint: 'e.g. Tray, Drawer, Box…',
            items: _compartments,
            selectedId: _compartmentId,
            enabled: widget.enabled,
            canAdd: widget.sellerId != null,
            onChanged: (id) {
              setState(() {
                _compartmentId = id;
                _slotId = null;
              });
              _report();
            },
            onAddNew: () => _addInline('compartment', _furnitureId),
            onClear: () {
              setState(() {
                _compartmentId = null;
                _slotId = null;
              });
              _report();
            },
          ),
        ],
        if (_compartmentId != null) ...[
          const SizedBox(height: 12),
          _LocationDropdown(
            label: 'Slot (optional)',
            hint: 'e.g. Slot 1, Section A…',
            items: _slots,
            selectedId: _slotId,
            enabled: widget.enabled,
            canAdd: widget.sellerId != null,
            onChanged: (id) {
              setState(() => _slotId = id);
              _report();
            },
            onAddNew: () => _addInline('slot', _compartmentId),
            onClear: () {
              setState(() => _slotId = null);
              _report();
            },
          ),
        ],
      ],
    );
  }
}

// ── Single dropdown level ─────────────────────────────────────────────────────

class _LocationDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<Location> items;
  final String? selectedId;
  final bool enabled;
  final bool canAdd;
  final void Function(String? id) onChanged;
  final VoidCallback onAddNew;
  final VoidCallback onClear;

  const _LocationDropdown({
    required this.label,
    required this.hint,
    required this.items,
    this.selectedId,
    required this.enabled,
    required this.canAdd,
    required this.onChanged,
    required this.onAddNew,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final validId = items.any((l) => l.id == selectedId) ? selectedId : null;

    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        suffixIcon: validId != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: enabled ? onClear : null,
                tooltip: 'Clear',
              )
            : null,
      ),
      child: DropdownButton<String?>(
        value: validId,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text(
          hint,
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
        ),
        items: [
          ...items.map(
            (l) => DropdownMenuItem(
              value: l.id,
              child: Text(l.name, overflow: TextOverflow.ellipsis),
            ),
          ),
          if (canAdd)
            DropdownMenuItem(
              value: _kAddNew,
              child: Row(
                children: [
                  Icon(Icons.add, size: 16, color: cs.primary),
                  const SizedBox(width: 6),
                  Text(
                    '+ Add new',
                    style: TextStyle(color: cs.primary, fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
        onChanged: enabled
            ? (v) {
                if (v == _kAddNew) {
                  onAddNew();
                } else {
                  onChanged(v);
                }
              }
            : null,
      ),
    );
  }
}
