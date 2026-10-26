import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/user_profile_service.dart';

/// Vacation mode (sql/vacation_mode.sql): the seller's stones are hidden from
/// the shop and no new purchases/offers come in, until switched off or the
/// return date. [sellerId]: owner choosing a seller; null = your own shop.
Future<void> showVacationDialog(BuildContext context, {String? sellerId}) async {
  final db = Supabase.instance.client;
  final id = sellerId ?? UserProfileService.instance.sellerId;
  if (id == null) return;
  Map<String, dynamic>? row;
  try {
    row = await db.from('sellers').select('name, on_vacation, vacation_until').eq('id', id).maybeSingle();
  } catch (_) {}
  if (!context.mounted || row == null) return;

  var on = row['on_vacation'] == true;
  DateTime? until = row['vacation_until'] != null ? DateTime.parse(row['vacation_until'].toString()) : null;

  final save = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setLocal) => AlertDialog(
        title: Text(sellerId != null ? 'Vacation mode · ${row!['name']}' : 'Vacation mode'),
        content: SizedBox(
          width: 440,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            SwitchListTile(
              value: on,
              onChanged: (v) => setLocal(() => on = v),
              title: const Text('On vacation'),
              subtitle: const Text('Stones are hidden from the shop; no new orders or offers.'),
              contentPadding: EdgeInsets.zero,
            ),
            if (on) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.event_outlined, size: 18),
                label: Text(until == null
                    ? 'Set a return date (optional)'
                    : 'Back on ${DateFormat('EEE d MMM y').format(until!)}'),
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: ctx,
                    firstDate: DateTime(now.year, now.month, now.day),
                    lastDate: now.add(const Duration(days: 365)),
                    initialDate: until ?? now.add(const Duration(days: 7)),
                  );
                  if (picked != null) setLocal(() => until = picked);
                },
              ),
              if (until != null)
                TextButton(onPressed: () => setLocal(() => until = null), child: const Text('No return date')),
              const SizedBox(height: 8),
              const Text(
                'Orders that are already paid still need to be shipped. Messages still arrive. '
                'With a return date, the stones come back by themselves that morning.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    ),
  );
  if (save != true || !context.mounted) return;
  try {
    await db.rpc('set_seller_vacation', params: {
      'p_on': on,
      'p_until': on && until != null ? DateFormat('yyyy-MM-dd').format(until!) : null,
      'p_seller': sellerId,
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(on ? 'Vacation mode on — stones are hidden from the shop.' : 'Welcome back — stones are visible again.'),
      ));
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }
}
