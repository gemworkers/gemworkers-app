import 'package:flutter/material.dart';

/// Asks the owner to confirm rejecting a seller's listing, with an optional
/// reason that the seller sees in the admin and in their email.
/// Returns the reason ('' for none), or null when cancelled.
Future<String?> showRejectListingDialog(BuildContext context, String title) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reject this listing?'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('"$title" stays a draft and is not shown on the store. '
                'The seller is emailed and can fix it and send it again.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Reason for the seller (optional)',
                hintText: 'e.g. Photos are too dark — please retake in daylight',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel')),
        FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Reject')),
      ],
    ),
  ).whenComplete(controller.dispose);
}
