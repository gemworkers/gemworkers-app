import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/branch.dart';
import '../../repositories/branch_repository.dart';

class AddEditBranchPage extends StatefulWidget {
  final Branch? branch;
  const AddEditBranchPage({super.key, this.branch});

  @override
  State<AddEditBranchPage> createState() => _AddEditBranchPageState();
}

class _AddEditBranchPageState extends State<AddEditBranchPage> {
  final _repo = BranchRepository();
  bool _saving = false;

  final _name = TextEditingController();
  final _country = TextEditingController();
  final _contactNote = TextEditingController();
  final _notes = TextEditingController();
  final _commissionRatePct = TextEditingController(); // UI in %, stored /100
  final _userFee = TextEditingController();
  final _startingFee = TextEditingController();

  String _status = 'active';
  String? _userFeePeriod;
  DateTime? _joinedDate;

  bool get _isEdit => widget.branch != null;

  @override
  void initState() {
    super.initState();
    final b = widget.branch;
    if (b != null) {
      _name.text = b.name;
      _country.text = b.country;
      _contactNote.text = b.contactNote;
      _notes.text = b.notes;
      _status = b.status;
      _joinedDate = b.joinedDate;
      if (b.commissionRate != null) {
        _commissionRatePct.text =
            (b.commissionRate! * 100).toStringAsFixed(2);
      }
      if (b.userFee != null) {
        _userFee.text = b.userFee!.toStringAsFixed(2);
      }
      if (b.startingFee != null) {
        _startingFee.text = b.startingFee!.toStringAsFixed(2);
      }
      _userFeePeriod = b.userFeePeriod;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _country.dispose();
    _contactNote.dispose();
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
          const SnackBar(content: Text('Branch name is required')));
      return;
    }

    setState(() => _saving = true);
    try {
      final commissionPct = double.tryParse(_commissionRatePct.text);
      final branch = Branch(
        name: name,
        country: _country.text.trim(),
        contactNote: _contactNote.text.trim(),
        status: _status,
        commissionRate: commissionPct != null ? commissionPct / 100 : null,
        userFee: double.tryParse(_userFee.text),
        userFeePeriod:
            _userFeePeriod?.isEmpty ?? true ? null : _userFeePeriod,
        startingFee: double.tryParse(_startingFee.text),
        joinedDate: _joinedDate,
        notes: _notes.text.trim(),
      );

      if (_isEdit) {
        await _repo.updateBranch(widget.branch!.id!, branch);
      } else {
        await _repo.addBranch(branch);
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
        title: Text(_isEdit ? 'Edit Branch' : 'New Branch'),
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
            _section('Branch Details'),
            _field('Name *', _name),
            _field('Country Code', _country,
                hint: 'e.g. NL, TH, US'),
            _field('Contact Note', _contactNote, maxLines: 2),
            _statusDropdown(),
            _datePicker(),

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

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              DropdownMenuItem(
                  value: 'annual', child: Text('Annual')),
              DropdownMenuItem(
                  value: 'weekly', child: Text('Weekly')),
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
