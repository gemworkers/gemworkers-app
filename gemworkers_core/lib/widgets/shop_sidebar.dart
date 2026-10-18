import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// One destination in [ShopSidebar].
class ShopNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Red count badge; hidden when 0.
  final int badgeCount;

  const ShopNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

/// Etsy Shop Manager–style left sidebar. Collapses to an icon-only rail
/// below [compactBreakpoint].
class ShopSidebar extends StatelessWidget {
  static const double expandedWidth = 248;
  static const double compactWidth = 72;
  static const double compactBreakpoint = 900;

  final List<ShopNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Account block at the bottom; receives whether the rail is compact.
  final Widget Function(bool compact) accountBuilder;

  const ShopSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.accountBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < compactBreakpoint;

    return Container(
      width: compact ? compactWidth : expandedWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Brand(compact: compact),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: compact ? 12 : 16, vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (_, i) => _NavTile(
                  item: items[i],
                  selected: i == selectedIndex,
                  compact: compact,
                  onTap: () => onSelected(i),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 16, vertical: 12),
              child: accountBuilder(compact),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Brand header ──────────────────────────────────────────────────────────────

class _Brand extends StatelessWidget {
  final bool compact;
  const _Brand({required this.compact});

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'G',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GemWorkers',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'SHOP MANAGER',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: AppColors.muted,
                  letterSpacing: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Nav tile ──────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  final ShopNavItem item;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    final icon = Icon(
      selected ? item.selectedIcon : item.icon,
      size: 20,
      color: selected ? AppColors.ink : AppColors.textSecondary,
    );

    final Widget content = compact
        ? Center(
            child: Badge(
              isLabelVisible: item.badgeCount > 0,
              backgroundColor: AppColors.error,
              smallSize: 8,
              child: icon,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 15,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                          color: AppColors.ink,
                        ),
                  ),
                ),
                if (item.badgeCount > 0) _CountBadge(item.badgeCount),
              ],
            ),
          );

    final tile = Material(
      color: selected ? AppColors.raised : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        hoverColor: AppColors.raised.withValues(alpha: 0.6),
        splashColor: AppColors.border,
        highlightColor: AppColors.raised,
        child: SizedBox(height: 44, child: content),
      ),
    );

    if (!compact) return tile;
    final tooltip = item.badgeCount > 0
        ? '${item.label} (${item.badgeCount})'
        : item.label;
    return Tooltip(
      message: tooltip,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 300),
      child: tile,
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: const ShapeDecoration(
        color: AppColors.error,
        shape: StadiumBorder(),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
      ),
    );
  }
}
