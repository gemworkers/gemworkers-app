import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/seller.dart';

class SellerRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Seller>> getSellers() async {
    final response =
        await _supabase.from('sellers').select().order('name');
    return response.map<Seller>((row) => Seller.fromMap(row)).toList();
  }

  Future<Seller> getSeller(String id) async {
    final response =
        await _supabase.from('sellers').select().eq('id', id).single();
    return Seller.fromMap(response);
  }

  Future<Seller> addSeller(Seller seller) async {
    final response = await _supabase
        .from('sellers')
        .insert(seller.toMap())
        .select()
        .single();
    return Seller.fromMap(response);
  }

  Future<void> updateSeller(String id, Seller seller) async {
    await _supabase.from('sellers').update(seller.toMap()).eq('id', id);
  }

  Future<void> deleteSeller(String id) async {
    await _supabase.from('sellers').delete().eq('id', id);
  }

  /// Count of inventory items belonging to this seller.
  Future<int> getInventoryCount(String sellerId) async {
    final response = await _supabase
        .from('inventory_items')
        .select('id')
        .eq('seller_id', sellerId);
    return (response as List).length;
  }

  /// Count of listed (marketplace) inventory items for this seller.
  Future<int> getListedCount(String sellerId) async {
    final response = await _supabase
        .from('inventory_items')
        .select('id')
        .eq('seller_id', sellerId)
        .eq('is_listed', true);
    return (response as List).length;
  }

  /// Count of paid orders belonging to this seller.
  Future<int> getSalesCount(String sellerId) async {
    final response = await _supabase
        .from('orders')
        .select('id')
        .eq('seller_id', sellerId)
        .eq('status', 'paid');
    return (response as List).length;
  }

  /// Total revenue from paid orders for this seller.
  Future<double> getRevenue(String sellerId) async {
    final rows = await _supabase
        .from('orders')
        .select('order_items(price_at_sale, quantity)')
        .eq('seller_id', sellerId)
        .eq('status', 'paid');
    double total = 0;
    for (final row in rows as List) {
      for (final item in (row['order_items'] as List? ?? [])) {
        total += ((item['price_at_sale'] as num?) ?? 0).toDouble() *
            ((item['quantity'] as num?) ?? 1).toInt();
      }
    }
    return total;
  }
}
