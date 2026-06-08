import 'package:flutter/material.dart';

import '../../models/supplier.dart';
import '../../repositories/supplier_repository.dart';
import '../../shared/form_widgets.dart';

/// Pass [supplier] for edit mode; omit (null) for add mode.
class AddEditSupplierPage extends StatefulWidget {
  final Supplier? supplier;

  const AddEditSupplierPage({super.key, this.supplier});

  bool get isEditing => supplier != null;

  @override
  State<AddEditSupplierPage> createState() => _AddEditSupplierPageState();
}

class _AddEditSupplierPageState extends State<AddEditSupplierPage> {
  final _repository = SupplierRepository();

  late final TextEditingController _name;
  late final TextEditingController _country;
  late final TextEditingController _contactName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _notes;

  late double _reliabilityScore;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.supplier;
    _name = TextEditingController(text: s?.name ?? '');
    _country = TextEditingController(text: s?.country ?? '');
    _contactName = TextEditingController(text: s?.contactName ?? '');
    _email = TextEditingController(text: s?.email ?? '');
    _phone = TextEditingController(text: s?.phone ?? '');
    _notes = TextEditingController(text: s?.notes ?? '');
    _reliabilityScore = s?.reliabilityScore ?? 0;
  }

  @override
  void dispose() {
    for (final c in [_name, _country, _contactName, _email, _phone, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Validation & save ─────────────────────────────────────────────────────

  String? _validate() {
    if (_name.text.trim().isEmpty) return 'Supplier name is required.';
    return null;
  }

  Future<void> _save() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _saving = true);
    try {
      final data = Supplier(
        id: widget.supplier?.id,
        name: _name.text.trim(),
        country: _country.text.trim(),
        contactName: _contactName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        reliabilityScore: _reliabilityScore,
        notes: _notes.text.trim(),
      );

      if (widget.isEditing) {
        await _repository.updateSupplier(widget.supplier!.id!, data);
        if (mounted) Navigator.pop(context, data);
      } else {
        await _repository.addSupplier(data);
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Supplier' : 'Add Supplier'),
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
          const FormSection('Supplier Info'),
          FormTextField('Name *', _name),
          FormTextField('Country', _country),

          const FormSection('Contact'),
          FormTextField('Contact Name', _contactName),
          FormTextField('Email', _email, keyboardType: TextInputType.emailAddress),
          FormTextField('Phone', _phone, keyboardType: TextInputType.phone),

          const FormSection('Reliability'),
          _ReliabilitySlider(
            value: _reliabilityScore,
            onChanged: (v) => setState(() => _reliabilityScore = v),
          ),

          const FormSection('Notes'),
          FormTextField('Notes', _notes, maxLines: 4),

          const SizedBox(height: 32),
          FilledButton(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _saving
                ? const CircularProgressIndicator()
                : Text(widget.isEditing ? 'Save Changes' : 'Add Supplier'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Reliability slider ────────────────────────────────────────────────────────

class _ReliabilitySlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const _ReliabilitySlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StarRow(value),
              const SizedBox(width: 12),
              Text(
                value.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                ' / 5',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 0,
            max: 5,
            divisions: 10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final full = i < rating.floor();
        final half = !full && i < rating;
        return Icon(
          full ? Icons.star : half ? Icons.star_half : Icons.star_border,
          size: 20,
          color: Colors.amber,
        );
      }),
    );
  }
}
