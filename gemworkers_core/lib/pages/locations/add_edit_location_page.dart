import 'package:flutter/material.dart';

import '../../models/location.dart';
import '../../repositories/location_repository.dart';

// ── Type definitions ──────────────────────────────────────────────────────────

const _kTypes = [
  'safe',
  'cabinet',
  'shelf',
  'drawer',
  'tray',
  'box',
  'section',
  'slot',
  'other',
];

String _prefixForType(String type) => switch (type) {
      'safe' => 'SFE',
      'cabinet' => 'CAB',
      'shelf' => 'SHL',
      'drawer' => 'DRW',
      'tray' => 'TRY',
      'box' => 'BOX',
      'section' => 'SEC',
      'slot' => 'SLT',
      _ => 'OTH',
    };

// ── Page ──────────────────────────────────────────────────────────────────────

class AddEditLocationPage extends StatefulWidget {
  final Location? location;   // null = add mode
  final String? parentId;     // pre-fill parent when adding a child
  final String sellerId;
  final List<Location> existingFlat;

  const AddEditLocationPage({
    super.key,
    this.location,
    this.parentId,
    required this.sellerId,
    required this.existingFlat,
  });

  @override
  State<AddEditLocationPage> createState() => _AddEditLocationPageState();
}

class _AddEditLocationPageState extends State<AddEditLocationPage> {
  final _repo = LocationRepository();

  late String _type;
  final _customType = TextEditingController();
  final _name = TextEditingController();
  final _slotCount = TextEditingController();
  final _managerNote = TextEditingController();

  String? _parentId;
  bool _saving = false;

  bool get _isEdit => widget.location != null;

  @override
  void initState() {
    super.initState();
    final loc = widget.location;
    if (loc != null) {
      _type = _kTypes.contains(loc.type) ? loc.type : 'other';
      if (!_kTypes.contains(loc.type)) _customType.text = loc.type;
      _name.text = loc.name;
      _parentId = loc.parentId;
      _slotCount.text = loc.slotCount?.toString() ?? '';
      _managerNote.text = loc.managerNote;
    } else {
      _type = 'cabinet';
      _parentId = widget.parentId;
    }
  }

  @override
  void dispose() {
    _customType.dispose();
    _name.dispose();
    _slotCount.dispose();
    _managerNote.dispose();
    super.dispose();
  }

  // ── Code generation ───────────────────────────────────────────────────────

  String get _computedCode {
    final prefix = _prefixForType(_type);
    final siblings = widget.existingFlat.where((l) =>
        l.parentId == _parentId &&
        l.type == _type &&
        l.id != widget.location?.id).length;
    final number = (siblings + 1).toString().padLeft(3, '0');
    final ownCode = '$prefix-$number';

    if (_parentId == null) return ownCode;
    final parent = widget.existingFlat
        .where((l) => l.id == _parentId)
        .firstOrNull;
    if (parent == null || parent.code.isEmpty) return ownCode;
    return '${parent.code} · $ownCode';
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name is required.')));
      return;
    }

    final effectiveType =
        _type == 'other' && _customType.text.trim().isNotEmpty
            ? _customType.text.trim()
            : _type;

    final slotCountVal = int.tryParse(_slotCount.text.trim());

    setState(() => _saving = true);
    try {
      final location = Location(
        id: widget.location?.id,
        sellerId: widget.sellerId,
        name: name,
        code: _computedCode,
        parentId: _parentId,
        type: effectiveType,
        isStatusZone: widget.location?.isStatusZone ?? false,
        managerNote: _managerNote.text.trim(),
        slotCount: slotCountVal,
      );

      final Location saved;
      if (_isEdit) {
        await _repo.updateLocation(widget.location!.id!, location);
        saved = location;
      } else {
        saved = await _repo.addLocation(location);
      }

      // Auto-create child slot locations on add when slotCount > 0.
      if (!_isEdit && slotCountVal != null && slotCountVal > 0) {
        for (int i = 1; i <= slotCountVal; i++) {
          final slotCode = saved.code.isNotEmpty
              ? '${saved.code} · SLT-${i.toString().padLeft(3, '0')}'
              : 'SLT-${i.toString().padLeft(3, '0')}';
          await _repo.addLocation(Location(
            sellerId: widget.sellerId,
            name: 'Slot $i',
            code: slotCode,
            parentId: saved.id,
            type: 'slot',
          ));
        }
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Location' : 'Add Location'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Type ──────────────────────────────────────────────────────────
          _label('Type', cs),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _kTypes.map((t) {
              return ChoiceChip(
                label: Text(
                    t[0].toUpperCase() + t.substring(1)),
                selected: _type == t,
                onSelected: (sel) {
                  if (sel) setState(() => _type = t);
                },
              );
            }).toList(),
          ),
          if (_type == 'other') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _customType,
              decoration: const InputDecoration(
                labelText: 'Custom type name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],

          const SizedBox(height: 20),

          // ── Name ──────────────────────────────────────────────────────────
          _label('Name', cs),
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Name *',
              hintText: 'e.g. Drawer 3 — Bracelets',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 20),

          // ── Parent ────────────────────────────────────────────────────────
          _label('Parent Location', cs),
          _buildParentPicker(cs),

          const SizedBox(height: 20),

          // ── Slot count ────────────────────────────────────────────────────
          _label('Slots (optional)', cs),
          TextField(
            controller: _slotCount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'How many slots inside?',
              hintText: 'Leave blank if not using fixed slots',
              border: OutlineInputBorder(),
            ),
          ),
          if (!_isEdit && _slotCount.text.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Saving will auto-create ${int.tryParse(_slotCount.text.trim()) ?? 0} child slot locations.',
              style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
            ),
          ],

          const SizedBox(height: 20),

          // ── Auto-generated code preview ───────────────────────────────────
          _label('Auto-generated Code', cs),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _computedCode,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: cs.primary,
                    ),
                  ),
                ),
                Text(
                  'read-only',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Manager note ──────────────────────────────────────────────────
          _label('Manager Note', cs),
          TextField(
            controller: _managerNote,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Optional note',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Save Location'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _label(String text, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: cs.primary,
        ),
      ),
    );
  }

  Widget _buildParentPicker(ColorScheme cs) {
    final eligible = widget.existingFlat
        .where((l) => l.id != widget.location?.id && !l.isStatusZone)
        .toList();

    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Parent location',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButton<String?>(
        value: eligible.any((l) => l.id == _parentId) ? _parentId : null,
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          const DropdownMenuItem(
              value: null, child: Text('None (top-level)')),
          ...eligible.map((l) => DropdownMenuItem(
                value: l.id,
                child: Text(
                  l.name,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
        ],
        onChanged: (v) => setState(() => _parentId = v),
      ),
    );
  }
}
