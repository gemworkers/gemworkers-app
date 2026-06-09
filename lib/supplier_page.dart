import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final supabase = Supabase.instance.client;

  List suppliers = [];

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    final data = await supabase
        .from('suppliers')
        .select()
        .order('id');

    setState(() {
      suppliers = data;
    });
  }

  Future<void> addSupplier() async {
    TextEditingController name = TextEditingController();
    TextEditingController country = TextEditingController();
    TextEditingController reliability = TextEditingController();
    TextEditingController notes = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Supplier"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Supplier Name',
                ),
              ),
              TextField(
                controller: country,
                decoration: const InputDecoration(
                  labelText: 'Country',
                ),
              ),
              TextField(
                controller: reliability,
                decoration: const InputDecoration(
                  labelText: 'Reliability Score',
                ),
              ),
              TextField(
                controller: notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await supabase.from('suppliers').insert({
                'supplier_name': name.text,
                'country': country.text,
                'reliability_score': reliability.text,
                'notes': notes.text,
              });

              Navigator.pop(context);
              loadSuppliers();
            },
            child: const Text('Save'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
      ),
      body: ListView.builder(
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final supplier = suppliers[index];

          return ListTile(
            title: Text(
              supplier['supplier_name'] ?? '',
            ),
            subtitle: Text(
              supplier['country'] ?? '',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addSupplier,
        child: const Icon(Icons.add),
      ),
    );
  }
}