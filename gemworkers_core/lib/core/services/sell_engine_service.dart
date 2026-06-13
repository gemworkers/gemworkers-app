import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/order.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/order_repository.dart';
import 'user_profile_service.dart';

// ── Result ────────────────────────────────────────────────────────────────────

class SaleResult {
  final String orderNumber;
  final double orderTotal;
  final double sellerPayout;

  const SaleResult({
    required this.orderNumber,
    required this.orderTotal,
    required this.sellerPayout,
  });
}

// ── Sell engine ───────────────────────────────────────────────────────────────

class SellEngineService {
  final _supabase = Supabase.instance.client;
  final _orderRepo = OrderRepository();
  final _inventoryRepo = InventoryRepository();

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Records a manual sale.
  ///
  /// [items]           List of inventory item IDs + agreed sale prices.
  /// [commissionRate]  Decimal fraction (e.g. 0.10 = 10 %).
  /// [buyerName/Email/Phone]  All optional; if email or phone provided the
  ///                  engine finds-or-creates a customer and updates their stats.
  Future<SaleResult> recordSale({
    required List<({String inventoryItemId, double priceAtSale})> items,
    required double commissionRate,
    String? buyerName,
    String? buyerEmail,
    String? buyerPhone,
  }) async {
    final sellerId = UserProfileService.instance.effectiveSellerId;

    // ── 1. Compute financials ──────────────────────────────────────────────
    final orderTotal = items.fold(0.0, (s, i) => s + i.priceAtSale);
    final commissionAmount =
        double.parse((orderTotal * commissionRate).toStringAsFixed(2));
    final sellerPayout =
        double.parse((orderTotal - commissionAmount).toStringAsFixed(2));

    // ── 2. Create the order ────────────────────────────────────────────────
    final order = await _orderRepo.addOrder(Order(
      status: 'paid',
      orderDate: DateTime.now(),
      notes: '',
      sellerId: sellerId,
      saleChannel: 'manual',
      commissionRate: commissionRate,
      commissionAmount: commissionAmount,
      sellerPayout: sellerPayout,
      orderTotal: orderTotal,
    ));

    // ── 3. Add order line items ────────────────────────────────────────────
    await _orderRepo.addOrderItems(
      order.id!,
      items
          .map((i) => OrderItem(
                inventoryItemId: i.inventoryItemId,
                priceAtSale: i.priceAtSale,
                quantity: 1,
              ))
          .toList(),
    );

    // ── 4. Mark stones as sold ────────────────────────────────────────────
    await _inventoryRepo.markSold(
      items.map((i) => i.inventoryItemId).toList(),
    );

    // ── 5. Customer intelligence (owner-side; bypasses RLS via SECURITY DEFINER) ──
    final hasBuyer = (buyerEmail?.isNotEmpty ?? false) ||
        (buyerPhone?.isNotEmpty ?? false);
    if (hasBuyer) {
      await _supabase.rpc('handle_sale_customer', params: {
        'p_name':     buyerName?.isNotEmpty == true ? buyerName! : 'Unknown',
        'p_email':    buyerEmail ?? '',
        'p_phone':    buyerPhone ?? '',
        'p_order_id': order.id,
      });
    }

    return SaleResult(
      orderNumber: order.orderNumber,
      orderTotal: orderTotal,
      sellerPayout: sellerPayout,
    );
  }
}
