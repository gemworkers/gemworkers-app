import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/commission.dart';

export '../../../core/utils/commission.dart';

/// Parses a typed € amount (accepts "," as decimal separator), rounded to
/// cents. Returns null when empty or invalid.
double? parsePrice(String text) {
  final v = double.tryParse(text.trim().replaceAll(',', '.'));
  return v == null ? null : double.parse(v.toStringAsFixed(2));
}

/// "You'll receive €X after N% commission" line (+ default-rate note).
class PayoutLine extends StatelessWidget {
  final double? price;
  final double rate;
  final CommissionRateSource source;

  const PayoutLine({
    super.key,
    required this.price,
    required this.rate,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final p = price ?? 0;
    final receive = p > 0 ? payoutAfterCommission(p, rate) : 0.0;
    final note = commissionRateNote(source);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "You'll receive €${receive.toStringAsFixed(2)} "
          'after ${commissionLabel(rate)} commission',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        if (note != null) ...[
          const SizedBox(height: 4),
          Text(
            note,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ],
    );
  }
}

/// Price (€) input = selling_price, with a live [PayoutLine] under it.
/// Loads the seller's commission rate itself. Empty = "No price yet".
class PriceField extends StatefulWidget {
  final TextEditingController controller;
  final String? sellerId;
  final bool enabled;

  const PriceField({
    super.key,
    required this.controller,
    required this.sellerId,
    this.enabled = true,
  });

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {
  CommissionRate? _rate;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _load();
  }

  @override
  void didUpdateWidget(PriceField old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
    if (old.sellerId != widget.sellerId) _load();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _load() async {
    final r = await loadSellerCommissionRate(widget.sellerId);
    if (mounted) setState(() => _rate = r);
  }

  @override
  Widget build(BuildContext context) {
    final rate = _rate;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Price',
              helperText: 'What the buyer pays · leave empty for no price yet',
              prefixText: '€ ',
            ),
          ),
          const SizedBox(height: 8),
          if (rate == null)
            const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            PayoutLine(
              price: parsePrice(widget.controller.text),
              rate: rate.rate,
              source: rate.source,
            ),
        ],
      ),
    );
  }
}
