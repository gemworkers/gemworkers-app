import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/inventory_item.dart';
import '../../repositories/inventory_repository.dart';
import '../../repositories/seller_repository.dart';

const _kDefaultCommission = 0.10;

/// Returned by [showListingSheet] when the user takes an action.
class ListingResult {
  final bool listed;
  final double? price;      // null when unlisted or sale_method = accept_offers
  final String saleMethod;  // 'buy_now' | 'accept_offers' | 'both'

  const ListingResult.listed(this.price, {this.saleMethod = 'buy_now'})
      : listed = true;
  const ListingResult.unlisted()
      : listed = false, price = null, saleMethod = 'buy_now';
}

/// Opens a payout-based listing bottom sheet for [item].
/// Returns [ListingResult] when listed/unlisted, or null if dismissed.
Future<ListingResult?> showListingSheet(
    BuildContext context, InventoryItem item) {
  return showModalBottomSheet<ListingResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => _ListingSheet(item: item),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class _ListingSheet extends StatefulWidget {
  final InventoryItem item;
  const _ListingSheet({required this.item});

  @override
  State<_ListingSheet> createState() => _ListingSheetState();
}

class _ListingSheetState extends State<_ListingSheet> {
  final _payoutCtrl = TextEditingController();
  final _courierCtrl = TextEditingController();
  final _shippingCostCtrl = TextEditingController();
  final _deliveryMinCtrl = TextEditingController();
  final _deliveryMaxCtrl = TextEditingController();
  final _prepDaysCtrl = TextEditingController();
  final _videoUrlCtrl = TextEditingController();

  double? _commissionRate; // null = still loading
  bool _saving = false;
  late String _saleMethod;
  String? _shippingMode; // null = seller has not yet chosen

  @override
  void initState() {
    super.initState();
    _saleMethod = widget.item.saleMethod;
    // Pre-fill is deferred to _loadCommissionRate so we can reverse-compute
    // payout from selling_price using the actual per-seller rate.
    _payoutCtrl.addListener(() => setState(() {}));
    if (widget.item.videoUrl != null) {
      _videoUrlCtrl.text = widget.item.videoUrl!;
    }
    _loadCommissionRate();
    _loadShippingDefaults();
  }

  @override
  void dispose() {
    _payoutCtrl.dispose();
    _courierCtrl.dispose();
    _shippingCostCtrl.dispose();
    _deliveryMinCtrl.dispose();
    _deliveryMaxCtrl.dispose();
    _prepDaysCtrl.dispose();
    _videoUrlCtrl.dispose();
    super.dispose();
  }

  // Reverses selling_price → payout using the loaded rate and pre-fills the
  // field. Only runs once (guards on the field being empty).
  void _prefillPayout(double rate) {
    if (_payoutCtrl.text.isNotEmpty) return;
    final existing = widget.item.sellingPrice;
    if (existing == null || existing <= 0) return;
    final fee = double.parse((existing * rate).toStringAsFixed(2));
    _payoutCtrl.text = (existing - fee).toStringAsFixed(2);
  }

  Future<void> _loadCommissionRate() async {
    final sellerId = widget.item.sellerId;
    if (sellerId == null) {
      if (mounted) {
        setState(() => _commissionRate = _kDefaultCommission);
        _prefillPayout(_kDefaultCommission);
      }
      return;
    }
    try {
      final seller = await SellerRepository().getSeller(sellerId);
      final rate = seller.commissionRate;
      if (mounted) {
        final resolved =
            (rate == null || rate == 0) ? _kDefaultCommission : rate;
        setState(() => _commissionRate = resolved);
        _prefillPayout(resolved);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _commissionRate = _kDefaultCommission);
        _prefillPayout(_kDefaultCommission);
      }
    }
  }

  Future<void> _loadShippingDefaults() async {
    final item = widget.item;
    // Prefer the item's own values when relisting.
    if (item.courier != null ||
        item.shippingCost != null ||
        item.deliveryDaysMin != null ||
        item.deliveryDaysMax != null ||
        item.prepDays != null) {
      if (!mounted) return;
      setState(() {
        if (item.courier != null) _courierCtrl.text = item.courier!;
        if (item.shippingCost != null) {
          if (item.shippingCost! == 0) {
            _shippingMode = 'free';
          } else {
            _shippingMode = 'charged';
            _shippingCostCtrl.text = item.shippingCost!.toStringAsFixed(2);
          }
        }
        if (item.deliveryDaysMin != null) {
          _deliveryMinCtrl.text = item.deliveryDaysMin!.toString();
        }
        if (item.deliveryDaysMax != null) {
          _deliveryMaxCtrl.text = item.deliveryDaysMax!.toString();
        }
        if (item.prepDays != null) {
          _prepDaysCtrl.text = item.prepDays!.toString();
        }
      });
      return;
    }
    // Fall back to the seller's most recently listed stone with shipping set.
    final sellerId = item.sellerId;
    if (sellerId == null) return;
    try {
      final rows = await Supabase.instance.client
          .from('inventory_items')
          .select(
              'courier, shipping_cost, delivery_days_min, delivery_days_max, prep_days')
          .eq('seller_id', sellerId)
          .eq('is_listed', true)
          .not('courier', 'is', null)
          .order('listed_at', ascending: false)
          .limit(1);
      if (!mounted || rows.isEmpty) return;
      final row = rows.first;
      setState(() {
        if (row['courier'] != null) {
          _courierCtrl.text = row['courier'] as String;
        }
        if (row['shipping_cost'] != null) {
          final cost = (row['shipping_cost'] as num).toDouble();
          if (cost == 0) {
            _shippingMode = 'free';
          } else {
            _shippingMode = 'charged';
            _shippingCostCtrl.text = cost.toStringAsFixed(2);
          }
        }
        if (row['delivery_days_min'] != null) {
          _deliveryMinCtrl.text = row['delivery_days_min'].toString();
        }
        if (row['delivery_days_max'] != null) {
          _deliveryMaxCtrl.text = row['delivery_days_max'].toString();
        }
        if (row['prep_days'] != null) {
          _prepDaysCtrl.text = row['prep_days'].toString();
        }
      });
    } catch (_) {
      // Pre-fill is best-effort — fail silently.
    }
  }

  // ── Computed ──────────────────────────────────────────────────────────────

  double get _commission => _commissionRate ?? _kDefaultCommission;

  /// Seller's desired payout as typed.
  double get _payout =>
      double.tryParse(_payoutCtrl.text.replaceAll(',', '.')) ?? 0;

  /// Buyer-facing price derived from the seller's desired payout.
  /// Returns 0 when rate >= 1 (divide-by-zero guard).
  double get _buyerPrice {
    if (_commission >= 1) return 0;
    return double.parse((_payout / (1 - _commission)).toStringAsFixed(2));
  }

  /// Platform fee the buyer's price carries (mirrors deployed order math).
  double get _fee =>
      double.parse((_buyerPrice * _commission).toStringAsFixed(2));

  double get _receive => _buyerPrice - _fee;
  double get _profit => _receive - widget.item.costPrice;
  bool get _hasNoCost => widget.item.costPrice == 0;
  bool get _isLosing => !_hasNoCost && _payout > 0 && _profit < 0;
  bool get _needsPrice => _saleMethod != 'accept_offers';

  String get _commissionLabel {
    final pct = _commission * 100;
    return pct % 1 == 0
        ? '${pct.toInt()}%'
        : '${pct.toStringAsFixed(1)}%';
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _listItem() async {
    final method = _saleMethod;
    final price = method == 'accept_offers' ? null : _buyerPrice;
    if (method != 'accept_offers' && _buyerPrice <= 0) return;
    setState(() => _saving = true);
    try {
      await InventoryRepository().listItem(
        widget.item.id!,
        price,
        method,
        courier: _courierCtrl.text.trim().isEmpty
            ? null
            : _courierCtrl.text.trim(),
        shippingCost: _shippingMode == 'free'
            ? 0.0
            : double.tryParse(
                _shippingCostCtrl.text.replaceAll(',', '.')),
        deliveryDaysMin: int.tryParse(_deliveryMinCtrl.text.trim()),
        deliveryDaysMax: int.tryParse(_deliveryMaxCtrl.text.trim()),
        prepDays: int.tryParse(_prepDaysCtrl.text.trim()),
        videoUrl: _videoUrlCtrl.text.trim().isEmpty
            ? null
            : _videoUrlCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.pop(
            context, ListingResult.listed(price, saleMethod: method));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _unlistItem() async {
    setState(() => _saving = true);
    try {
      await InventoryRepository().unlistItem(widget.item.id!);
      if (mounted) {
        Navigator.pop(context, const ListingResult.unlisted());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isListed = widget.item.isListed;
    final shippingDecided = _shippingMode != null &&
        (_shippingMode != 'charged' ||
            (double.tryParse(_shippingCostCtrl.text.replaceAll(',', '.')) ?? 0) >
                0);
    final canList =
        (_saleMethod == 'accept_offers' || _buyerPrice > 0) && shippingDecided;
    final loading = _commissionRate == null;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 8, 20, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'List on marketplace',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            widget.item.title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // ── Sale method picker ─────────────────────────────────────────
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'buy_now', label: Text('Buy now')),
              ButtonSegment(
                  value: 'accept_offers', label: Text('Accept offers')),
              ButtonSegment(value: 'both', label: Text('Both')),
            ],
            selected: {_saleMethod},
            onSelectionChanged: (Set<String> selection) {
              setState(() => _saleMethod = selection.first);
            },
          ),
          const SizedBox(height: 20),

          if (loading) ...[
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 20),
          ] else ...[
            if (_needsPrice) ...[
              // ── Cost ────────────────────────────────────────────────────
              _calcRow(
                'Your cost',
                _hasNoCost
                    ? '—'
                    : '€${widget.item.costPrice.toStringAsFixed(2)}',
                muted: true,
              ),
              if (_hasNoCost) ...[
                const SizedBox(height: 4),
                Text(
                  "No cost recorded — profit can't be calculated",
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
              const SizedBox(height: 14),

              // ── Payout input ───────────────────────────────────────────
              TextField(
                controller: _payoutCtrl,
                autofocus: !isListed,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Your payout (what you receive)',
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Live calculator (only when payout entered) ─────────────
              if (canList) ...[
                const Divider(height: 1),
                const SizedBox(height: 12),
                _calcRow(
                  'Buyer pays',
                  '€${_buyerPrice.toStringAsFixed(2)}',
                  muted: true,
                ),
                _calcRow(
                  'Platform fee ($_commissionLabel)',
                  '−€${_fee.toStringAsFixed(2)}',
                  muted: true,
                ),
                _calcRow(
                  'You receive',
                  '€${_receive.toStringAsFixed(2)}',
                  bold: true,
                ),
                if (!_hasNoCost) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  _calcRow(
                    'Your profit',
                    '${_profit >= 0 ? '+' : ''}€${_profit.toStringAsFixed(2)}',
                    bold: true,
                    color: _profit < 0
                        ? cs.error
                        : Colors.green.shade700,
                  ),
                  if (_isLosing) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cs.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 16, color: cs.error),
                          const SizedBox(width: 8),
                          Text(
                            "You'll lose money at this price",
                            style: TextStyle(
                                fontSize: 13, color: cs.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 4),
            ] else ...[
              // accept_offers: no price needed
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Buyers will send you their price — no asking price needed.',
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
            ],

            // ── Shipping ───────────────────────────────────────────────
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'Shipping',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'free', label: Text('Free shipping')),
                ButtonSegment(value: 'charged', label: Text('Buyer pays')),
              ],
              selected: _shippingMode != null ? {_shippingMode!} : {},
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  _shippingMode = selection.isEmpty ? null : selection.first;
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _courierCtrl,
              decoration: const InputDecoration(
                labelText: 'Courier (optional)',
                hintText: 'e.g. DHL, Royal Mail',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            if (_shippingMode == 'charged') ...[
              TextField(
                controller: _shippingCostCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Shipping cost',
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _deliveryMinCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Min delivery',
                      suffixText: 'days',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _deliveryMaxCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Max delivery',
                      suffixText: 'days',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _prepDaysCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Handling time (optional)',
                suffixText: 'days',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 20),

            // ── Video ──────────────────────────────────────────────────
            const Divider(height: 1),
            const SizedBox(height: 16),
            Text(
              'Video',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _videoUrlCtrl,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Video URL (optional)',
                hintText: 'YouTube, Vimeo, or direct .mp4 link',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 20),

            // ── Primary action ─────────────────────────────────────────
            if (!shippingDecided) ...[
              Text(
                'Choose a shipping option to list',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: (_saving || !canList) ? null : _listItem,
                child: Text(_saving
                    ? 'Saving…'
                    : isListed
                        ? 'Update listing'
                        : 'List item'),
              ),
            ),

            if (isListed) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _saving ? null : _unlistItem,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cs.error,
                    side: BorderSide(
                        color: cs.error.withValues(alpha: 0.5)),
                  ),
                  child: const Text('Remove from marketplace'),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _calcRow(
    String label,
    String value, {
    bool muted = false,
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: muted ? Colors.grey.shade600 : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
