import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditInventoryPage extends StatefulWidget {
  final Map item;

  const EditInventoryPage({
    super.key,
    required this.item,
  });

  @override
  State<EditInventoryPage> createState() => _EditInventoryPageState();
}

class _EditInventoryPageState extends State<EditInventoryPage> {
  late TextEditingController stoneTypeController;
  late TextEditingController skuController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController weightController;
  late TextEditingController locationController;
  late TextEditingController statusController;
  late TextEditingController supplierIdController;
  late TextEditingController purchasePriceController;
  late TextEditingController wholesalePriceController;
  late TextEditingController sellingPriceController;
  late TextEditingController retailPriceController;
  late TextEditingController productTypeController;
  late TextEditingController originCountryController;
  late TextEditingController originRegionController;
  late TextEditingController shapeController;
  late TextEditingController colorController;
  late TextEditingController photoUrlController;
  late TextEditingController videoUrlController;
  late TextEditingController notesController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    stoneTypeController =
        TextEditingController(text: widget.item['stone_type']?.toString() ?? '');

    skuController =
        TextEditingController(text: widget.item['sku']?.toString() ?? '');

    categoryController =
        TextEditingController(text: widget.item['category']?.toString() ?? '');

    quantityController =
        TextEditingController(text: widget.item['quantity']?.toString() ?? '');

    weightController =
        TextEditingController(text: widget.item['weight']?.toString() ?? '');

    locationController =
        TextEditingController(text: widget.item['location']?.toString() ?? '');

    statusController =
        TextEditingController(text: widget.item['status']?.toString() ?? '');

    supplierIdController =
        TextEditingController(text: widget.item['supplier_id']?.toString() ?? '');

    purchasePriceController =
        TextEditingController(text: widget.item['purchase_price']?.toString() ?? '');

    wholesalePriceController =
        TextEditingController(text: widget.item['wholesale_price']?.toString() ?? '');

    sellingPriceController =
        TextEditingController(text: widget.item['selling_price']?.toString() ?? '');

    retailPriceController =
        TextEditingController(text: widget.item['retail_price']?.toString() ?? '');

    productTypeController =
        TextEditingController(text: widget.item['product_type']?.toString() ?? '');

    originCountryController =
        TextEditingController(text: widget.item['origin_country']?.toString() ?? '');

    originRegionController =
        TextEditingController(text: widget.item['origin_region']?.toString() ?? '');

    shapeController =
        TextEditingController(text: widget.item['shape']?.toString() ?? '');

    colorController =
        TextEditingController(text: widget.item['color']?.toString() ?? '');

    photoUrlController =
        TextEditingController(text: widget.item['photo_url']?.toString() ?? '');

    videoUrlController =
        TextEditingController(text: widget.item['video_url']?.toString() ?? '');

    notesController =
        TextEditingController(text: widget.item['notes']?.toString() ?? '');
  }

  Future<void> updateItem() async {
    try {
      setState(() {
        isSaving = true;
      });

      await Supabase.instance.client
          .from('inventory_items')
          .update({
        'stone_type': stoneTypeController.text,
        'sku': skuController.text,
        'category': categoryController.text,
        'quantity': quantityController.text,
        'weight': weightController.text,
        'location': locationController.text,
        'status': statusController.text,
        'supplier_id': supplierIdController.text.trim().isEmpty
    ? null
    : int.parse(supplierIdController.text.trim()),
        'purchase_price': purchasePriceController.text,
        'wholesale_price': wholesalePriceController.text,
        'selling_price': sellingPriceController.text,
        'retail_price': retailPriceController.text,
        'product_type': productTypeController.text,
        'origin_country': originCountryController.text,
        'origin_region': originRegionController.text,
        'shape': shapeController.text,
        'color': colorController.text,
        'photo_url': photoUrlController.text,
        'video_url': videoUrlController.text,
        'notes': notesController.text,
      })
          .eq('id', widget.item['id']);

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
        title: const Text('Edit Inventory'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildField('Stone Type', stoneTypeController),
            buildField('SKU', skuController),
            buildField('Category', categoryController),
            buildField('Quantity', quantityController),
            buildField('Weight', weightController),
            buildField('Location', locationController),
            buildField('Status', statusController),
            buildField('Supplier ID', supplierIdController),
            buildField('Product Type', productTypeController),
            buildField('Origin Country', originCountryController),
            buildField('Origin Region', originRegionController),
            buildField('Shape', shapeController),
            buildField('Color', colorController),
            buildField('Purchase Price', purchasePriceController),
            buildField('Wholesale Price', wholesalePriceController),
            buildField('Selling Price', sellingPriceController),
            buildField('Retail Price', retailPriceController),
            buildField('Photo URL', photoUrlController),
            buildField('Video URL', videoUrlController),
            buildField('Notes', notesController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : updateItem,
                child: isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Update Inventory'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}