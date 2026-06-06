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
  final wholesalePriceController = TextEditingController();
  final sellingPriceController = TextEditingController();
  final retailPriceController = TextEditingController();

  final productTypeController = TextEditingController();
  final originCountryController = TextEditingController();
  final originRegionController = TextEditingController();

  final shapeController = TextEditingController();
  final colorController = TextEditingController();

  final notesController = TextEditingController();

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
        'weight': weightController.text,
        'quantity': int.tryParse(quantityController.text) ?? 0,
        'location': locationController.text,
        'status': statusController.text,

        'purchase_price': purchasePriceController.text,
        'wholesale_price': wholesalePriceController.text,
        'selling_price': sellingPriceController.text,
        'retail_price': retailPriceController.text,

        'product_type': productTypeController.text,
        'origin_country': originCountryController.text,
        'origin_region': originRegionController.text,

        'shape': shapeController.text,
        'color': colorController.text,

        'notes': notesController.text,
      });

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
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
            buildField('Product Type', productTypeController),

            buildField('Weight', weightController),
            buildField('Quantity', quantityController),

            buildField('Location', locationController),
            buildField('Status', statusController),

            buildField('Origin Country', originCountryController),
            buildField('Origin Region', originRegionController),

            buildField('Shape', shapeController),
            buildField('Color', colorController),

            buildField('Purchase Price', purchasePriceController),
            buildField('Wholesale Price', wholesalePriceController),
            buildField('Selling Price', sellingPriceController),
            buildField('Retail Price', retailPriceController),

            buildField('Notes', notesController),

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