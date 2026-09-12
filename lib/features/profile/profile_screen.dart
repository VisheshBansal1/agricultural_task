import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/confirmation_dialog.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    final body = ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.navClearance),
      children: [
        if (embedded) ...[
          Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.lg),
        ],
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.card),
            boxShadow: AppShadows.subtle,
          ),
          child: Row(
            children: [
              const CircleAvatar(radius: 30, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white, size: 30)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? 'Guest', style: Theme.of(context).textTheme.titleMedium),
                    Text(user?.phone ?? '', style: Theme.of(context).textTheme.bodySmall),
                    Text(user?.location ?? '', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push('/edit-profile'),
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _tile(context, Icons.calendar_today_outlined, 'My Bookings', () => context.push('/my-bookings')),
        _tile(context, Icons.favorite_border, 'Favorites', () => context.push('/favorites')),
        _tile(context, Icons.agriculture_outlined, 'Switch to Owner Dashboard', () => context.push('/owner/dashboard')),
        _tile(context, Icons.help_outline, 'Help & Support', () {}),
        _tile(context, Icons.description_outlined, 'Terms & Conditions', () {}),
        _tile(context, Icons.admin_panel_settings_outlined, 'Admin Login', () => context.push('/admin/login')),
        const SizedBox(height: AppSpacing.lg),
        _tile(context, Icons.logout, 'Log Out', () async {
          final confirm = await showConfirmationDialog(
            context,
            title: 'Log out?',
            message: 'You will need to verify your phone number again to log back in.',
            confirmLabel: 'Log Out',
            isDestructive: true,
          );
          if (confirm && context.mounted) {
            context.read<AuthProvider>().logout();
            context.go('/login');
          }
        }, color: AppColors.error),
      ],
    );

    if (embedded) return body;
    return Scaffold(appBar: AppBar(title: const Text('Profile')), body: SafeArea(child: body));
  }

  Widget _tile(BuildContext context, IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.field),
        boxShadow: AppShadows.subtle,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.field)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: (color ?? AppColors.primary).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
        title: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.mutedGray),
        onTap: onTap,
      ),
    );
  }
}
