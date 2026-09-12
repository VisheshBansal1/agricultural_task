import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';

class _AdminNavItem {
  final IconData icon;
  final String label;
  final String route;
  const _AdminNavItem(this.icon, this.label, this.route);
}

const _adminNavItems = [
  _AdminNavItem(Icons.dashboard_outlined, 'Dashboard', '/admin/dashboard'),
  _AdminNavItem(Icons.people_outline, 'Users', '/admin/users'),
  _AdminNavItem(Icons.badge_outlined, 'Owners / Providers', '/admin/owners'),
  _AdminNavItem(Icons.inventory_2_outlined, 'Resource Listings', '/admin/resources'),
  _AdminNavItem(Icons.category_outlined, 'Categories', '/admin/categories'),
  _AdminNavItem(Icons.calendar_month_outlined, 'Bookings', '/admin/bookings'),
  _AdminNavItem(Icons.payments_outlined, 'Payments', '/admin/payments'),
  _AdminNavItem(Icons.bar_chart_outlined, 'Reports & Analytics', '/admin/reports'),
  _AdminNavItem(Icons.campaign_outlined, 'Notifications & Content', '/admin/content'),
  _AdminNavItem(Icons.settings_outlined, 'Settings', '/admin/settings'),
];

class AdminScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: Drawer(
        backgroundColor: AppColors.primary,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      child: const Text('🌱', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 10),
                    Text('KrishiRent Admin', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView(
                  children: _adminNavItems.map((item) {
                    final selected = currentRoute == item.route;
                    return ListTile(
                      leading: Icon(item.icon, color: selected ? AppColors.accent : Colors.white70),
                      title: Text(item.label, style: TextStyle(color: selected ? Colors.white : Colors.white70)),
                      tileColor: selected ? Colors.white.withOpacity(0.08) : null,
                      onTap: () {
                        Navigator.pop(context);
                        if (!selected) context.go(item.route);
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text('Efficient administration today,\nstronger farms tomorrow.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white60)),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
    );
  }
}
