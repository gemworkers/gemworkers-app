import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';
import '../../core/utils/open_url/open_url.dart';

/// GemWorkers' own social media accounts (sql/social_links.sql). Owner: edit
/// the links (store_settings social_*). Sellers: open them to follow / share.
/// The store footer shows the same links (public_social_links).
const socialPlatforms = <(String, String, IconData)>[
  ('instagram', 'Instagram', Icons.camera_alt_outlined),
  ('facebook', 'Facebook', Icons.facebook),
  ('tiktok', 'TikTok', Icons.music_note_outlined),
  ('pinterest', 'Pinterest', Icons.push_pin_outlined),
  ('youtube', 'YouTube', Icons.play_circle_outline),
  ('x', 'X (Twitter)', Icons.alternate_email),
];

Future<void> showSocialLinksDialog(BuildContext context) async {
  final db = Supabase.instance.client;
  final isOwner = UserProfileService.instance.isOwner;
  Map<String, String> links = {};
  try {
    final row = await db.from('public_social_links').select().maybeSingle();
    links = {for (final e in (row ?? {}).entries) if (e.value != null) e.key: e.value.toString()};
  } catch (_) {}
  if (!context.mounted) return;

  final c = {for (final p in socialPlatforms) p.$1: TextEditingController(text: links[p.$1] ?? '')};

  final save = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('GemWorkers on social media'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOwner
                    ? 'Paste the full link of each GemWorkers account (starting with https://). '
                      'Leave a box empty to hide that icon. The shop footer updates by itself.'
                    : 'Follow GemWorkers and share our posts. To share a stone, use Share on the stone.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              for (final p in socialPlatforms)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: isOwner
                      ? TextField(
                          controller: c[p.$1],
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(labelText: p.$2, prefixIcon: Icon(p.$3)),
                        )
                      : (links[p.$1] == null
                          ? const SizedBox.shrink()
                          : ListTile(
                              leading: Icon(p.$3),
                              title: Text(p.$2),
                              subtitle: Text(links[p.$1]!, overflow: TextOverflow.ellipsis),
                              onTap: () => openUrl(links[p.$1]!),
                              contentPadding: EdgeInsets.zero,
                            )),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(isOwner ? 'Cancel' : 'Close')),
        if (isOwner) FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
      ],
    ),
  );

  if (save == true && isOwner) {
    final bad = <String>[];
    final rows = <Map<String, dynamic>>[];
    for (final p in socialPlatforms) {
      final v = c[p.$1]!.text.trim();
      if (v.isNotEmpty && !v.startsWith('https://')) bad.add(p.$2);
      rows.add({'key': 'social_${p.$1}', 'value': v, 'updated_at': DateTime.now().toIso8601String()});
    }
    if (bad.isNotEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Not saved: ${bad.join(', ')} must start with https://'),
        ));
      }
    } else {
      try {
        await db.from('store_settings').upsert(rows, onConflict: 'key');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Social media links saved. A link on the wrong website is not shown on the shop.'),
          ));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
        }
      }
    }
  }
  for (final ctl in c.values) {
    ctl.dispose();
  }
}
