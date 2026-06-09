import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../repositories/customer_repository.dart';
import '../../shared/form_widgets.dart';

class AddEditCustomerPage extends StatefulWidget {
  final Customer? customer;
  const AddEditCustomerPage({super.key, this.customer});

  @override
  State<AddEditCustomerPage> createState() => _AddEditCustomerPageState();
}

class _AddEditCustomerPageState extends State<AddEditCustomerPage> {
  final _repository = CustomerRepository();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _country = TextEditingController();
  final _notes = TextEditingController();

  String _type = 'individual';
  String? _manualTier;
  bool _saving = false;

  bool get _isEdit => widget.customer != null;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    if (c != null) {
      _name.text = c.name;
      _email.text = c.email;
      _phone.text = c.phone;
      _country.text = c.country;
      _notes.text = c.notes;
      _type = c.type;
      _manualTier = c.manualTier;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _country.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Name is required')));
      return;
    }

    setState(() => _saving = true);
    try {
      final customer = Customer(
        id: widget.customer?.id,
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        country: _country.text.trim(),
        type: _type,
        manualTier: _manualTier,
        notes: _notes.text.trim(),
      );

      if (_isEdit) {
        await _repository.updateCustomer(widget.customer!.id!, customer);
      } else {
        await _repository.addCustomer(customer);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Customer' : 'Add Customer'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const FormSection('Identity'),
            FormTextField('Name *', _name),
            FormTextField('Email', _email,
                keyboardType: TextInputType.emailAddress),
            FormTextField('Phone', _phone,
                keyboardType: TextInputType.phone),
            FormTextField('Country', _country),
            const FormSection('Classification'),
            FormDropdownField<String>(
              label: 'Customer Type',
              value: _type,
              items: const ['individual', 'business'],
              onChanged: (v) => setState(() => _type = v ?? 'individual'),
              itemLabel: (v) => v == 'business' ? 'Business' : 'Individual',
            ),
            FormDropdownField<String?>(
              label: 'Tier Override',
              value: _manualTier,
              items: CustomerTiers.manualOptions,
              onChanged: (v) => setState(() => _manualTier = v),
              itemLabel: (v) => v ?? 'Auto (computed from spend)',
            ),
            const FormSection('Notes'),
            FormTextField('Notes', _notes, maxLines: 3),
          ],
        ),
      ),
    );
  }
}
