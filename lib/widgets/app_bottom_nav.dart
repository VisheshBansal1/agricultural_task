import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class _NavItem {
  final IconData outline;
  final IconData filled;
  final String label;
  const _NavItem(this.outline, this.filled, this.label);
}

const _items = [
  _NavItem(Icons.home_outlined, Icons.home_rounded, 'Home'),
  _NavItem(Icons.search_outlined, Icons.search_rounded, 'Explore'),
  _NavItem(Icons.calendar_today_outlined, Icons.calendar_month_rounded, 'Bookings'),
  _NavItem(Icons.notifications_outlined, Icons.notifications_rounded, 'Alerts'),
  _NavItem(Icons.person_outline, Icons.person_rounded, 'Profile'),
];

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.pill),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(AppRadii.pill),
                border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
                boxShadow: [
                  BoxShadow(color: AppColors.textDark.withOpacity(0.12), blurRadius: 28, offset: const Offset(0, 12)),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / _items.length;
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                        left: itemWidth * currentIndex + 6,
                        top: 8,
                        bottom: 8,
                        width: itemWidth - 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppGradients.heroSubtle,
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            boxShadow: AppShadows.glow(AppColors.primary, opacity: 0.4),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(_items.length, (i) {
                          final selected = i == currentIndex;
                          final item = _items[i];
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => onTap(i),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: selected ? Colors.white : AppColors.mutedGray,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(selected ? item.filled : item.outline,
                                        color: selected ? Colors.white : AppColors.mutedGray, size: 21),
                                    const SizedBox(height: 3),
                                    Text(item.label),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
