import 'package:flutter/material.dart';

import 'inventory_form_widgets.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

const _kOriginCountries = [
  'Sri Lanka', 'Myanmar (Burma)', 'Thailand', 'Madagascar', 'Tanzania',
  'Mozambique', 'Zambia', 'Kenya', 'Nigeria', 'Brazil', 'Colombia',
  'Afghanistan', 'Pakistan', 'India', 'Australia', 'United States',
  'Canada', 'Russia', 'China', 'Vietnam', 'Cambodia', 'Nepal',
  'Namibia', 'South Africa', 'Zimbabwe', 'Ethiopia',
  'Democratic Republic of Congo', 'Malawi', 'Botswana', 'Angola',
  'Mexico', 'Peru', 'Bolivia', 'Greenland', 'Indonesia', 'Philippines',
  'Japan', 'Czech Republic',
  'Other',
];

// ── Widget ────────────────────────────────────────────────────────────────────

/// Searchable Origin Country picker with a free-text "Other" fallback,
/// mirroring the Gem Type pattern in [GemAndVarietyFields]. The supplied
/// [controller] is the source of truth at save time — this widget only
/// provides the UI layer on top.
class OriginCountryField extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const OriginCountryField({
    super.key,
    required this.controller,
    this.label = 'Country',
  });

  @override
  State<OriginCountryField> createState() => _OriginCountryFieldState();
}

class _OriginCountryFieldState extends State<OriginCountryField> {
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    final current = widget.controller.text.trim();
    if (current.isEmpty) {
      _dropdownValue = null;
    } else if (_kOriginCountries.contains(current)) {
      _dropdownValue = current;
    } else {
      // Existing data is a custom country → show "Other" in the dropdown,
      // leave the controller text as-is for the free-text field.
      _dropdownValue = 'Other';
    }
  }

  void _onSelected(String? value) {
    if (value == null) return;
    setState(() {
      _dropdownValue = value;
      if (value != 'Other') {
        widget.controller.text = value;
      } else {
        widget.controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchableDropdownField(
          label: widget.label,
          hintText: 'Select country',
          value: _dropdownValue,
          options: _kOriginCountries,
          onChanged: _onSelected,
        ),
        if (_dropdownValue == 'Other')
          FormTextField('Specify country', widget.controller),
      ],
    );
  }
}
