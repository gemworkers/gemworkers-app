import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/services/user_profile_service.dart';
import '../core/utils/commission.dart';
import '../models/order.dart';

class OrderRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  // ── Queries ───────────────────────────────────────────────────────────────

  /// List view — joins customer name but does NOT load order_items.
  Future<List<Order>> getOrders({String? statusFilter}) async {
    final query = supabase
        .from('orders')
        .select('id, order_number, status, order_date, notes, customer_id, seller_id, created_at, customers(name), sellers(name)');

    final response = statusFilter != null
        ? await query.eq('status', statusFilter).order('created_at', ascending: false)
        : await query.order('created_at', ascending: false);

    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  /// Orders & Shipping list — adds buyer, offer/payment-due fields and the
  /// items' title, first image and prep_days (for the "Ship by" date).
  /// [statuses] null = all statuses.
  Future<List<Order>> getShopOrders({List<String>? statuses}) async {
    var query = supabase.from('orders').select(
        'id, order_number, status, order_date, created_at, notes, '
        'customer_id, seller_id, sale_channel, order_total, seller_payout, '
        'shipping_name, shipping_country, order_email, offer_id, '
        'payment_due_at, paid_at, '
        'shipped_at, received_at, '
        'customers(name), sellers(name), buyers(email, display_name), '
        'order_items(id, price_at_sale, quantity, '
        'inventory_items(title, sku, image_urls, prep_days))');
    if (statuses != null) query = query.inFilter('status', statuses);
    final response = await query.order('created_at', ascending: false);
    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  /// The actual sale of an inventory item: its line in the most recent
  /// non-cancelled order. Null if the item was never sold through an order.
  ///
  /// [received] = order seller_payout when the item is the order's only line;
  /// otherwise the item's price minus its share of commission
  /// (ROUND(price × order commission_rate, 2)).
  Future<({String orderNumber, double soldFor, double received})?>
      getItemSale(String inventoryItemId) async {
    final rows = await supabase
        .from('order_items')
        .select('price_at_sale, quantity, '
            'orders!inner(order_number, status, created_at, commission_rate, '
            'commission_amount, seller_payout, order_items(id))')
        .eq('inventory_item_id', inventoryItemId)
        .neq('orders.status', 'cancelled');
    if (rows.isEmpty) return null;

    rows.sort((a, b) => (b['orders']['created_at']?.toString() ?? '')
        .compareTo(a['orders']['created_at']?.toString() ?? ''));
    final line = rows.first;
    final order = line['orders'] as Map<String, dynamic>;
    final qty = (parseNumeric(line['quantity']) ?? 1).toInt();
    final soldFor = (parseNumeric(line['price_at_sale']) ?? 0) * qty;
    final lineCount = (order['order_items'] as List?)?.length ?? 1;

    final double received;
    if (lineCount <= 1 && order['seller_payout'] != null) {
      received = parseNumeric(order['seller_payout']) ?? soldFor;
    } else if (lineCount <= 1) {
      received = soldFor - (parseNumeric(order['commission_amount']) ?? 0);
    } else {
      final rate = parseCommissionRate(order['commission_rate']) ?? 0;
      received = soldFor - commissionFee(soldFor, rate);
    }
    return (
      orderNumber: order['order_number']?.toString() ?? '',
      soldFor: soldFor,
      received: received,
    );
  }

  /// Order count per status. Pass [sellerId] to scope to a single seller.
  Future<Map<String, int>> getStatusCounts({String? sellerId}) async {
    var query = supabase.from('orders').select('status');
    if (sellerId != null) query = query.eq('seller_id', sellerId);
    final response = await query;
    final counts = <String, int>{};
    for (final row in response) {
      final s = row['status']?.toString() ?? '';
      counts[s] = (counts[s] ?? 0) + 1;
    }
    return counts;
  }

  /// Full detail — joins customer name AND order_items with inventory names.
  Future<Order> getOrderDetail(String id) async {
    final response = await supabase
        .from('orders')
        .select('*, customers(name), sellers(name), consignors(name), order_items(*, inventory_items(sku, title))')
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

  /// Website orders placed by a storefront buyer account (orders.buyer_id).
  Future<List<Order>> getOrdersForBuyer(String buyerId) async {
    final response = await supabase
        .from('orders')
        .select('*, order_items(price_at_sale, quantity)')
        .eq('buyer_id', buyerId)
        .order('created_at', ascending: false);
    return response.map<Order>((row) => Order.fromMap(row)).toList();
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  /// Creates the order and returns the server row (with auto-generated order_number).
  /// seller_id defaults to kCurrentSellerId (see seller_service.dart) when not set.
  Future<Order> addOrder(Order order) async {
    final map = order.toMap();
    map['seller_id'] ??= UserProfileService.instance.effectiveSellerId;
    final response = await supabase
        .from('orders')
        .insert(map)
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

  /// Advances a confirmed platform order to 'shipped' via the SECURITY DEFINER
  /// RPC. Throws PostgrestException on validation failure (surfaced via .message).
  Future<void> markShipped(String orderId, {String? trackingNumber}) async {
    await supabase.rpc('mark_order_shipped', params: {
      'p_order_id': orderId,
      'p_tracking_number': trackingNumber,
    });
  }

  /// Records that the seller payout was made via the SECURITY DEFINER RPC.
  Future<void> markPayoutPaid(
      String orderId, {String? method, String? reference}) async {
    await supabase.rpc('mark_payout_paid', params: {
      'p_order_id': orderId,
      'p_method': method,
      'p_reference': reference,
    });
  }

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
            .update({'status': 'sold', 'is_listed': false})
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

  // ── To-ship count ─────────────────────────────────────────────────────────

  /// Count of confirmed orders waiting to be shipped (any channel) — same
  /// rule as the To ship tab and the dashboard card.
  /// RLS scopes automatically: sellers see their own, owner sees all.
  /// Pass [sellerId] to scope to a single seller.
  Future<int> getToShipCount({String? sellerId}) async {
    var query = supabase
        .from('orders')
        .select('id')
        .eq('status', 'confirmed');
    if (sellerId != null) query = query.eq('seller_id', sellerId);
    final response = await query;
    return response.length;
  }

  // ── Dashboard stats ───────────────────────────────────────────────────────

  /// Returns total order count and cumulative revenue from paid orders.
  /// Pass [sellerId] to scope to a single seller.
  Future<({int orderCount, double revenue})> getDashboardStats(
      {String? sellerId}) async {
    final query = supabase
        .from('orders')
        .select('status, order_items(price_at_sale, quantity)');

    final response = sellerId != null
        ? await query.eq('seller_id', sellerId)
        : await query;

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
