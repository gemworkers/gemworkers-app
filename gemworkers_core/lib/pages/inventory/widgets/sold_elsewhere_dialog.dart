import 'package:flutter/material.dart';

/// "Sold elsewhere" (Etsy, Instagram, fair, in person). Returns how many units
/// were sold, or null when cancelled. One-of-a-kind stones (stock 1) get the
/// plain yes/no question; listings with more in stock ask how many
/// (sql/quantity_listings.sql).
Future<int?> askSoldElsewhere(BuildContext context, {required String title, required int inStock}) {
  var units = 1;
  return showDialog<int>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Sold somewhere else?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (inStock > 1) ...[
              Text('"$title" — $inStock in stock. How many did you sell elsewhere?'),
              const SizedBox(height: 12),
              DropdownButton<int>(
                value: units,
                items: [for (var n = 1; n <= inStock; n++) DropdownMenuItem(value: n, child: Text('$n'))],
                onChanged: (v) => setState(() => units = v ?? 1),
              ),
              const SizedBox(height: 8),
              Text(units >= inStock
                  ? 'None left: the listing is taken off GemWorkers and marked as sold.'
                  : '${inStock - units} stay for sale on GemWorkers.'),
            ] else
              Text('"$title" is taken off GemWorkers right away and marked as sold.'),
            const SizedBox(height: 12),
            const Text('This is not a GemWorkers sale: no order, invoice or fee is made.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, units), child: const Text('Yes, sold elsewhere')),
        ],
      ),
    ),
  );
}
