import 'package:flutter/material.dart';

/// Confirms a shipment and asks for an optional tracking number.
/// Returns null when cancelled, otherwise a record with the tracking number
/// (null if left empty).
Future<({String? tracking})?> showMarkShippedDialog(
    BuildContext context) async {
  final trackingCtrl = TextEditingController();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Mark as Shipped'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confirm shipment. Add a tracking number so the buyer '
            'can check delivery status.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: trackingCtrl,
            decoration: const InputDecoration(
              labelText: 'Tracking number (optional)',
              isDense: true,
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Mark as Shipped'),
        ),
      ],
    ),
  );
  final tracking =
      trackingCtrl.text.trim().isEmpty ? null : trackingCtrl.text.trim();
  trackingCtrl.dispose();
  if (confirmed != true) return null;
  return (tracking: tracking);
}
