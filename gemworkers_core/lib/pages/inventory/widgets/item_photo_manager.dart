import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ── Data ──────────────────────────────────────────────────────────────────────

/// Represents a single photo in the inventory photo list.
/// Either an already-uploaded [url] (existing item) or a locally-picked
/// [file]+[bytes] pair that has not been uploaded yet.
class PhotoItem {
  static int _seq = 0;

  final String? url;
  final XFile? file;
  final Uint8List? bytes;

  /// Stable key used as [ValueKey] in [ReorderableListView].
  final String widgetKey;

  PhotoItem.existing(String existingUrl)
      : url = existingUrl,
        file = null,
        bytes = null,
        widgetKey = 'e_$existingUrl';

  PhotoItem.newPick(XFile xfile, Uint8List data)
      : url = null,
        file = xfile,
        bytes = data,
        widgetKey = 'n_${_seq++}';

  bool get isExisting => url != null;
}

// ── Widget ────────────────────────────────────────────────────────────────────

/// Horizontal scrollable photo row with drag-to-reorder, "Cover" badge on the
/// first photo, per-photo remove button, and a bulk photo picker.
///
/// The parent owns the [photos] list and receives every mutation via
/// [onChanged] — pass `onChanged: (u) => setState(() => _photos = u)`.
class ItemPhotoManager extends StatelessWidget {
  final List<PhotoItem> photos;
  final ValueChanged<List<PhotoItem>> onChanged;
  final bool enabled;

  /// Optional: called with the tapped photo's index. Use to open a full-screen
  /// gallery from the parent (only meaningful for existing/uploaded photos).
  final ValueChanged<int>? onPhotoTap;

  static const int maxPhotos = 10;

  const ItemPhotoManager({
    super.key,
    required this.photos,
    required this.onChanged,
    this.enabled = true,
    this.onPhotoTap,
  });

  Future<void> _pickPhotos(BuildContext context) async {
    final remaining = maxPhotos - photos.length;
    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can add up to 10 photos per item.')),
      );
      return;
    }

    final picked = await ImagePicker().pickMultiImage(imageQuality: 85);
    if (picked.isEmpty || !context.mounted) return;

    final toAdd = picked.take(remaining).toList();
    if (picked.length > remaining) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only $remaining more photo${remaining == 1 ? '' : 's'} can be '
              'added. Added the first $remaining.',
            ),
          ),
        );
      }
    }

    final bytes = await Future.wait(toAdd.map((f) => f.readAsBytes()));
    if (!context.mounted) return;

    final updated = List<PhotoItem>.from(photos);
    for (var i = 0; i < toAdd.length; i++) {
      updated.add(PhotoItem.newPick(toAdd[i], bytes[i]));
    }
    onChanged(updated);
  }

  void _reorder(int oldIndex, int newIndex) {
    final updated = List<PhotoItem>.from(photos);
    updated.insert(newIndex, updated.removeAt(oldIndex));
    onChanged(updated);
  }

  void _remove(int index) {
    onChanged(List<PhotoItem>.from(photos)..removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Photos',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
            if (photos.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                '${photos.length}/$maxPhotos',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const Spacer(),
            if (photos.length < maxPhotos)
              TextButton.icon(
                onPressed: enabled ? () => _pickPhotos(context) : null,
                icon: const Icon(Icons.add_a_photo_outlined, size: 18),
                label: const Text('Add Photos'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
        if (photos.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Optional — photos can also be added after saving.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 108,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: enabled,
              onReorderItem: enabled ? _reorder : (_, _) {},
              itemCount: photos.length,
              itemBuilder: (_, index) => _PhotoTile(
                key: ValueKey(photos[index].widgetKey),
                photo: photos[index],
                isCover: index == 0,
                onRemove: enabled ? () => _remove(index) : null,
                onTap: onPhotoTap != null ? () => onPhotoTap!(index) : null,
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final PhotoItem photo;
  final bool isCover;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const _PhotoTile({
    super.key,
    required this.photo,
    required this.isCover,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: photo.isExisting
                ? Image.network(
                    photo.url!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  )
                : Image.memory(
                    photo.bytes!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
          ),
          if (isCover)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Cover',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}
