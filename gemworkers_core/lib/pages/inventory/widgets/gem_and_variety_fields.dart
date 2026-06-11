import 'package:flutter/material.dart';

import 'inventory_form_widgets.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

const _kGemTypes = [
  'Diamonds', 'Ruby', 'Sapphire', 'Emerald', 'Alexandrite', 'Aquamarine',
  'Amethyst', 'Citrine', 'Garnet', 'Morganite', 'Opal', 'Pearl', 'Peridot',
  'Spinel', 'Tanzanite', 'Topaz', 'Tourmaline', 'Turquoise', 'Zircon',
  'Quartz', 'Jade', 'Onyx', 'Moonstone', 'Labradorite', 'Sunstone', 'Apatite',
  'Iolite', 'Kunzite', 'Zoisite', 'Chrysoberyl', 'Obsidian', 'Amber', 'Coral',
  'Other',
];

const _kVarieties = <String, List<String>>{
  'Sapphire':   ['Blue', 'Pink', 'Yellow', 'White', 'Padparadscha', 'Star', 'Other'],
  'Ruby':       ['Pigeon Blood', 'Star', 'Other'],
  'Emerald':    ['Colombian', 'Zambian', 'Brazilian', 'Other'],
  'Garnet':     ['Tsavorite', 'Demantoid', 'Spessartite', 'Rhodolite', 'Almandine', 'Other'],
  'Tourmaline': ['Paraiba', 'Rubellite', 'Indicolite', 'Chrome', 'Watermelon', 'Other'],
  'Quartz':     ['Rose', 'Smoky', 'Rutilated', 'Tiger Eye', 'Amethyst', 'Citrine', 'Herkimer Diamond', 'Other'],
  'Opal':       ['White', 'Black', 'Boulder', 'Fire', 'Crystal', 'Other'],
};

// ── Widget ────────────────────────────────────────────────────────────────────

/// Gem Type dropdown (with Optional "Other" free-text) + context-aware Variety
/// field, both wired to the supplied [TextEditingController]s.
///
/// The controllers are the source of truth at save time — this widget only
/// provides the UI layer on top.
class GemAndVarietyFields extends StatefulWidget {
  final TextEditingController gemTypeController;
  final TextEditingController varietyController;

  const GemAndVarietyFields({
    super.key,
    required this.gemTypeController,
    required this.varietyController,
  });

  @override
  State<GemAndVarietyFields> createState() => _GemAndVarietyFieldsState();
}

class _GemAndVarietyFieldsState extends State<GemAndVarietyFields> {
  String? _gemDropdown;    // value shown in the gem type dropdown
  String? _varietyDropdown; // value shown in the variety dropdown (when applicable)

  @override
  void initState() {
    super.initState();
    _initFromControllers();
  }

  void _initFromControllers() {
    final gem = widget.gemTypeController.text.trim();
    if (gem.isEmpty) {
      _gemDropdown = null;
    } else if (_kGemTypes.contains(gem)) {
      _gemDropdown = gem;
      // Initialise variety dropdown if this gem has a known variety list.
      final varieties = _kVarieties[gem];
      if (varieties != null) {
        final variety = widget.varietyController.text.trim();
        if (varieties.contains(variety)) {
          _varietyDropdown = variety;
        } else if (variety.isNotEmpty) {
          // Existing data is a custom variety → show "Other" in dropdown,
          // leave the controller text as-is for the free-text field.
          _varietyDropdown = 'Other';
        }
      }
    } else {
      // Existing gem type not in the predefined list → treat as "Other".
      _gemDropdown = 'Other';
      // gemTypeController already holds the custom text.
    }
  }

  // Returns the variety options for the current gem type, or null when the gem
  // type has no defined list (meaning a free-text variety field is used).
  List<String>? get _currentVarieties {
    if (_gemDropdown == null || _gemDropdown == 'Other') return null;
    return _kVarieties[_gemDropdown!];
  }

  void _onGemTypeSelected(String? value) {
    if (value == null) return;
    setState(() {
      _gemDropdown = value;
      _varietyDropdown = null;
      widget.varietyController.clear();
      if (value != 'Other') {
        widget.gemTypeController.text = value;
      } else {
        widget.gemTypeController.clear();
      }
    });
  }

  void _onVarietySelected(String? value) {
    if (value == null) return;
    setState(() {
      _varietyDropdown = value;
      if (value != 'Other') {
        widget.varietyController.text = value;
      } else {
        widget.varietyController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final varieties = _currentVarieties;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Gem Type dropdown ─────────────────────────────────────────────
        _OutlinedDropdown(
          label: 'Gem Type',
          hint: 'Select gem type',
          value: _gemDropdown,
          items: _kGemTypes,
          onChanged: _onGemTypeSelected,
        ),

        // ── "Other" gem type — free text ──────────────────────────────────
        if (_gemDropdown == 'Other')
          FormTextField('Specify gem type', widget.gemTypeController),

        // ── Variety ───────────────────────────────────────────────────────
        if (_gemDropdown != null) ...[
          if (varieties != null) ...[
            _OutlinedDropdown(
              label: 'Variety',
              hint: 'Select variety',
              value: _varietyDropdown,
              items: varieties,
              onChanged: _onVarietySelected,
            ),
            if (_varietyDropdown == 'Other')
              FormTextField('Specify variety', widget.varietyController),
          ] else
            FormTextField('Variety', widget.varietyController),
        ],
      ],
    );
  }
}

// ── Private helper ────────────────────────────────────────────────────────────

class _OutlinedDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _OutlinedDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          hint: Text(hint,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14)),
          items: items
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
