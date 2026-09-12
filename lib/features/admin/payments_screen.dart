import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingProvider>().bookings
        .where((b) => b.status != BookingStatus.pending && b.status != BookingStatus.rejected)
        .toList();
    final fmt = DateFormat('d MMM yyyy');

    return AdminScaffold(
      title: 'Payments & Transactions',
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: bookings.length,
        itemBuilder: (context, i) {
          final b = bookings[i];
          final isPaid = b.status == BookingStatus.confirmed || b.status == BookingStatus.active || b.status == BookingStatus.completed;
          return StaggeredFadeIn(
            index: i,
            child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isPaid ? AppColors.success : AppColors.warning).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(isPaid ? Icons.check_circle_outline : Icons.hourglass_bottom, color: isPaid ? AppColors.success : AppColors.warning, size: 20),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.resourceName, style: Theme.of(context).textTheme.titleSmall),
                      Text('${b.userName} · ${fmt.format(b.requestDate)}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${b.totalAmount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleSmall),
                    Text(isPaid ? 'Paid' : 'Pending', style: TextStyle(color: isPaid ? AppColors.success : AppColors.warning, fontSize: 11)),
                  ],
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}
