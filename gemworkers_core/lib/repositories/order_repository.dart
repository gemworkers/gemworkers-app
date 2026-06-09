import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order.dart';

class OrderRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// List view — joins customer name but does NOT load order_items.
  Future<List<Order>> getOrders({String? statusFilter}) async {
    final query = supabase
        .from('orders')
        .select('id, order_number, status, order_date, notes, customer_id, created_at, customers(name)');

    final response = statusFilter != null
        ? await query.eq('status', statusFilter).order('created_at', ascending: false)
        : await query.order('created_at', ascending: false);

    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  /// Full detail — joins customer name AND order_items with inventory names.
  Future<Order> getOrderDetail(String id) async {
    final response = await supabase
        .from('orders')
        .select('*, customers(name), order_items(*, inventory_items(sku, title))')
        .eq('id', id)
        .single();
    return Order.fromMap(response);
  }

  /// Orders for a customer, with items (price/qty only) for total computation.
  Future<List<Order>> getOrdersForCustomer(String customerId) async {
    final response = await supabase
        .from('orders')
        .select('*, order_items(price_at_sale, quantity)')
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);
    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// Creates the order and returns the server row (with auto-generated order_number).
  Future<Order> addOrder(Order order) async {
    final response = await supabase
        .from('orders')
        .insert(order.toMap())
        .select()
        .single();
    return Order.fromMap(response);
  }

  Future<void> updateOrder(String id, Order order) async {
    await supabase.from('orders').update(order.toMap()).eq('id', id);
  }

  Future<void> deleteOrder(String id) async {
    await supabase.from('orders').delete().eq('id', id);
  }

  // ── Line items ────────────────────────────────────────────────────────────

  Future<void> addOrderItems(String orderId, List<OrderItem> items) async {
    if (items.isEmpty) return;
    await supabase.from('order_items').insert(
          items
              .map((i) => {
                    'order_id': orderId,
                    'inventory_item_id': i.inventoryItemId,
                    'price_at_sale': i.priceAtSale,
                    'quantity': i.quantity,
                  })
              .toList(),
        );
  }

  /// Deletes all existing items for the order and inserts the new list.
  Future<void> replaceOrderItems(String orderId, List<OrderItem> items) async {
    await supabase.from('order_items').delete().eq('order_id', orderId);
    await addOrderItems(orderId, items);
  }

  // ── Status transitions ────────────────────────────────────────────────────

  /// Sets order → 'paid' and marks all its inventory items → 'sold'.
  Future<void> markPaid(String orderId) async {
    // Update order first; if this fails nothing else changes.
    await supabase
        .from('orders')
        .update({'status': 'paid'})
        .eq('id', orderId);

    final rows = await supabase
        .from('order_items')
        .select('inventory_item_id')
        .eq('order_id', orderId);

    for (final row in rows as List) {
      final inventoryId = row['inventory_item_id']?.toString();
      if (inventoryId != null) {
        await supabase
            .from('inventory_items')
            .update({'status': 'sold'})
            .eq('id', inventoryId);
      }
    }
  }

  /// Sets order → 'cancelled'. If the order was 'paid', reverts inventory
  /// items back to 'available'.
  Future<void> cancelOrder(String orderId,
      {required String currentStatus}) async {
    if (currentStatus == 'paid') {
      final rows = await supabase
          .from('order_items')
          .select('inventory_item_id')
          .eq('order_id', orderId);

      for (final row in rows as List) {
        final inventoryId = row['inventory_item_id']?.toString();
        if (inventoryId != null) {
          await supabase
              .from('inventory_items')
              .update({'status': 'available'})
              .eq('id', inventoryId);
        }
      }
    }

    await supabase
        .from('orders')
        .update({'status': 'cancelled'})
        .eq('id', orderId);
  }

  // ── Dashboard stats ───────────────────────────────────────────────────────

  /// Returns total order count and cumulative revenue from paid orders.
  Future<({int orderCount, double revenue})> getDashboardStats() async {
    final response = await supabase
        .from('orders')
        .select('status, order_items(price_at_sale, quantity)');

    int count = (response as List).length;
    double revenue = 0.0;

    for (final row in response) {
      if (row['status'] == 'paid') {
        for (final item in (row['order_items'] as List? ?? [])) {
          revenue +=
              ((item['price_at_sale'] as num?) ?? 0).toDouble() *
              ((item['quantity'] as num?) ?? 0).toInt();
        }
      }
    }

    return (orderCount: count, revenue: revenue);
  }
}
