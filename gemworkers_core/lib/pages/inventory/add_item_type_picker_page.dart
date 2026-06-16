import 'package:flutter/material.dart';

import 'add_inventory_page.dart';

/// First step of adding an inventory item: choose the product type before
/// the add form opens. Pushing [AddInventoryPage] on top of this page (rather
/// than replacing it) gives the user a free "back" action to change type.
class AddItemTypePickerPage extends StatelessWidget {
  const AddItemTypePickerPage({super.key});

  Future<void> _selectType(BuildContext context, String productType) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddInventoryPage(productType: productType),
      ),
    );
    if (added == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Inventory Item')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'What are you adding?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Pick a product type to see the right fields for it.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          _TypeCard(
            icon: Icons.diamond_outlined,
            title: 'Loose Stone',
            subtitle: 'Individual gemstones — rough, faceted, or cabochon',
            onTap: () => _selectType(context, 'loose_stone'),
          ),
          const SizedBox(height: 12),
          _TypeCard(
            icon: Icons.landscape_outlined,
            title: 'Mineral Specimen',
            subtitle: 'Display specimens with matrix, species, and locality',
            onTap: () => _selectType(context, 'specimen'),
          ),
          const SizedBox(height: 12),
          _TypeCard(
            icon: Icons.workspace_premium_outlined,
            title: 'Jewelry',
            subtitle: 'Finished pieces — rings, pendants, bracelets…',
            onTap: () => _selectType(context, 'jewelry'),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: cs.primaryContainer,
                foregroundColor: cs.onPrimaryContainer,
                radius: 24,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
