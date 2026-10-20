import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/customer.dart';
import '../../repositories/customer_repository.dart';
import '../../theme/app_theme.dart';
import 'add_edit_customer_page.dart';
import 'customer_detail_page.dart';

// ── Tabs ──────────────────────────────────────────────────────────────────────

enum _CustomersTab {
  all('All', null, 'No customers yet.'),
  inPerson('In person', 'manual', 'No in-person customers yet.'),
  website('Website', 'website', 'No website customers yet.');

  final String label;

  /// Customer.source shown in this tab; null = every source.
  final String? source;
  final String emptyMessage;
  const _CustomersTab(this.label, this.source, this.emptyMessage);

  bool includes(Customer c) => source == null || c.source == source;
}

// ── Page ──────────────────────────────────────────────────────────────────────

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage>
    with SingleTickerProviderStateMixin {
  final _repository = CustomerRepository();
  final _searchController = TextEditingController();
  late final TabController _tabController;

  List<Customer> _all = [];
  bool _loading = true;
  String _query = '';
  _CustomersTab _tab = _CustomersTab.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _CustomersTab.values.length,
      vsync: this,
    )..addListener(() {
        if (!_tabController.indexIsChanging &&
            _tabController.index != _tab.index) {
          setState(() => _tab = _CustomersTab.values[_tabController.index]);
        }
      });
    _searchController.addListener(_onSearch);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController
      ..removeListener(_onSearch)
      ..dispose();
    super.dispose();
  }

  void _onSearch() =>
      setState(() => _query = _searchController.text.toLowerCase().trim());

  // ── Data ──────────────────────────────────────────────────────────────────

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final customers = await _repository.getAllCustomers();
      // Most recent buyers first; never-ordered customers last, by name.
      customers.sort((a, b) {
        final la = a.lastOrder, lb = b.lastOrder;
        if (la != null && lb != null) return lb.compareTo(la);
        if (la != null) return -1;
        if (lb != null) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      if (mounted) setState(() { _all = customers; _loading = false; });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Search applied, tab not applied (tab counts use this).
  List<Customer> get _searched {
    if (_query.isEmpty) return _all;
    return _all
        .where((c) =>
            c.name.toLowerCase().contains(_query) ||
            c.email.toLowerCase().contains(_query) ||
            c.country.toLowerCase().contains(_query))
        .toList();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditCustomerPage()),
    );
    if (added == true) _load();
  }

  Future<void> _openDetail(Customer customer) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerDetailPage(customer: customer)),
    );
    _load();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final gutter = wide ? 32.0 : 16.0;
    final searched = _searched;
    final visible = searched.where(_tab.includes).toList();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _load,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, wide ? 28 : 20, gutter, 20),
              sliver: SliverToBoxAdapter(child: _buildTop(wide, searched)),
            ),
            if (_loading && _all.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (visible.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(
                  message: _query.isNotEmpty
                      ? 'No customers match your search.'
                      : _tab.emptyMessage,
                  onClear: _query.isNotEmpty ? _searchController.clear : null,
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, 32),
                sliver: SliverToBoxAdapter(
                  child: _CustomerList(
                    visible,
                    wide: wide,
                    onTap: _openDetail,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop(bool wide, List<Customer> searched) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Customers',
                style: textTheme.headlineLarge
                    ?.copyWith(fontSize: wide ? 40 : 30, height: 1.1),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: _openAdd,
              icon: const Icon(Icons.add, size: 20),
              label: Text(wide ? 'Add customer' : 'Add'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Everyone who has bought from you, in person and on the website.',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search name, email, country…',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: _searchController.clear,
                      )
                    : null,
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.only(right: 28),
          tabs: [
            for (final t in _CustomersTab.values)
              Tab(
                child: Text.rich(TextSpan(children: [
                  TextSpan(text: t.label),
                  TextSpan(
                    text: '  ${searched.where(t.includes).length}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontWeight: FontWeight.w600,
                      fontFeatures: AppTheme.tabularFigures,
                    ),
                  ),
                ])),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;
  final VoidCallback? onClear;
  const _EmptyState({required this.message, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: AppColors.muted),
          ),
          if (onClear != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onClear, child: const Text('Clear search')),
          ],
        ],
      ),
    );
  }
}

/// All rows in one white card, separated by hairlines.
class _CustomerList extends StatelessWidget {
  final List<Customer> customers;
  final bool wide;
  final Future<void> Function(Customer) onTap;
  const _CustomerList(this.customers, {required this.wide, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      // Table layout whenever the card has room for the columns; stacked
      // only at phone width.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final table = constraints.maxWidth >= 640;
          return Column(
            children: [
              for (var i = 0; i < customers.length; i++) ...[
                if (i > 0)
                  const Divider(
                      height: 1, thickness: 1, color: AppColors.rowDivider),
                _CustomerRow(customers[i],
                    table: table, wide: wide, onTap: onTap),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CustomerRow extends StatelessWidget {
  final Customer customer;
  final bool table;
  final bool wide;
  final Future<void> Function(Customer) onTap;
  const _CustomerRow(this.customer,
      {required this.table, required this.wide, required this.onTap});

  static final _money =
      NumberFormat.currency(locale: 'en', symbol: '€', decimalDigits: 2);

  static String _date(DateTime d) {
    final local = d.toLocal();
    return DateFormat(local.year == DateTime.now().year ? 'd MMM' : 'd MMM y')
        .format(local);
  }

  String get _orders =>
      '${customer.orderCount} order${customer.orderCount == 1 ? '' : 's'}';

  String get _spent => '${_money.format(customer.totalSpent)} spent';

  String get _lastOrder => customer.lastOrder != null
      ? 'Last order ${_date(customer.lastOrder!)}'
      : 'No orders yet';

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final muted = t.bodyMedium?.copyWith(fontSize: 13, color: AppColors.muted);
    final figures = t.bodyMedium?.copyWith(
        fontWeight: FontWeight.w500, fontFeatures: AppTheme.tabularFigures);

    final nameBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(customer.name.isNotEmpty ? customer.name : customer.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        if (customer.email.isNotEmpty && customer.email != customer.name)
          Text(customer.email,
              maxLines: 1, overflow: TextOverflow.ellipsis, style: muted),
      ],
    );

    // One-line, ellipsized cell so no column can push the row taller.
    Widget cell(String text, TextStyle? style,
            {TextAlign align = TextAlign.left}) =>
        Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: align,
            style: style);

    // Table rows: fixed height, every column centred on the same line as
    // the name. Flex widths (not fixed) so the row fits beside the sidebar.
    if (table) {
      return InkWell(
        onTap: () => onTap(customer),
        hoverColor: AppColors.raised.withValues(alpha: 0.3),
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: wide ? 20 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Avatar(customer.name),
                const SizedBox(width: 16),
                Expanded(flex: 5, child: nameBlock),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: cell(
                      customer.country.isNotEmpty ? customer.country : '—',
                      muted),
                ),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: cell(_orders, figures)),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: cell(_spent, figures, align: TextAlign.right),
                ),
                const SizedBox(width: 24),
                Expanded(flex: 3, child: cell(_lastOrder, muted)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 84,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomerSourceChip(customer.source),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Phone width: stacked.
    final Widget content = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(customer.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    nameBlock,
                    const SizedBox(height: 6),
                    Text(
                      [
                        if (customer.country.isNotEmpty) customer.country,
                        _orders,
                        _spent,
                      ].join('  ·  '),
                      style: t.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontFeatures: AppTheme.tabularFigures),
                    ),
                    Text(_lastOrder, style: muted),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CustomerSourceChip(customer.source),
            ],
          );

    return InkWell(
      onTap: () => onTap(customer),
      hoverColor: AppColors.raised.withValues(alpha: 0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: content,
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar(this.name);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.raised,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
            color: AppColors.ink, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// "In person" (manual customer) or "Website" (storefront buyer) chip.
class CustomerSourceChip extends StatelessWidget {
  final String source;
  const CustomerSourceChip(this.source, {super.key});

  @override
  Widget build(BuildContext context) {
    final website = source == 'website';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: ShapeDecoration(
        color: website
            ? AppColors.accent.withValues(alpha: 0.1)
            : AppColors.raised,
        shape: const StadiumBorder(),
      ),
      child: Text(
        website ? 'Website' : 'In person',
        style: TextStyle(
          fontSize: 12,
          color: website ? AppColors.accent : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
