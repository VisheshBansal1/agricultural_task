import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';
import '../models/booking.dart';
import 'status_badge.dart';

class BookingCard extends StatelessWidget {
  final BookingItem booking;
  final VoidCallback onTap;
  final Widget? trailingActions;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
    this.trailingActions,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.card),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.agriculture, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.resourceName,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(booking.userName, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                StatusBadge(status: booking.status),
              ],
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${fmt.format(booking.startDate)} - ${fmt.format(booking.endDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text('₹${booking.totalAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            if (trailingActions != null) ...[
              const SizedBox(height: AppSpacing.sm),
              trailingActions!,
            ],
          ],
        ),
      ),
    );
  }
}
