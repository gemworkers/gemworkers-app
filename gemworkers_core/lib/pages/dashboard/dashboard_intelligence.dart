import 'package:flutter/material.dart';

import '../../repositories/dashboard_intelligence_repository.dart';

class DashboardIntelligenceSections extends StatefulWidget {
  final DashboardTimeRange timeRange;
  final String? sellerId; // null = all sellers
  final bool isOwner;

  const DashboardIntelligenceSections({
    super.key,
    required this.timeRange,
    required this.sellerId,
    required this.isOwner,
  });

  @override
  State<DashboardIntelligenceSections> createState() =>
      _DashboardIntelligenceSectionsState();
}

class _DashboardIntelligenceSectionsState
    extends State<DashboardIntelligenceSections> {
  final _repo = DashboardIntelligenceRepository();
  DashboardIntelligence? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(DashboardIntelligenceSections old) {
    super.didUpdateWidget(old);
    if (old.timeRange != widget.timeRange ||
        old.sellerId != widget.sellerId ||
        old.isOwner != widget.isOwner) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await _repo.load(
        timeRange: widget.timeRange,
        sellerId: widget.sellerId,
        isOwner: widget.isOwner,
      );
      if (mounted) setState(() { _data = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Could not load intelligence: $_error',
            style: const TextStyle(color: Colors.red)),
      );
    }
    final data = _data!;
    return Column(
      children: [
        _ProfitSection(
          timeRange: widget.timeRange,
          current: data.current,
          previous: data.previous,
          monthlyTrend: data.monthlyTrend,
        ),
        const SizedBox(height: 16),
        _DeadStockSection(items: data.deadStock),
        if (widget.isOwner) ...[
          const SizedBox(height: 16),
          _CustomersSection(customers: data.topCustomers),
          const SizedBox(height: 16),
          _SuppliersAndSellersSection(
            suppliers: data.topSuppliers,
            sellers: data.sellerRankings,
          ),
        ],
      ],
    );
  }
}

// ── Section 1: Profit & Margins ───────────────────────────────────────────────

class _ProfitSection extends StatelessWidget {
  final DashboardTimeRange timeRange;
  final ProfitPeriod current;
  final ProfitPeriod? previous;
  final List<MonthlyProfit> monthlyTrend;

  const _ProfitSection({
    required this.timeRange,
    required this.current,
    required this.previous,
    required this.monthlyTrend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profit & Margins',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            if (timeRange == DashboardTimeRange.vsLastMonth && previous != null)
              _buildComparison(context)
            else
              _buildSinglePeriod(context, current),
            if (timeRange == DashboardTimeRange.last12Months &&
                monthlyTrend.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text('Monthly trend',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade600,
                      )),
              const SizedBox(height: 8),
              _MonthlyTrendList(months: monthlyTrend),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSinglePeriod(BuildContext context, ProfitPeriod p) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _ProfitTile(
                    label: 'Revenue',
                    value: _eur(p.revenue),
                    color: Colors.teal)),
            const SizedBox(width: 8),
            Expanded(
                child: _ProfitTile(
                    label: 'Cost',
                    value: _eur(p.cost),
                    color: Colors.orange)),
            const SizedBox(width: 8),
            Expanded(
                child: _ProfitTile(
                    label: 'Profit',
                    value: _eur(p.profit),
                    color: p.profit >= 0 ? Colors.green : Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _ProfitTile(
                    label: 'Margin',
                    value: '${p.marginPct.toStringAsFixed(1)}%',
                    color: Colors.indigo)),
            const SizedBox(width: 8),
            Expanded(
                child: _ProfitTile(
                    label: 'Commission earned',
                    value: _eur(p.commission),
                    color: Colors.deepPurple)),
            const SizedBox(width: 8),
            const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildComparison(BuildContext context) {
    final prev = previous!;
    final now = DateTime.now();
    final thisLabel =
        '${_monthName(now.month)} ${now.year}';
    final lastLabel =
        '${_monthName(now.month == 1 ? 12 : now.month - 1)} ${now.month == 1 ? now.year - 1 : now.year}';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CompareColumn(
                label: lastLabel,
                period: prev,
                isReference: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CompareColumn(
                label: thisLabel,
                period: current,
                reference: prev,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _eur(double v) => '€${_fmt(v)}';

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }

  static String _monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[(m - 1).clamp(0, 11)];
  }
}

class _ProfitTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ProfitTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style:
                  TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _CompareColumn extends StatelessWidget {
  final String label;
  final ProfitPeriod period;
  final ProfitPeriod? reference; // if set, shows % change vs reference
  final bool isReference;

  const _CompareColumn({
    required this.label,
    required this.period,
    this.reference,
    this.isReference = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
            color: isReference
                ? Colors.grey.shade300
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isReference
                      ? Colors.grey.shade600
                      : Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 10),
          _compareRow('Revenue', period.revenue, reference?.revenue),
          _compareRow('Cost', period.cost, reference?.cost),
          _compareRow('Profit', period.profit, reference?.profit,
              positiveIsGood: true),
          _compareRow('Margin', null, null,
              text:
                  '${period.marginPct.toStringAsFixed(1)}%'),
          _compareRow('Commission', period.commission, reference?.commission),
        ],
      ),
    );
  }

  Widget _compareRow(String label, double? value, double? refValue,
      {bool positiveIsGood = false, String? text}) {
    final display = text ?? (value != null ? '€${_fmt(value)}' : '—');
    Widget? badge;
    if (value != null && refValue != null && refValue != 0) {
      final pct = ((value - refValue) / refValue) * 100;
      final up = pct > 0;
      final color = positiveIsGood
          ? (up ? Colors.green : Colors.red)
          : (up ? Colors.red : Colors.green);
      badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${up ? '+' : ''}${pct.toStringAsFixed(0)}%',
          style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Row(
            children: [
              Text(display,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              if (badge != null) ...[const SizedBox(width: 4), badge],
            ],
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

class _MonthlyTrendList extends StatelessWidget {
  final List<MonthlyProfit> months;

  const _MonthlyTrendList({required this.months});

  @override
  Widget build(BuildContext context) {
    final maxRevenue =
        months.fold(0.0, (m, e) => e.revenue > m ? e.revenue : m);
    final maxBar = maxRevenue > 0 ? maxRevenue : 1.0;

    return Column(
      children: months.map((m) {
        final revPct = maxBar > 0 ? (m.revenue / maxBar).clamp(0.0, 1.0) : 0.0;
        final profitColor =
            m.profit >= 0 ? Colors.green.shade600 : Colors.red;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(m.label,
                    style: const TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: revPct,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.teal,
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 64,
                child: Text(
                  '€${_fmt(m.revenue)}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 60,
                child: Text(
                  '${m.profit >= 0 ? '+' : ''}€${_fmt(m.profit)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: profitColor),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  static String _fmt(double v) {
    if (v.abs() >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

// ── Section 2: Dead Stock ─────────────────────────────────────────────────────

class _DeadStockSection extends StatelessWidget {
  final List<DeadStockEntry> items;

  const _DeadStockSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final over90 = items.where((i) => i.daysInStock >= 90).toList();
    final capitalStuck = over90.fold(0.0, (s, i) => s + i.costPrice);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Dead Stock',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (over90.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '€${_fmt(capitalStuck)} stuck > 90 days',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No unsold stock.',
                    style: TextStyle(color: Colors.grey)),
              )
            else ...[
              // Header row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Expanded(
                        flex: 4,
                        child: Text('Item',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    const SizedBox(
                        width: 52,
                        child: Text('Days',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    const SizedBox(
                        width: 72,
                        child: Text('Cost',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    const SizedBox(
                        width: 44,
                        child: Text('Listed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...items.take(30).map((item) => _DeadStockRow(item: item)),
              if (items.length > 30)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '… and ${items.length - 30} more items',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

class _DeadStockRow extends StatelessWidget {
  final DeadStockEntry item;

  const _DeadStockRow({required this.item});

  Color get _ageColor {
    if (item.daysInStock >= 180) return const Color(0xFFB71C1C); // dark red
    if (item.daysInStock >= 90) return Colors.red;
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item.title.isNotEmpty ? item.title : item.sku,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: _ageColor),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              '${item.daysInStock}d',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 12,
                  color: _ageColor,
                  fontWeight: item.daysInStock >= 90
                      ? FontWeight.w600
                      : FontWeight.normal),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              '€${item.costPrice.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            width: 44,
            child: Center(
              child: item.isListed
                  ? const Icon(Icons.storefront, size: 14, color: Colors.teal)
                  : const Icon(Icons.remove, size: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section 3: Top Customers ──────────────────────────────────────────────────

class _CustomersSection extends StatelessWidget {
  final List<CustomerRanking> customers;

  const _CustomersSection({required this.customers});

  @override
  Widget build(BuildContext context) {
    final tierCounts = <String, int>{};
    for (final c in customers) {
      tierCounts[c.tier] = (tierCounts[c.tier] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Customers',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            // Tier breakdown chips
            Wrap(
              spacing: 8,
              children: ['Silver', 'Gold', 'Premium', 'Collector']
                  .where((t) => (tierCounts[t] ?? 0) > 0)
                  .map((t) => Chip(
                        label: Text(
                          '${tierCounts[t]} $t',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor:
                            _tierColor(t).withValues(alpha: 0.12),
                        side: BorderSide(color: _tierColor(t).withValues(alpha: 0.4)),
                        padding: EdgeInsets.zero,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            if (customers.isEmpty)
              const Text('No customers yet.',
                  style: TextStyle(color: Colors.grey))
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: const [
                    Expanded(
                        flex: 3,
                        child: Text('Name',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    SizedBox(
                        width: 56,
                        child: Text('Tier',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    SizedBox(
                        width: 44,
                        child: Text('Orders',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                    SizedBox(
                        width: 80,
                        child: Text('Spent',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey))),
                  ],
                ),
              ),
              const Divider(height: 1),
              ...customers.take(20).map((c) => _CustomerRow(customer: c)),
              if (customers.length > 20)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '… and ${customers.length - 20} more customers',
                    style:
                        TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  static Color _tierColor(String tier) => switch (tier) {
        'Gold' => Colors.amber.shade700,
        'Premium' => Colors.deepPurple,
        'Collector' => Colors.indigo,
        _ => Colors.blueGrey,
      };
}

class _CustomerRow extends StatelessWidget {
  final CustomerRanking customer;

  const _CustomerRow({required this.customer});

  Color get _tierColor => switch (customer.tier) {
        'Gold' => Colors.amber.shade700,
        'Premium' => Colors.deepPurple,
        'Collector' => Colors.indigo,
        _ => Colors.blueGrey,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              customer.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              customer.tier,
              style: TextStyle(
                  fontSize: 11,
                  color: _tierColor,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '${customer.orderCount}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '€${_fmt(customer.totalSpent)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

// ── Section 4: Suppliers & Sellers ───────────────────────────────────────────

class _SuppliersAndSellersSection extends StatelessWidget {
  final List<SupplierRanking> suppliers;
  final List<SellerRanking> sellers;

  const _SuppliersAndSellersSection({
    required this.suppliers,
    required this.sellers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Suppliers & Sellers',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Best suppliers by profit',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            if (suppliers.isEmpty)
              const Text('No supplier data for this period.',
                  style: TextStyle(color: Colors.grey, fontSize: 13))
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: const [
                  Expanded(
                      flex: 3,
                      child: Text('Supplier',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                  SizedBox(
                      width: 52,
                      child: Text('Sold',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                  SizedBox(
                      width: 80,
                      child: Text('Profit',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                ]),
              ),
              const Divider(height: 1),
              ...suppliers.take(10).map((s) => _SupplierRow(supplier: s)),
            ],
            const SizedBox(height: 20),
            Text('Sellers by revenue',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            if (sellers.isEmpty)
              const Text('No seller data for this period.',
                  style: TextStyle(color: Colors.grey, fontSize: 13))
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(children: const [
                  Expanded(
                      flex: 3,
                      child: Text('Seller',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                  SizedBox(
                      width: 52,
                      child: Text('Items',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                  SizedBox(
                      width: 72,
                      child: Text('Revenue',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                  SizedBox(
                      width: 72,
                      child: Text('Commission',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey))),
                ]),
              ),
              const Divider(height: 1),
              ...sellers.map((s) => _SellerRow(seller: s)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SupplierRow extends StatelessWidget {
  final SupplierRanking supplier;

  const _SupplierRow({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(supplier.supplierName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
          ),
          SizedBox(
            width: 52,
            child: Text('${supplier.itemsSold}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12)),
          ),
          SizedBox(
            width: 80,
            child: Text(
              '€${_fmt(supplier.totalProfit)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: supplier.totalProfit >= 0
                      ? Colors.green.shade700
                      : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v.abs() >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v.abs() >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}

class _SellerRow extends StatelessWidget {
  final SellerRanking seller;

  const _SellerRow({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(seller.sellerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13)),
          ),
          SizedBox(
            width: 52,
            child: Text('${seller.itemsSold}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12)),
          ),
          SizedBox(
            width: 72,
            child: Text('€${_fmt(seller.revenue)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 72,
            child: Text('€${_fmt(seller.commission)}',
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  static String _fmt(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }
}
