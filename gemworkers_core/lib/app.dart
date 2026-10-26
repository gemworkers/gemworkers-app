import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/auth_service.dart';
import 'core/services/user_profile_service.dart';
import 'core/utils/open_url/open_url.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/no_profile_page.dart';
import 'pages/auth/seller_terms_page.dart';
import 'pages/subscribers/subscribers_page.dart';
import 'pages/settings/social_links_dialog.dart';
import 'pages/sellers/sellers_page.dart';
import 'pages/customers/customers_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/inventory/inventory_page.dart';
import 'pages/makers/makers_page.dart';
import 'pages/reviews/reviews_page.dart';
import 'pages/returns/returns_page.dart';
import 'pages/owners/owners_page.dart';
import 'pages/payouts/payouts_page.dart';
import 'pages/locations/locations_page.dart';
import 'repositories/return_repository.dart';
import 'pages/taxes/taxes_page.dart';
import 'pages/messages/messages_page.dart';
import 'pages/offers/offers_page.dart';
import 'pages/orders/orders_page.dart';
import 'pages/purchases/purchases_page.dart';
import 'pages/suppliers/suppliers_page.dart';
import 'repositories/inventory_repository.dart';
import 'repositories/messages_repository.dart';
import 'repositories/offers_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/review_repository.dart';
import 'theme/app_theme.dart';
import 'widgets/update_notice.dart';
import 'widgets/shop_sidebar.dart';

class GemWorkersApp extends StatelessWidget {
  const GemWorkersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GemWorkers',
      theme: AppTheme.light,
      // "New version available" bar above every screen (deploy_admin.sh).
      builder: (context, child) => UpdateNotice(child: child ?? const SizedBox.shrink()),
      home: StreamBuilder<AuthState>(
        stream: AuthService.authStateChanges,
        builder: (context, _) {
          final session = Supabase.instance.client.auth.currentSession;
          if (session != null) {
            return _ProfileGate(userId: session.user.id);
          }
          UserProfileService.instance.clear();
          return const LoginPage();
        },
      ),
    );
  }
}

// ── Profile gate ──────────────────────────────────────────────────────────────
// Loads the user's profile once and routes to the appropriate screen.

class _ProfileGate extends StatefulWidget {
  final String userId;
  const _ProfileGate({required this.userId});

  @override
  State<_ProfileGate> createState() => _ProfileGateState();
}

class _ProfileGateState extends State<_ProfileGate> {
  @override
  void initState() {
    super.initState();
    UserProfileService.instance.loadForUser(widget.userId);
  }

  @override
  void didUpdateWidget(_ProfileGate old) {
    super.didUpdateWidget(old);
    if (old.userId != widget.userId) {
      UserProfileService.instance.loadForUser(widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppAuthState>(
      valueListenable: UserProfileService.instance.appState,
      builder: (context, state, _) => switch (state) {
        AppAuthState.loading || AppAuthState.initial =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
        AppAuthState.noProfile => const NoProfilePage(),
        // Sellers agree to the seller terms first (sql/seller_terms.sql).
        AppAuthState.ready => const SellerTermsGate(child: MainLayout()),
      },
    );
  }
}

// ── Main layout ───────────────────────────────────────────────────────────────

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  // Phones: the More tab (grouped list of the other pages) is showing.
  bool _phoneMore = false;
  // Tab to open when a dashboard link switches page; cleared on sidebar taps.
  String? _ordersStatus;
  String? _listingsTab;
  int _taxesTab = 0; // Taxes & duties tab when opened from the Dashboard
  int _toShipCount = 0;
  int _pendingOffersCount = 0;
  int _unreadMessagesCount = 0;
  int _awaitingApprovalCount = 0; // owner only: seller listing requests
  int _pendingReviewsCount = 0; // owner only: reviews waiting for approval
  int _openReturnsCount = 0; // owner only: returns to approve or refund
  final _inventoryRepo = InventoryRepository();
  final _reviewRepo = ReviewRepository();
  final _returnRepo = ReturnRepository();
  final _orderRepo = OrderRepository();
  final _offersRepo = OffersRepository();
  final _messagesRepo = MessagesRepository();
  Timer? _messagesTimer;

  @override
  void initState() {
    super.initState();
    _loadCounts();
    _messagesTimer = Timer.periodic(
        const Duration(seconds: 60), (_) => _loadMessagesCount());
  }

  @override
  void dispose() {
    _messagesTimer?.cancel();
    super.dispose();
  }

  /// Conversations with unread buyer messages (staff_unread_count).
  Future<void> _loadMessagesCount() async {
    try {
      final count = await _messagesRepo.getUnreadCount();
      if (mounted && count != _unreadMessagesCount) {
        setState(() => _unreadMessagesCount = count);
      }
    } catch (_) {}
  }

  Future<void> _loadCounts() async {
    final svc = UserProfileService.instance;
    final sellerId = svc.shouldFilterBySeller ? svc.sellerId : null;
    try {
      final count = await _orderRepo.getToShipCount(sellerId: sellerId);
      if (mounted) setState(() => _toShipCount = count);
    } catch (_) {}
    try {
      final count = await _offersRepo.getPendingCount(sellerId: sellerId);
      if (mounted) setState(() => _pendingOffersCount = count);
    } catch (_) {}
    if (svc.isOwner) {
      try {
        final count = await _inventoryRepo.getAwaitingApprovalCount();
        if (mounted) setState(() => _awaitingApprovalCount = count);
      } catch (_) {}
      await _loadReviewsCount();
      await _loadReturnsCount();
    }
    await _loadMessagesCount();
  }

  Future<void> _loadReviewsCount() async {
    try {
      final count = await _reviewRepo.getPendingCount();
      if (mounted) setState(() => _pendingReviewsCount = count);
    } catch (_) {}
  }

  Future<void> _loadReturnsCount() async {
    try {
      final count = await _returnRepo.getOpenCount();
      if (mounted) setState(() => _openReturnsCount = count);
    } catch (_) {}
  }

  bool get _isOwner => UserProfileService.instance.isOwner;

  // Sidebar indices — Dashboard, Listings, Orders and Offers are always first.
  static const _listingsIndex = 1;
  static const _ordersIndex = 2;
  static const _offersIndex = 3;

  void _openFromDashboard(DashboardDestination d) {
    setState(() {
      _ordersStatus = null;
      _listingsTab = null;
      _taxesTab = 0;
      switch (d) {
        case DashboardDestination.ordersToShip:
          _ordersStatus = 'confirmed';
          _selectedIndex = _ordersIndex;
        case DashboardDestination.ordersAwaitingPayment:
          _ordersStatus = 'pending_payment';
          _selectedIndex = _ordersIndex;
        case DashboardDestination.ordersAll:
          _ordersStatus = 'all';
          _selectedIndex = _ordersIndex;
        case DashboardDestination.offers:
          _selectedIndex = _offersIndex;
        case DashboardDestination.listingsDraft:
          _listingsTab = 'draft';
          _selectedIndex = _listingsIndex;
        case DashboardDestination.payouts:
          _selectedIndex = _pages.indexWhere((p) => p is PayoutsPage);
        case DashboardDestination.returns:
          _selectedIndex = _pages.indexWhere((p) => p is ReturnsPage);
        case DashboardDestination.taxes:
          _taxesTab = 4;
          _selectedIndex = _pages.indexWhere((p) => p is TaxesPage);
      }
    });
    _loadCounts();
  }

  List<Widget> get _pages => [
        DashboardPage(onNavigate: _openFromDashboard),
        InventoryPage(initialTab: _listingsTab),
        OrdersPage(initialStatusFilter: _ordersStatus),
        const OffersPage(),
        MessagesPage(onUnreadChanged: _loadMessagesCount),
        const PayoutsPage(),
        if (_isOwner) const CustomersPage(),
        const PurchasesPage(),
        const SuppliersPage(),
        if (_isOwner) const SellersPage(),
        if (_isOwner) const OwnersPage(),
        if (_isOwner) const LocationsPage(),
        if (_isOwner) const MakersPage(),
        if (_isOwner) ReviewsPage(onPendingChanged: _loadReviewsCount),
        if (_isOwner) const SubscribersPage(),
        if (_isOwner) ReturnsPage(onOpenChanged: _loadReturnsCount),
        if (_isOwner) TaxesPage(key: ValueKey('taxes-$_taxesTab'), initialTab: _taxesTab),
      ];

  List<ShopNavItem> get _destinations => [
        const ShopNavItem(
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          label: 'Dashboard',
        ),
        ShopNavItem(
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          label: 'Listings',
          badgeCount: _isOwner ? _awaitingApprovalCount : 0,
        ),
        ShopNavItem(
          icon: Icons.local_shipping_outlined,
          selectedIcon: Icons.local_shipping,
          label: 'Orders & Shipping',
          badgeCount: _toShipCount,
        ),
        ShopNavItem(
          icon: Icons.local_offer_outlined,
          selectedIcon: Icons.local_offer,
          label: 'Offers',
          badgeCount: _pendingOffersCount,
        ),
        ShopNavItem(
          icon: Icons.chat_bubble_outline,
          selectedIcon: Icons.chat_bubble,
          label: 'Messages',
          badgeCount: _unreadMessagesCount,
        ),
        const ShopNavItem(
          icon: Icons.payments_outlined,
          selectedIcon: Icons.payments,
          label: 'Payouts',
        ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Customers',
          ),
        const ShopNavItem(
          icon: Icons.shopping_bag_outlined,
          selectedIcon: Icons.shopping_bag,
          label: 'Purchases',
        ),
        const ShopNavItem(
          icon: Icons.people_outline,
          selectedIcon: Icons.people,
          label: 'Suppliers',
        ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.store_outlined,
            selectedIcon: Icons.store,
            label: 'Sellers',
          ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.handshake_outlined,
            selectedIcon: Icons.handshake,
            label: 'Owners',
          ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.place_outlined,
            selectedIcon: Icons.place,
            label: 'Locations',
          ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.handyman_outlined,
            selectedIcon: Icons.handyman,
            label: 'Makers',
          ),
        if (_isOwner)
          ShopNavItem(
            icon: Icons.star_outline,
            selectedIcon: Icons.star,
            label: 'Reviews',
            badgeCount: _pendingReviewsCount,
          ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.mark_email_read_outlined,
            selectedIcon: Icons.mark_email_read,
            label: 'Subscribers',
          ),
        if (_isOwner)
          ShopNavItem(
            icon: Icons.assignment_return_outlined,
            selectedIcon: Icons.assignment_return,
            label: 'Returns',
            badgeCount: _openReturnsCount,
          ),
        if (_isOwner)
          const ShopNavItem(
            icon: Icons.public_outlined,
            selectedIcon: Icons.public,
            label: 'Taxes & duties',
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    final destinations = _destinations;
    // Guard against stale index when role changes (e.g. after profile load).
    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    void select(int i) {
      setState(() {
        _selectedIndex = i;
        _ordersStatus = null;
        _listingsTab = null;
        _taxesTab = 0;
      });
      _loadCounts();
    }

    // Phones: Etsy Seller-style bottom bar — Home · Messages · Orders ·
    // Listings · More (everything else, grouped). Pages keep their own top bar.
    if (MediaQuery.sizeOf(context).width < 600) {
      // Page index of each main tab in _pages / _destinations.
      const tabPages = [0, 4, 2, 1];
      final inMain = tabPages.contains(safeIndex);
      final activeTab = _phoneMore || !inMain ? 4 : tabPages.indexOf(safeIndex);
      final otherBadges = [
        for (var i = 0; i < destinations.length; i++)
          if (!tabPages.contains(i)) destinations[i].badgeCount,
      ].fold<int>(0, (a, b) => a + b);
      final tabs = [
        (Icons.home_outlined, Icons.home, 'Home', 0),
        (Icons.chat_bubble_outline, Icons.chat_bubble, 'Messages', destinations[4].badgeCount),
        (Icons.receipt_long_outlined, Icons.receipt_long, 'Orders', destinations[2].badgeCount),
        (Icons.category_outlined, Icons.category, 'Listings', destinations[1].badgeCount),
        (Icons.menu, Icons.menu, 'More', otherBadges),
      ];
      return Scaffold(
        body: _phoneMore
            ? _MoreMenu(
                destinations: destinations,
                hidden: tabPages,
                onSelected: (i) {
                  setState(() => _phoneMore = false);
                  select(i);
                },
              )
            : pages[safeIndex],
        bottomNavigationBar: Material(
          color: AppColors.surface,
          elevation: 8,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  for (var t = 0; t < tabs.length; t++)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (t == 4) {
                            setState(() => _phoneMore = true);
                          } else {
                            setState(() => _phoneMore = false);
                            select(tabPages[t]);
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Badge(
                              isLabelVisible: tabs[t].$4 > 0,
                              label: Text('${tabs[t].$4}'),
                              child: Icon(
                                activeTab == t ? tabs[t].$2 : tabs[t].$1,
                                color: activeTab == t ? AppColors.ink : AppColors.muted,
                              ),
                            ),
                            // Like Etsy: only the selected tab shows its name.
                            if (activeTab == t)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(tabs[t].$3,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          ShopSidebar(
            items: destinations,
            selectedIndex: safeIndex,
            onSelected: select,
            accountBuilder: (compact) => _UserMenu(compact: compact),
          ),
          Expanded(
            child: pages[safeIndex],
          ),
        ],
      ),
    );
  }
}

// ── User account menu ─────────────────────────────────────────────────────────

class _UserMenu extends StatelessWidget {
  final bool compact;
  const _UserMenu({required this.compact});

  @override
  Widget build(BuildContext context) {
    final svc = UserProfileService.instance;
    final profile = svc.profile;
    final email = AuthService.currentUserEmail ?? '';
    final displayName = profile?.displayName;
    final initial = displayName?.isNotEmpty == true
        ? displayName![0].toUpperCase()
        : email.isNotEmpty
            ? email[0].toUpperCase()
            : '?';
    final role = svc.isOwner ? 'Owner' : 'Seller';
    final textTheme = Theme.of(context).textTheme;

    final avatar = CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.raised,
      child: Text(
        initial,
        style: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
        ),
      ),
    );

    return PopupMenuButton<String>(
      tooltip: 'Account',
      position: PopupMenuPosition.over,
      offset: Offset(compact ? 56 : 0, -8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: compact
            ? Center(child: avatar)
            : Row(
                children: [
                  avatar,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName?.isNotEmpty == true
                              ? displayName!
                              : (email.isNotEmpty ? email : 'Account'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          role,
                          style: textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.unfold_more,
                      size: 18, color: AppColors.muted),
                ],
              ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            email,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'social',
          child: Row(
            children: [
              Icon(Icons.share_outlined, size: 18),
              SizedBox(width: 10),
              Text('Social media'),
            ],
          ),
        ),
        if (!svc.isOwner)
          const PopupMenuItem(
            value: 'terms',
            child: Row(
              children: [
                Icon(Icons.description_outlined, size: 18),
                SizedBox(width: 10),
                Text('Seller terms'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'signout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 10),
              Text('Sign out'),
            ],
          ),
        ),
      ],
      onSelected: (value) async {
        if (value == 'social' && context.mounted) {
          await showSocialLinksDialog(context);
        }
        if (value == 'terms') {
          final terms = await loadSellerTerms();
          if (terms != null && context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => SellerTermsPage(terms: terms)));
          }
        }
        if (value == 'signout') {
          UserProfileService.instance.clear();
          await AuthService.signOut();
        }
      },
    );
  }
}

// ── Phone "More" tab (Etsy Seller-style grouped list) ─────────────────────────

class _MoreMenu extends StatelessWidget {
  final List<ShopNavItem> destinations;
  final List<int> hidden;               // pages already in the bottom bar
  final ValueChanged<int> onSelected;
  const _MoreMenu({required this.destinations, required this.hidden, required this.onSelected});

  static const _groups = <(String, List<String>)>[
    ('Selling', ['Offers', 'Payouts', 'Returns', 'Reviews']),
    ('Stock', ['Purchases', 'Suppliers', 'Locations', 'Makers']),
    ('People', ['Customers', 'Sellers', 'Owners', 'Subscribers']),
    ('Business', ['Taxes & duties']),
  ];

  @override
  Widget build(BuildContext context) {
    final svc = UserProfileService.instance;
    final email = AuthService.currentUserEmail ?? '';
    final name = svc.profile?.displayName;
    final textTheme = Theme.of(context).textTheme;
    final byLabel = {
      for (var i = 0; i < destinations.length; i++)
        if (!hidden.contains(i)) destinations[i].label: i,
    };
    final grouped = {for (final g in _groups) ...g.$2};
    final others = byLabel.keys.where((l) => !grouped.contains(l)).toList();

    Widget tile(IconData icon, String label, VoidCallback onTap, {int badge = 0}) => ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.raised,
            child: Icon(icon, size: 20, color: AppColors.ink),
          ),
          title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          trailing: badge > 0 ? Badge(label: Text('$badge')) : null,
          onTap: onTap,
        );

    Widget section(String title, List<Widget> children) => children.isEmpty
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
                child: Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              ),
              ...children,
            ],
          );

    List<Widget> pageTiles(List<String> labels) => [
          for (final l in labels)
            if (byLabel[l] != null)
              tile(destinations[byLabel[l]!].icon, l, () => onSelected(byLabel[l]!),
                  badge: destinations[byLabel[l]!].badgeCount),
        ];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // Account (like Etsy's shop header / Switch Account).
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.raised,
                    child: Text(
                      (name?.isNotEmpty == true ? name! : (email.isNotEmpty ? email : '?'))[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name?.isNotEmpty == true ? name! : email,
                            style: textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                        Text(svc.isOwner ? 'Owner' : 'Seller',
                            style: textTheme.bodySmall?.copyWith(color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            section('Shop', [
              tile(Icons.open_in_new, 'View shop on GemWorkers', () => openUrl('https://www.gemworkers.com')),
              tile(Icons.share_outlined, 'GemWorkers on social media', () => showSocialLinksDialog(context)),
            ]),
            for (final g in _groups) section(g.$1, pageTiles(g.$2)),
            if (others.isNotEmpty) section('Other', pageTiles(others)),
            section('Settings', [
              if (!svc.isOwner)
                tile(Icons.description_outlined, 'Seller terms', () async {
                  final terms = await loadSellerTerms();
                  if (terms != null && context.mounted) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SellerTermsPage(terms: terms)));
                  }
                }),
              tile(Icons.logout, 'Sign out', () async {
                UserProfileService.instance.clear();
                await AuthService.signOut();
              }),
            ]),
          ],
        ),
      ),
    );
  }
}
