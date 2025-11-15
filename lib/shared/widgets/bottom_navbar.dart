import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final String routeName;
  final IconData? activeIcon;
  final int badgeCount;
  final String? tooltip;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.routeName,
    this.activeIcon,
    this.badgeCount = 0,
    this.tooltip,
  });
}

class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final ValueChanged<String>? onItemTapped;
  final String? currentRoute;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final Color highlightColor;
  final EdgeInsetsGeometry padding;
  final Duration animationDuration;
  final Curve animationCurve;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    this.onItemTapped,
    this.currentRoute,
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFF2C6B6F),
    this.inactiveColor = Colors.grey,
    this.highlightColor = const Color(0x1A2C6B6F),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final normalizedCurrentRoute = _normalizeRoute(currentRoute ?? Get.currentRoute);
    int resolvedIndex = -1;

    // Cari item yang cocok dengan route saat ini
    if (normalizedCurrentRoute.isNotEmpty) {
      resolvedIndex = items.indexWhere(
            (item) => _normalizeRoute(item.routeName) == normalizedCurrentRoute,
      );

      // Jika tidak ditemukan exact match, coba partial match
      if (resolvedIndex == -1) {
        resolvedIndex = items.indexWhere(
              (item) => normalizedCurrentRoute.startsWith(_normalizeRoute(item.routeName)) ||
              _normalizeRoute(item.routeName).startsWith(normalizedCurrentRoute),
        );
      }
    }

    // Jika masih tidak ditemukan, default ke item pertama
    if (resolvedIndex == -1) {
      resolvedIndex = 0;
    }

    final activeRoute = items[resolvedIndex].routeName;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 16,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    isActive: items[i].routeName == activeRoute,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    highlightColor: highlightColor,
                    animationDuration: animationDuration,
                    animationCurve: animationCurve,
                    onTap: () => _handleTap(items[i], activeRoute),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BottomNavItem item, String activeRoute) {
    final target = item.routeName;
    final normalizedTarget = _normalizeRoute(target);
    final normalizedActiveRoute = _normalizeRoute(activeRoute);

    // Jangan navigasi jika sudah di route yang sama
    if (normalizedTarget == normalizedActiveRoute) {
      return;
    }

    if (onItemTapped != null) {
      onItemTapped!(target);
      return;
    }

    // Navigasi dengan mengganti route saat ini, bukan hapus semua stack
    Get.offNamed(target);
  }

  String _normalizeRoute(String? route) {
    if (route == null || route.isEmpty) return '';
    final trimmed = route.split('?').first.trim();
    if (trimmed.isEmpty || trimmed == '/') {
      return '';
    }
    return trimmed;
  }
}

class _NavButton extends StatelessWidget {
  final BottomNavItem item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final Color highlightColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.highlightColor,
    required this.animationDuration,
    required this.animationCurve,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = isActive && item.activeIcon != null ? item.activeIcon! : item.icon;
    final badgeCount = item.badgeCount;
    final tooltipLabel = item.tooltip ?? item.label;

    return Tooltip(
      message: tooltipLabel,
      waitDuration: const Duration(milliseconds: 350),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? highlightColor : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: animationDuration,
                      curve: animationCurve,
                      height: isActive ? 30 : 26,
                      width: isActive ? 30 : 26,
                      alignment: Alignment.center,
                      child: Icon(
                        iconData,
                        color: isActive ? activeColor : inactiveColor,
                        size: isActive ? 26 : 24,
                      ),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: _Badge(
                          count: badgeCount,
                          color: activeColor,
                        ),
                      ),
                  ],
                ),
                AnimatedDefaultTextStyle(
                  duration: animationDuration,
                  curve: animationCurve,
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? activeColor : inactiveColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(item.label),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final Color color;

  const _Badge({
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final display = count > 9 ? '9+' : '$count';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.18),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        display,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}