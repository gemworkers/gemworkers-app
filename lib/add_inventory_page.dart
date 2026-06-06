import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddInventoryPage extends StatefulWidget {
  const AddInventoryPage({super.key});

  @override
  State<AddInventoryPage> createState() => _AddInventoryPageState();
}

class _AddInventoryPageState extends State<AddInventoryPage> {
  final stoneTypeController = TextEditingController();
  final skuController = TextEditingController();
  final categoryController = TextEditingController();
  final weightController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController = TextEditingController();
  final statusController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();

  bool isSaving = false;

  Future<void> saveItem() async {
    try {
      setState(() {
        isSaving = true;
      });

      await Supabase.instance.client.from('inventory_items').insert({
        'stone_type': stoneTypeController.text,
        'sku': skuController.text,
        'category': categoryController.text,
        'weight': double.tryParse(weightController.text) ?? 0,
        'quantity': int.tryParse(quantityController.text) ?? 0,
        'location': locationController.text,
        'status': statusController.text,
        'purchase_price':
            double.tryParse(purchasePriceController.text) ?? 0,
        'selling_price':
            double.tryParse(sellingPriceController.text) ?? 0,
      });

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      isSaving = false;
    });
  }

  Widget buildField(
    String label,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField('Stone Type', stoneTypeController),
            buildField('SKU', skuController),
            buildField('Category', categoryController),
            buildField('Weight', weightController),
            buildField('Quantity', quantityController),
            buildField('Location', locationController),
            buildField('Status', statusController),
            buildField('Purchase Price', purchasePriceController),
            buildField('Selling Price', sellingPriceController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveItem,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}