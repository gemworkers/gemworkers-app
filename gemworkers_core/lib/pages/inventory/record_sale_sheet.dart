import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/sell_engine_service.dart';
import '../../core/services/user_profile_service.dart';
import '../../models/inventory_item.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

/// Opens the "Record Sale" bottom sheet for [items].
/// Only pass items whose status != 'sold' and id != null.
/// Returns a [SaleResult] on success, or null if cancelled.
Future<SaleResult?> showRecordSaleSheet(
  BuildContext context,
  List<InventoryItem> items,
) {
  return showModalBottomSheet<SaleResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => RecordSaleSheet(items: items),
  );
}

// ── Sheet widget ──────────────────────────────────────────────────────────────

class RecordSaleSheet extends StatefulWidget {
  final List<InventoryItem> items;
  const RecordSaleSheet({super.key, required this.items});

  @override
  State<RecordSaleSheet> createState() => _RecordSaleSheetState();
}

class _RecordSaleSheetState extends State<RecordSaleSheet> {
  late final List<TextEditingController> _priceControllers;
  final _nameController  = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  double _commissionRate = 0.10;
  bool _loadingRate = true;
  bool _saving = false;
  bool _showBuyer = false;

  @override
  void initState() {
    super.initState();
    _priceControllers = widget.items.map((item) {
      final price =
          item.sellingPrice ?? (item.salePrice > 0 ? item.salePrice : item.costPrice);
      return TextEditingController(text: price.toStringAsFixed(2));
    }).toList();
    _loadCommissionRate();
  }

  @override
  void dispose() {
    for (final c in _priceControllers) {
      c.dispose();
    }
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadCommissionRate() async {
    final sellerId = UserProfileService.instance.effectiveSellerId;
    try {
      final row = await Supabase.instance.client
          .from('sellers')
          .select('commission_rate')
          .eq('id', sellerId)
          .maybeSingle();
      final rate = (row?['commission_rate'] as num?)?.toDouble();
      if (mounted) {
        setState(() {
          if (rate != null && rate > 0) _commissionRate = rate;
          _loadingRate = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingRate = false);
    }
  }

  // ── Live financials ────────────────────────────────────────────────────────

  double get _orderTotal {
    double t = 0;
    for (final c in _priceControllers) {
      t += double.tryParse(c.text) ?? 0;
    }
    return t;
  }

  double get _commissionAmount =>
      double.parse((_orderTotal * _commissionRate).toStringAsFixed(2));

  double get _sellerPayout => _orderTotal - _commissionAmount;

  // ── Confirm ────────────────────────────────────────────────────────────────

  Future<void> _confirm() async {
    setState(() => _saving = true);
    try {
      final saleItems = widget.items.asMap().entries.map((e) => (
            inventoryItemId: e.value.id!,
            priceAtSale: double.tryParse(_priceControllers[e.key].text) ?? 0.0,
          )).toList();

      final result = await SellEngineService().recordSale(
        items: saleItems,
        commissionRate: _commissionRate,
        buyerName:  _nameController.text.trim().isEmpty  ? null : _nameController.text.trim(),
        buyerEmail: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        buyerPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );

      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sale failed: $e')),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Text('Record Sale',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 4),

          // ── Scrollable body
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              children: [
                // ── Basket ─────────────────────────────────────────────────
                _sectionLabel('Stones', cs),
                ...widget.items.asMap().entries.map(
                  (e) => _BasketRow(
                    item: e.value,
                    controller: _priceControllers[e.key],
                    onChanged: (_) => setState(() {}),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Buyer section (optional) ────────────────────────────────
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showBuyer = !_showBuyer),
                  icon: Icon(
                    _showBuyer
                        ? Icons.person_outline
                        : Icons.person_add_outlined,
                    size: 18,
                  ),
                  label: Text(_showBuyer ? 'Buyer details' : 'Add buyer (optional)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        _showBuyer ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),

                if (_showBuyer) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Buyer name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Used to find or create buyer record',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email or phone is used as the unique buyer key.',
                    style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),

                // ── Summary ─────────────────────────────────────────────────
                _sectionLabel('Summary', cs),
                _SummaryRow(
                  label: 'Order total',
                  value: '€${_orderTotal.toStringAsFixed(2)}',
                  bold: true,
                ),
                if (!_loadingRate) ...[
                  _SummaryRow(
                    label:
                        'Commission (${(_commissionRate * 100).toStringAsFixed(0)}%)',
                    value: '−€${_commissionAmount.toStringAsFixed(2)}',
                  ),
                  _SummaryRow(
                    label: 'Seller payout',
                    value: '€${_sellerPayout.toStringAsFixed(2)}',
                    bold: true,
                    color: Colors.green.shade700,
                  ),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // ── Fixed footer: confirm button ───────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton(
                onPressed: _saving || _loadingRate ? null : _confirm,
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Record sale  ·  €${_orderTotal.toStringAsFixed(2)}'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, ColorScheme cs) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: cs.primary,
            letterSpacing: 0.4,
          ),
        ),
      );
}

// ── Basket row ────────────────────────────────────────────────────────────────

class _BasketRow extends StatelessWidget {
  final InventoryItem item;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _BasketRow({
    required this.item,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${item.sku}  ·  cost €${item.costPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 110,
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          Text(value, style: style),
        ],
      ),
    );
  }
}
