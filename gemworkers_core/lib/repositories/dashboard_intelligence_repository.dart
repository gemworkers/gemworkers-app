import 'package:supabase_flutter/supabase_flutter.dart';

// ── Enums & data classes ──────────────────────────────────────────────────────

enum DashboardTimeRange { thisMonth, vsLastMonth, last12Months, allTime }

extension DashboardTimeRangeLabel on DashboardTimeRange {
  String get label => switch (this) {
        DashboardTimeRange.thisMonth => 'This month',
        DashboardTimeRange.vsLastMonth => 'vs Last month',
        DashboardTimeRange.last12Months => 'Last 12 months',
        DashboardTimeRange.allTime => 'All time',
      };
}

class ProfitPeriod {
  final double revenue;
  final double cost;
  final double commission;

  double get profit => revenue - cost;
  double get marginPct => revenue > 0 ? (profit / revenue) * 100 : 0;

  const ProfitPeriod({
    required this.revenue,
    required this.cost,
    required this.commission,
  });

  static const zero = ProfitPeriod(revenue: 0, cost: 0, commission: 0);
}

class MonthlyProfit {
  final int year;
  final int month;
  final double revenue;
  final double cost;

  double get profit => revenue - cost;

  const MonthlyProfit({
    required this.year,
    required this.month,
    required this.revenue,
    required this.cost,
  });

  String get label {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[month - 1]} $year';
  }
}

class DeadStockEntry {
  final String id;
  final String title;
  final String sku;
  final int daysInStock;
  final double costPrice;
  final bool isListed;

  const DeadStockEntry({
    required this.id,
    required this.title,
    required this.sku,
    required this.daysInStock,
    required this.costPrice,
    required this.isListed,
  });
}

class CustomerRanking {
  final String name;
  final double totalSpent;
  final int orderCount;
  final String tier;

  const CustomerRanking({
    required this.name,
    required this.totalSpent,
    required this.orderCount,
    required this.tier,
  });
}

class SupplierRanking {
  final String supplierName;
  final int itemsSold;
  final double totalProfit;

  const SupplierRanking({
    required this.supplierName,
    required this.itemsSold,
    required this.totalProfit,
  });
}

class SellerRanking {
  final String sellerName;
  final double revenue;
  final double commission;
  final int itemsSold;

  const SellerRanking({
    required this.sellerName,
    required this.revenue,
    required this.commission,
    required this.itemsSold,
  });
}

class DashboardIntelligence {
  final ProfitPeriod current;
  final ProfitPeriod? previous; // populated for vsLastMonth only
  final List<MonthlyProfit> monthlyTrend; // populated for last12Months only
  final List<DeadStockEntry> deadStock;
  final List<CustomerRanking> topCustomers;
  final List<SupplierRanking> topSuppliers;
  final List<SellerRanking> sellerRankings;

  const DashboardIntelligence({
    required this.current,
    this.previous,
    this.monthlyTrend = const [],
    this.deadStock = const [],
    this.topCustomers = const [],
    this.topSuppliers = const [],
    this.sellerRankings = const [],
  });
}

// ── Repository ────────────────────────────────────────────────────────────────

class DashboardIntelligenceRepository {
  final SupabaseClient _db = Supabase.instance.client;

  Future<DashboardIntelligence> load({
    required DashboardTimeRange timeRange,
    String? sellerId,
    required bool isOwner,
  }) async {
    final now = DateTime.now();
    final thisMonthStart = DateTime(now.year, now.month, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final last12Start = DateTime(now.year - 1, now.month, 1);

    DateTime? from;
    switch (timeRange) {
      case DashboardTimeRange.thisMonth:
        from = thisMonthStart;
      case DashboardTimeRange.vsLastMonth:
        from = lastMonthStart; // load both months together, split client-side
      case DashboardTimeRange.last12Months:
        from = last12Start;
      case DashboardTimeRange.allTime:
        from = null;
    }

    final results = await Future.wait([
      _fetchPaidOrders(from: from, sellerId: sellerId),
      _fetchDeadStock(sellerId: sellerId),
      if (isOwner) _fetchCustomers(),
      if (isOwner) _fetchSellers(),
    ]);

    final orders = results[0];
    final deadStockRaw = results[1];
    final customersRaw = isOwner ? results[2] : <Map<String, dynamic>>[];
    final sellersRaw = isOwner ? results[3] : <Map<String, dynamic>>[];

    // ── Profit periods ────────────────────────────────────────────────────────
    late ProfitPeriod current;
    ProfitPeriod? previous;
    List<MonthlyProfit> monthlyTrend = const [];

    if (timeRange == DashboardTimeRange.vsLastMonth) {
      final thisMonthOrders = orders.where((o) {
        final dt = _parseDate(o['order_date']);
        return dt != null && dt.year == now.year && dt.month == now.month;
      }).toList();
      final lastMonthOrders = orders.where((o) {
        final dt = _parseDate(o['order_date']);
        return dt != null &&
            dt.year == lastMonthStart.year &&
            dt.month == lastMonthStart.month;
      }).toList();
      current = _computeProfit(thisMonthOrders);
      previous = _computeProfit(lastMonthOrders);
    } else {
      current = _computeProfit(orders);
      if (timeRange == DashboardTimeRange.last12Months) {
        monthlyTrend = _computeMonthlyTrend(orders);
      }
    }

    // ── Dead stock ────────────────────────────────────────────────────────────
    final deadStock = deadStockRaw.map((row) {
      final createdAt = _parseDate(row['created_at']?.toString()) ?? now;
      return DeadStockEntry(
        id: row['id']?.toString() ?? '',
        title: row['title']?.toString() ?? '',
        sku: row['sku']?.toString() ?? '',
        daysInStock: now.difference(createdAt).inDays,
        costPrice: (row['cost_price'] as num?)?.toDouble() ?? 0,
        isListed: (row['is_listed'] as bool?) ?? false,
      );
    }).toList()
      ..sort((a, b) => b.daysInStock.compareTo(a.daysInStock));

    // ── Customers ─────────────────────────────────────────────────────────────
    final customers = customersRaw.map((row) {
      final spent = (row['total_spent'] as num?)?.toDouble() ?? 0;
      return CustomerRanking(
        name: row['name']?.toString() ?? '',
        totalSpent: spent,
        orderCount: (row['order_count'] as num?)?.toInt() ?? 0,
        tier: row['manual_tier']?.toString() ??
            row['auto_tier']?.toString() ??
            _tierFor(spent),
      );
    }).toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));

    // ── Suppliers & sellers ───────────────────────────────────────────────────
    final suppliers = isOwner ? _computeSuppliers(orders) : <SupplierRanking>[];
    final sellers =
        isOwner ? _computeSellers(orders, sellersRaw) : <SellerRanking>[];

    return DashboardIntelligence(
      current: current,
      previous: previous,
      monthlyTrend: monthlyTrend,
      deadStock: deadStock,
      topCustomers: customers,
      topSuppliers: suppliers,
      sellerRankings: sellers,
    );
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _fetchPaidOrders({
    DateTime? from,
    String? sellerId,
  }) async {
    var query = _db
        .from('orders')
        .select(
          'order_date, commission_amount, seller_id, '
          'order_items(price_at_sale, quantity, '
          'inventory_items(cost_price, supplier_id, suppliers(name)))',
        )
        .eq('status', 'paid');

    if (sellerId != null) query = query.eq('seller_id', sellerId);
    if (from != null) {
      query = query.gte('order_date', _dateStr(from));
    }

    final res = await query;
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<List<Map<String, dynamic>>> _fetchDeadStock({String? sellerId}) async {
    var query = _db
        .from('inventory_items')
        .select('id, title, sku, cost_price, is_listed, seller_id, created_at')
        .inFilter('status', ['available', 'draft', 'reserved'])
        .eq('is_unsorted_lot', false);

    if (sellerId != null) query = query.eq('seller_id', sellerId);
    final res = await query;
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<List<Map<String, dynamic>>> _fetchCustomers() async {
    final res = await _db
        .from('customers')
        .select('name, total_spent, order_count, auto_tier, manual_tier')
        .order('total_spent', ascending: false);
    return List<Map<String, dynamic>>.from(res as List);
  }

  Future<List<Map<String, dynamic>>> _fetchSellers() async {
    final res = await _db.from('sellers').select('id, name');
    return List<Map<String, dynamic>>.from(res as List);
  }

  ProfitPeriod _computeProfit(List<Map<String, dynamic>> orders) {
    double revenue = 0, cost = 0, commission = 0;
    for (final order in orders) {
      commission += (order['commission_amount'] as num?)?.toDouble() ?? 0;
      for (final item in (order['order_items'] as List? ?? [])) {
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        revenue += ((item['price_at_sale'] as num?)?.toDouble() ?? 0) * qty;
        final inv = item['inventory_items'] as Map<String, dynamic>?;
        cost += ((inv?['cost_price'] as num?)?.toDouble() ?? 0) * qty;
      }
    }
    return ProfitPeriod(revenue: revenue, cost: cost, commission: commission);
  }

  List<MonthlyProfit> _computeMonthlyTrend(List<Map<String, dynamic>> orders) {
    final map = <String, ({double revenue, double cost})>{};
    for (final order in orders) {
      final dateStr = order['order_date']?.toString() ?? '';
      if (dateStr.length < 7) continue;
      final key = dateStr.substring(0, 7); // YYYY-MM
      double rev = 0, cst = 0;
      for (final item in (order['order_items'] as List? ?? [])) {
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        rev += ((item['price_at_sale'] as num?)?.toDouble() ?? 0) * qty;
        final inv = item['inventory_items'] as Map<String, dynamic>?;
        cst += ((inv?['cost_price'] as num?)?.toDouble() ?? 0) * qty;
      }
      final e = map[key];
      map[key] = e == null
          ? (revenue: rev, cost: cst)
          : (revenue: e.revenue + rev, cost: e.cost + cst);
    }
    final sorted = map.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted.map((e) {
      final parts = e.key.split('-');
      return MonthlyProfit(
        year: int.parse(parts[0]),
        month: int.parse(parts[1]),
        revenue: e.value.revenue,
        cost: e.value.cost,
      );
    }).toList();
  }

  List<SupplierRanking> _computeSuppliers(List<Map<String, dynamic>> orders) {
    final map = <String, ({String name, int count, double profit})>{};
    for (final order in orders) {
      for (final item in (order['order_items'] as List? ?? [])) {
        final inv = item['inventory_items'] as Map<String, dynamic>?;
        if (inv == null) continue;
        final supplierId = inv['supplier_id']?.toString();
        if (supplierId == null) continue;
        final supplierName =
            (inv['suppliers'] as Map<String, dynamic>?)?['name']?.toString() ??
                'Unknown';
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        final sale = (item['price_at_sale'] as num?)?.toDouble() ?? 0;
        final cost = (inv['cost_price'] as num?)?.toDouble() ?? 0;
        final profit = (sale - cost) * qty;
        final e = map[supplierId];
        map[supplierId] = e == null
            ? (name: supplierName, count: qty, profit: profit)
            : (name: e.name, count: e.count + qty, profit: e.profit + profit);
      }
    }
    return (map.entries
          .map((e) => SupplierRanking(
                supplierName: e.value.name,
                itemsSold: e.value.count,
                totalProfit: e.value.profit,
              ))
          .toList()
          ..sort((a, b) => b.totalProfit.compareTo(a.totalProfit)));
  }

  List<SellerRanking> _computeSellers(
    List<Map<String, dynamic>> orders,
    List<Map<String, dynamic>> sellers,
  ) {
    final nameMap = {for (final s in sellers) s['id']?.toString(): s['name']?.toString()};
    final map = <String, ({String name, double rev, double comm, int count})>{};
    for (final order in orders) {
      final sid = order['seller_id']?.toString();
      if (sid == null) continue;
      final comm = (order['commission_amount'] as num?)?.toDouble() ?? 0;
      int count = 0;
      double rev = 0;
      for (final item in (order['order_items'] as List? ?? [])) {
        final qty = (item['quantity'] as num?)?.toInt() ?? 1;
        rev += ((item['price_at_sale'] as num?)?.toDouble() ?? 0) * qty;
        count += qty;
      }
      final e = map[sid];
      map[sid] = e == null
          ? (name: nameMap[sid] ?? 'Unknown', rev: rev, comm: comm, count: count)
          : (name: e.name, rev: e.rev + rev, comm: e.comm + comm, count: e.count + count);
    }
    return (map.entries
          .map((e) => SellerRanking(
                sellerName: e.value.name,
                revenue: e.value.rev,
                commission: e.value.comm,
                itemsSold: e.value.count,
              ))
          .toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue)));
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String _dateStr(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  static String _tierFor(double spent) {
    if (spent >= 50000) return 'Collector';
    if (spent >= 15000) return 'Premium';
    if (spent >= 5000) return 'Gold';
    return 'Silver';
  }
}
