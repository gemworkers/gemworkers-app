import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/services/auth_service.dart';
import 'core/services/user_profile_service.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/no_profile_page.dart';
import 'pages/sellers/sellers_page.dart';
import 'pages/customers/customers_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/inventory/inventory_page.dart';
import 'pages/orders/orders_page.dart';
import 'pages/purchases/purchases_page.dart';
import 'pages/suppliers/suppliers_page.dart';

class GemWorkersApp extends StatelessWidget {
  const GemWorkersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GemWorkers',
      theme: ThemeData(useMaterial3: true),
      home: ValueListenableBuilder<bool>(
        valueListenable: AuthService.devBypass,
        builder: (context, bypass, _) => StreamBuilder<AuthState>(
          stream: AuthService.authStateChanges,
          builder: (context, _) {
            if (bypass) {
              UserProfileService.instance.setDevOwner();
              return const MainLayout();
            }
            final session = Supabase.instance.client.auth.currentSession;
            if (session != null) {
              return _ProfileGate(userId: session.user.id);
            }
            UserProfileService.instance.clear();
            return const LoginPage();
          },
        ),
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
        AppAuthState.ready => const MainLayout(),
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

  bool get _isOwner => UserProfileService.instance.isOwner;

  List<Widget> get _pages => [
        const DashboardPage(),
        const InventoryPage(),
        const OrdersPage(),
        const CustomersPage(),
        const PurchasesPage(),
        const SuppliersPage(),
        if (_isOwner) const SellersPage(),
      ];

  List<NavigationRailDestination> get _destinations => [
        const NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: Text('Inventory'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Orders'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Customers'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: Text('Purchases'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: Text('Suppliers'),
        ),
        if (_isOwner)
          const NavigationRailDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: Text('Sellers'),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final pages = _pages;
    final destinations = _destinations;
    // Guard against stale index when role changes (e.g. after profile load).
    final safeIndex = _selectedIndex.clamp(0, pages.length - 1);

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: safeIndex,
            onDestinationSelected: (i) =>
                setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            destinations: destinations,
            trailing: const _UserMenu(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
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
  const _UserMenu();

  @override
  Widget build(BuildContext context) {
    final profile = UserProfileService.instance.profile;
    final email = AuthService.currentUserEmail ?? '';
    final displayName = profile?.displayName;
    final initial = displayName?.isNotEmpty == true
        ? displayName![0].toUpperCase()
        : email.isNotEmpty
            ? email[0].toUpperCase()
            : '?';
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(72, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(height: 1),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primaryContainer,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              displayName ?? 'Account',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            email.isNotEmpty ? email : 'Dev bypass',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
        ),
        const PopupMenuDivider(),
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
        if (value == 'signout') {
          AuthService.devBypass.value = false; // TODO remove before production
          UserProfileService.instance.clear();
          await AuthService.signOut();
        }
      },
    );
  }
}
