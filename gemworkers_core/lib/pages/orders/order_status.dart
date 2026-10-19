import 'package:flutter/material.dart';

import '../../models/order.dart';
import '../../theme/app_theme.dart';

/// Human-readable label for a raw order status ('pending_payment' → 'Awaiting payment').
String orderStatusLabel(String status) => switch (status) {
      'pending_payment' => 'Awaiting payment',
      '' => status,
      _ => status[0].toUpperCase() + status.substring(1).replaceAll('_', ' '),
    };

/// Chip/accent colour for a raw order status.
Color orderStatusColor(String status) => switch (status) {
      'pending_payment'                  => AppColors.warning,
      'confirmed' || 'paid' || 'received' => AppColors.success,
      'cancelled'                        => AppColors.error,
      _                                  => AppColors.muted,
    };

/// Chip background for a raw order status (pairs with [orderStatusColor]).
Color orderStatusBackground(String status) => switch (status) {
      'pending_payment' => AppColors.warningBackground,
      _                 => orderStatusColor(status).withValues(alpha: 0.1),
    };

/// Prep days assumed when none of an order's items has prep_days set.
const kDefaultPrepDays = 3;

/// Ship-by date: paid date (fallback: order date) + the largest prep_days
/// among its items (default [kDefaultPrepDays]). Needs the items loaded.
DateTime orderShipBy(Order order) {
  final prep = order.items
      .map((i) => i.itemPrepDays)
      .whereType<int>()
      .fold<int?>(null, (m, d) => m == null || d > m ? d : m);
  final base = (order.paidAt ?? order.orderDate).toLocal();
  return DateTime(base.year, base.month, base.day)
      .add(Duration(days: prep ?? kDefaultPrepDays));
}

/// True when the order's Ship-by date is before today.
bool orderShipOverdue(Order order) {
  final now = DateTime.now();
  return orderShipBy(order).isBefore(DateTime(now.year, now.month, now.day));
}

/// Pill showing the human-readable status in its status colours.
class OrderStatusChip extends StatelessWidget {
  final String status;
  const OrderStatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: ShapeDecoration(
        color: orderStatusBackground(status),
        shape: const StadiumBorder(),
      ),
      child: Text(
        orderStatusLabel(status),
        style: TextStyle(
          fontSize: 12,
          color: orderStatusColor(status),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
