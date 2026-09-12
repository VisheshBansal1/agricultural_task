import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/staggered_fade_in.dart';

class _NotificationItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  const _NotificationItem(this.icon, this.color, this.title, this.subtitle, this.time);
}

const _notifications = [
  _NotificationItem(Icons.check_circle, AppColors.success, 'Booking Approved',
      'Your request for FieldKing Harvester was approved.', '2h ago'),
  _NotificationItem(Icons.payments_outlined, AppColors.info, 'Payment Successful',
      'Payment of ₹6,600 confirmed for PowerTrac 575 DI.', '1d ago'),
  _NotificationItem(Icons.schedule, AppColors.warning, 'Rental Starting Soon',
      'Your rental of AgroMax 5310 starts tomorrow.', '1d ago'),
  _NotificationItem(Icons.cancel_outlined, AppColors.error, 'Booking Rejected',
      'GreenLine Cultivator request was rejected — resource under maintenance.', '3d ago'),
  _NotificationItem(Icons.local_offer_outlined, AppColors.accent, 'Festival Offer',
      'Get 10% off on tractor rentals this week.', '5d ago'),
];

class NotificationsScreen extends StatelessWidget {
  final bool embedded;
  const NotificationsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final body = _notifications.isEmpty
        ? const EmptyState(
            icon: Icons.notifications_none,
            title: 'No notifications yet',
            message: "We'll let you know about booking updates here.",
          )
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.navClearance),
            itemCount: _notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) {
              final n = _notifications[i];
              return StaggeredFadeIn(
                index: i,
                child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  boxShadow: AppShadows.subtle,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: n.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: Icon(n.icon, color: n.color, size: 20),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(n.title, style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 2),
                          Text(n.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text(n.time, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          );

    if (embedded) {
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.md),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Notifications', style: Theme.of(context).textTheme.headlineMedium),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(appBar: AppBar(title: const Text('Notifications')), body: SafeArea(child: body));
  }
}
