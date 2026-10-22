import 'package:flutter/material.dart';

import '../../../models/maker.dart';
import '../../../repositories/maker_repository.dart';
import '../../../shared/form_widgets.dart';

/// Credit line wording by product type — same rule as the store.
String makerVerb(String productType) => switch (productType) {
      'jewelry' => 'Made by',
      'specimen' => 'Collected by',
      _ => 'Cut by',
    };

/// Owner-only maker picker for Add / Edit stone. "Unknown / none" (null)
/// shows nothing on the store. Only render it for the owner — the database
/// refuses maker changes from anyone else.
class MakerPicker extends StatefulWidget {
  final String productType;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const MakerPicker({
    super.key,
    required this.productType,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<MakerPicker> createState() => _MakerPickerState();
}

class _MakerPickerState extends State<MakerPicker> {
  List<Maker> _makers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    MakerRepository().getMakers().then((makers) {
      if (mounted) setState(() { _makers = makers; _loading = false; });
    }).catchError((Object e) {
      debugPrint('MakerPicker: $e');
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: LinearProgressIndicator(),
      );
    }

    final muted = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: Colors.grey.shade600);

    if (_makers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text('No makers yet — add them under Makers in the menu.',
            style: muted),
      );
    }

    // Keep a maker that was deleted elsewhere from breaking the dropdown.
    final value = _makers.any((m) => m.id == widget.value) ? widget.value : null;
    final selected = _makers.where((m) => m.id == value).firstOrNull;
    final verb = makerVerb(widget.productType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormDropdownField<String?>(
          label: 'Maker (shown to buyers)',
          value: value,
          items: [null, ..._makers.where((m) => m.id != null).map((m) => m.id!)],
          itemLabel: (id) {
            if (id == null) return 'Unknown / none';
            final m = _makers.where((m) => m.id == id).firstOrNull;
            if (m == null) return id;
            return m.place.isEmpty ? m.name : '${m.name} · ${m.place}';
          },
          onChanged: (v) {
            if (widget.enabled) widget.onChanged(v);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Text(
            selected == null
                ? 'The store shows no maker for this item.'
                : 'The store shows: "$verb ${selected.name}'
                    '${selected.place.isEmpty ? '' : ' in ${selected.place}'}"',
            style: muted,
          ),
        ),
      ],
    );
  }
}
