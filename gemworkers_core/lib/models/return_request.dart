import '../core/utils/commission.dart';

/// public.returns + its order (sql/returns_setup.sql). Owner only.
class ReturnRequest {
  final String id;
  final String orderId;
  final String status; // requested | approved | received | refunded | rejected | withdrawn | expired
  final String reason;
  final bool faulty;
  final DateTime requestedAt;
  final String returnTracking;
  final String conditionNote;
  final String decisionNote;
  final DateTime? refundedAt;
  final double? refundAmount;
  final double deduction;
  final String deductionReason;
  final double? payoutClawback;

  // From the order
  final String orderNumber;
  final double paid; // order_total + tax_amount
  final double tax;
  final String customerType;
  final String buyerCompany;
  final String payoutStatus;
  final String stoneTitle;
  final String stoneSku;

  const ReturnRequest({
    required this.id,
    required this.orderId,
    required this.status,
    required this.reason,
    required this.faulty,
    required this.requestedAt,
    required this.returnTracking,
    required this.conditionNote,
    required this.decisionNote,
    required this.refundedAt,
    required this.refundAmount,
    required this.deduction,
    required this.deductionReason,
    required this.payoutClawback,
    required this.orderNumber,
    required this.paid,
    required this.tax,
    required this.customerType,
    required this.buyerCompany,
    required this.payoutStatus,
    required this.stoneTitle,
    required this.stoneSku,
  });

  factory ReturnRequest.fromMap(Map<String, dynamic> m) {
    final o = (m['orders'] as Map<String, dynamic>?) ?? const {};
    final items = (o['order_items'] as List?) ?? const [];
    final inv = items.isNotEmpty
        ? ((items.first as Map<String, dynamic>)['inventory_items'] as Map<String, dynamic>?) ?? const {}
        : const <String, dynamic>{};
    final total = parseNumeric(o['order_total']) ?? 0;
    final tax = parseNumeric(o['tax_amount']) ?? 0;
    return ReturnRequest(
      id: m['id'].toString(),
      orderId: m['order_id'].toString(),
      status: m['status']?.toString() ?? 'requested',
      reason: m['reason']?.toString() ?? '',
      faulty: m['faulty'] == true,
      requestedAt: DateTime.parse(m['requested_at'].toString()),
      returnTracking: m['return_tracking']?.toString() ?? '',
      conditionNote: m['condition_note']?.toString() ?? '',
      decisionNote: m['decision_note']?.toString() ?? '',
      refundedAt: m['refunded_at'] == null ? null : DateTime.parse(m['refunded_at'].toString()),
      refundAmount: parseNumeric(m['refund_amount']),
      deduction: parseNumeric(m['deduction']) ?? 0,
      deductionReason: m['deduction_reason']?.toString() ?? '',
      payoutClawback: parseNumeric(m['payout_clawback']),
      orderNumber: o['order_number']?.toString() ?? '',
      // Sum in cents so it never drifts.
      paid: ((total * 100).round() + (tax * 100).round()) / 100,
      tax: tax,
      customerType: o['customer_type']?.toString() ?? '',
      buyerCompany: o['buyer_company']?.toString() ?? '',
      payoutStatus: o['payout_status']?.toString() ?? '',
      stoneTitle: inv['title']?.toString() ?? '',
      stoneSku: inv['sku']?.toString() ?? '',
    );
  }
}
