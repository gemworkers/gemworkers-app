import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/maker.dart';
import '../../repositories/maker_repository.dart';
import '../../shared/form_widgets.dart';

/// Pass [maker] for edit mode; omit for add mode. Pops true when something
/// was saved or deleted.
class AddEditMakerPage extends StatefulWidget {
  final Maker? maker;
  const AddEditMakerPage({super.key, this.maker});

  bool get isEditing => maker != null;

  @override
  State<AddEditMakerPage> createState() => _AddEditMakerPageState();
}

class _AddEditMakerPageState extends State<AddEditMakerPage> {
  final _repository = MakerRepository();

  late final TextEditingController _name;
  late final TextEditingController _place;
  late final TextEditingController _story;
  String? _photoUrl;
  bool _uploading = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final m = widget.maker;
    _name = TextEditingController(text: m?.name ?? '');
    _place = TextEditingController(text: m?.place ?? '');
    _story = TextEditingController(text: m?.story ?? '');
    _photoUrl = m?.photoUrl;
  }

  @override
  void dispose() {
    for (final c in [_name, _place, _story]) {
      c.dispose();
    }
    super.dispose();
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1200);
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final url =
          await _repository.uploadPhoto(await picked.readAsBytes(), picked.name);
      if (mounted) setState(() => _photoUrl = url);
    } catch (e) {
      if (mounted) _snack('Photo upload failed: $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      _snack('Name is required.');
      return;
    }
    if (name.length > 80) {
      _snack('Name can be at most 80 characters.');
      return;
    }

    setState(() => _saving = true);
    try {
      final data = Maker(
        id: widget.maker?.id,
        name: name,
        place: _place.text.trim(),
        story: _story.text.trim(),
        photoUrl: _photoUrl,
      );
      if (widget.isEditing) {
        await _repository.updateMaker(widget.maker!.id!, data);
      } else {
        await _repository.addMaker(data);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _snack('Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final maker = widget.maker!;
    final stones = await _repository.countStones(maker.id!);
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${maker.name}?'),
        content: Text(stones == 0
            ? 'This maker is not credited on any stone.'
            : 'This maker is credited on $stones stone${stones == 1 ? '' : 's'}. '
                'Those stones stay, but will no longer show a maker.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _saving = true);
    try {
      await _repository.deleteMaker(maker.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        _snack('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _saving || _uploading;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Maker' : 'Add Maker'),
        actions: [
          if (widget.isEditing)
            IconButton(
              tooltip: 'Delete maker',
              icon: const Icon(Icons.delete_outline),
              onPressed: busy ? null : _delete,
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: busy ? null : _save,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const FormSection('Photo'),
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                foregroundImage:
                    _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                child: _uploading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : const Icon(Icons.person_outline, size: 36),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: busy ? null : _pickPhoto,
                icon: const Icon(Icons.photo_outlined),
                label: Text(_photoUrl == null ? 'Add photo' : 'Change photo'),
              ),
              if (_photoUrl != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: busy ? null : () => setState(() => _photoUrl = null),
                  child: const Text('Remove'),
                ),
              ],
            ],
          ),

          const FormSection('Maker'),
          FormTextField('Name * (shown to buyers)', _name),
          FormTextField('Place, e.g. Chanthaburi, Thailand', _place),

          const FormSection('Story (optional, shown on the Makers page)'),
          FormTextField('Story', _story, maxLines: 6),

          const SizedBox(height: 8),
          Text(
            'Buyers see this name, place, story and photo. Don\'t enter seller '
            'names or contact details here.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: busy ? null : _save,
            style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _saving
                ? const CircularProgressIndicator()
                : Text(widget.isEditing ? 'Save Changes' : 'Add Maker'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
