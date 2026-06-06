import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_inventory_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://roqcfmszrzwebpejidmq.supabase.co',
    anonKey: 'sb_publishable_O_bKLDif-a2CcWEOQDt9jw_psIUebhj',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GemWorkers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InventoryPage(),
    );
  }
}

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final data = await Supabase.instance.client
          .from('inventory_items')
          .select();

      setState(() {
        items = data;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in stock':
        return Colors.green;
      case 'needs listing':
        return Colors.orange;
      case 'sold':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GemWorkers Inventory'),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
onPressed: () async {
  final result = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AddInventoryPage(),
  ),
);

if (result == true) {
  loadItems();
}        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? const Center(
                  child: Text(
                    'No inventory found',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final status =
                        (item['status'] ?? 'Unknown').toString();

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['stone_type'] ?? 'Unknown Stone',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(status),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'SKU: ${item['sku'] ?? ''}',
                            ),
                            Text(
                              'Category: ${item['category'] ?? ''}',
                            ),
                            Text(
                              'Location: ${item['location'] ?? ''}',
                            ),
                            Text(
                              'Quantity: ${item['quantity'] ?? ''}',
                            ),
                            Text(
                              'Weight: ${item['weight'] ?? ''}g',
                            ),

                            if (item['purchase_price'] != null)
                              Text(
                                'Purchase Price: €${item['purchase_price']}',
                              ),

                            if (item['selling_price'] != null)
                              Text(
                                'Selling Price: €${item['selling_price']}',
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}