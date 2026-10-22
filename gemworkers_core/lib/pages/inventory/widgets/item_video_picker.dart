import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../repositories/inventory_repository.dart';

/// The stone's video while the form is open. [currentUrl] is what is saved
/// now (uploaded file or old YouTube/Vimeo link); [pending] is a newly picked
/// file that the page uploads on save. [removed] = clear the video on save.
class VideoChoice {
  final String? currentUrl;
  final XFile? pending;
  final Uint8List? pendingBytes;
  final bool removed;

  const VideoChoice({
    this.currentUrl,
    this.pending,
    this.pendingBytes,
    this.removed = false,
  });

  bool get hasVideo => pending != null || (!removed && currentUrl != null);
}

/// Etsy-style video: one short silent clip per stone, shown in the store's
/// photo gallery as a looping item. MP4 / MOV / WebM, up to 50 MB.
class ItemVideoPicker extends StatelessWidget {
  final VideoChoice value;
  final ValueChanged<VideoChoice> onChanged;
  final bool enabled;

  const ItemVideoPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  static const int maxBytes = 50 * 1024 * 1024;
  static const _types = {'mp4', 'mov', 'webm'};

  Future<void> _pick(BuildContext context) async {
    final picked = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (picked == null || !context.mounted) return;

    final ext = picked.name.contains('.')
        ? picked.name.split('.').last.toLowerCase()
        : '';
    if (!_types.contains(ext)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please choose an MP4, MOV or WebM video.')));
      return;
    }
    final bytes = await picked.readAsBytes();
    if (!context.mounted) return;
    if (bytes.length > maxBytes) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('That video is larger than 50 MB. Please trim it to '
              '5–15 seconds or choose a smaller file.')));
      return;
    }
    onChanged(VideoChoice(
      currentUrl: value.currentUrl,
      pending: picked,
      pendingBytes: bytes,
    ));
  }

  void _remove() {
    onChanged(VideoChoice(currentUrl: value.currentUrl, removed: true));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600);

    final String status;
    if (value.pending != null) {
      final mb = (value.pendingBytes!.length / (1024 * 1024)).toStringAsFixed(1);
      status = 'New video: ${value.pending!.name} ($mb MB) — uploaded when you save';
    } else if (value.removed || value.currentUrl == null) {
      status = 'No video';
    } else if (InventoryRepository.isUploadedVideo(value.currentUrl)) {
      status = 'Video added ✓';
    } else {
      status = 'Old video link: ${value.currentUrl}';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.videocam_outlined,
                  color: value.hasVideo ? theme.colorScheme.primary : Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(status,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: enabled ? () => _pick(context) : null,
                icon: const Icon(Icons.upload_outlined, size: 18),
                label: Text(value.hasVideo ? 'Replace video' : 'Add video'),
              ),
              if (value.hasVideo)
                TextButton(
                  onPressed: enabled ? _remove : null,
                  child: const Text('Remove video'),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'A short clip of 5–15 seconds works best — turn the stone in the '
            'light. It plays silently on a loop in the photo gallery. '
            'iPhone: set Settings → Camera → Formats to "Most Compatible" so '
            'every browser can play it.',
            style: muted,
          ),
        ],
      ),
    );
  }
}
