import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/seller.dart';
import '../../repositories/seller_repository.dart';

class AddEditSellerPage extends StatefulWidget {
  final Seller? seller;
  const AddEditSellerPage({super.key, this.seller});

  @override
  State<AddEditSellerPage> createState() => _AddEditSellerPageState();
}

class _AddEditSellerPageState extends State<AddEditSellerPage> {
  final _repo = SellerRepository();
  bool _saving = false;

  final _name = TextEditingController();
  final _country = TextEditingController();
  final _contactName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _notes = TextEditingController();
  final _commissionRatePct = TextEditingController(); // UI in %, stored /100
  final _userFee = TextEditingController();
  final _startingFee = TextEditingController();

  String _status = 'active';
  String? _userFeePeriod;
  DateTime? _joinedDate;

  bool get _isEdit => widget.seller != null;

  @override
  void initState() {
    super.initState();
    final s = widget.seller;
    if (s != null) {
      _name.text = s.name;
      _country.text = s.country;
      _contactName.text = s.contactName;
      _email.text = s.email;
      _phone.text = s.phone;
      _notes.text = s.notes;
      _status = s.status;
      _joinedDate = s.joinedDate;
      if (s.commissionRate != null) {
        _commissionRatePct.text =
            (s.commissionRate! * 100).toStringAsFixed(2);
      }
      if (s.userFee != null) {
        _userFee.text = s.userFee!.toStringAsFixed(2);
      }
      if (s.startingFee != null) {
        _startingFee.text = s.startingFee!.toStringAsFixed(2);
      }
      _userFeePeriod = s.userFeePeriod;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _country.dispose();
    _contactName.dispose();
    _email.dispose();
    _phone.dispose();
    _notes.dispose();
    _commissionRatePct.dispose();
    _userFee.dispose();
    _startingFee.dispose();
    super.dispose();
  }

  Future<void> _pickJoinedDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _joinedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _joinedDate = picked);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seller name is required')));
      return;
    }

    setState(() => _saving = true);
    try {
      final commissionPct = double.tryParse(_commissionRatePct.text);
      final seller = Seller(
        name: name,
        country: _country.text.trim(),
        contactName: _contactName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        status: _status,
        commissionRate:
            commissionPct != null ? commissionPct / 100 : null,
        userFee: double.tryParse(_userFee.text),
        userFeePeriod:
            _userFeePeriod?.isEmpty ?? true ? null : _userFeePeriod,
        startingFee: double.tryParse(_startingFee.text),
        joinedDate: _joinedDate,
        notes: _notes.text.trim(),
      );

      if (_isEdit) {
        await _repo.updateSeller(widget.seller!.id!, seller);
      } else {
        await _repo.addSeller(seller);
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
        title: Text(_isEdit ? 'Edit Seller' : 'New Seller'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
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
            _section('Seller Details'),
            _field('Shop Name *', _name),
            _field('Country Code', _country, hint: 'e.g. NL, TH, US'),
            _statusDropdown(),
            _datePicker(),

            _section('Contact'),
            _field('Contact Name', _contactName),
            _field('Email', _email,
                hint: 'contact@example.com',
                keyboardType: TextInputType.emailAddress),
            _field('Phone', _phone,
                keyboardType: TextInputType.phone),

            _section('Fee Settings'),
            _numField('Commission Rate (%)', _commissionRatePct,
                hint: 'e.g. 5 for 5%'),
            _numField('User Fee (€)', _userFee),
            _userFeePeriodDropdown(),
            _numField('Starting / Onboarding Fee (€)', _startingFee),

            _section('Notes'),
            _field('Notes', _notes, maxLines: 3),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section(String label) => Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _numField(String label, TextEditingController ctrl,
      {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _statusDropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Status',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: DropdownButton<String>(
            value: _status,
            isExpanded: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(
                  value: 'suspended', child: Text('Suspended')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _status = v);
            },
          ),
        ),
      );

  Widget _userFeePeriodDropdown() => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'User Fee Period',
            border: OutlineInputBorder(),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
          child: DropdownButton<String?>(
            value: _userFeePeriod,
            isExpanded: true,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: null, child: Text('—')),
              DropdownMenuItem(
                  value: 'monthly', child: Text('Monthly')),
              DropdownMenuItem(value: 'annual', child: Text('Annual')),
              DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
            ],
            onChanged: (v) => setState(() => _userFeePeriod = v),
          ),
        ),
      );

  Widget _datePicker() {
    final label = _joinedDate != null
        ? '${_joinedDate!.day.toString().padLeft(2, '0')}/'
            '${_joinedDate!.month.toString().padLeft(2, '0')}/'
            '${_joinedDate!.year}'
        : 'Not set';
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: _pickJoinedDate,
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Joined Date',
            border: OutlineInputBorder(),
            suffixIcon:
                Icon(Icons.calendar_today_outlined, size: 18),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
