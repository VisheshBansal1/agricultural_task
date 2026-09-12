import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/app_button.dart';
import 'admin_scaffold.dart';

class NotificationsContentScreen extends StatelessWidget {
  const NotificationsContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Notifications & Content',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Send Announcement', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: AppShadows.subtle),
            child: Column(
              children: [
                const TextField(decoration: InputDecoration(hintText: 'Notification title')),
                const SizedBox(height: 10),
                const TextField(decoration: InputDecoration(hintText: 'Message'), maxLines: 3),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Send to All Users',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Announcement sent to all users')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Home Banners', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...['Quality Resources for a Better Tomorrow', 'Festival Offer — 10% off tractors'].map(
            (b) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
              child: Row(
                children: [
                  Expanded(child: Text(b, style: Theme.of(context).textTheme.bodyMedium)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('FAQs', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...['How do I list my tractor?', 'How is the security deposit refunded?'].map(
            (q) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: AppColors.info, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(q, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
