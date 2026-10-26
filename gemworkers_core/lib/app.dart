import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/auth_service.dart';
import 'core/services/user_profile_service.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/no_profile_page.dart';
import 'pages/auth/seller_terms_page.dart';
import 'pages/subscribers/subscribers_page.dart';
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

    // Phones: the menu slides in from a "Menu" bar at the bottom (thumb
    // reach); pages keep their own title bar at the top.
    if (MediaQuery.sizeOf(context).width < 600) {
      final waiting = destinations.any((d) => d.badgeCount > 0);
      return Scaffold(
        drawer: Drawer(
          width: ShopSidebar.expandedWidth,
          child: Builder(
            builder: (drawerContext) => ShopSidebar(
              items: destinations,
              selectedIndex: safeIndex,
              forceCompact: false,
              onSelected: (i) {
                Navigator.of(drawerContext).pop();
                select(i);
              },
              accountBuilder: (_) => const _UserMenu(compact: false),
            ),
          ),
        ),
        body: pages[safeIndex],
        bottomNavigationBar: Builder(
          builder: (barContext) => Material(
            color: AppColors.surface,
            elevation: 8,
            child: SafeArea(
              top: false,
              child: InkWell(
                onTap: () => Scaffold.of(barContext).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Badge(isLabelVisible: waiting, smallSize: 9, child: const Icon(Icons.menu)),
                      const SizedBox(width: 12),
                      const Text('Menu', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          destinations[safeIndex].label,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                ),
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
