import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/price_summary_widget.dart';
import '../../widgets/status_badge.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().byId(bookingId);
    final fmt = DateFormat('EEE, d MMM yyyy');

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(child: Text('Booking not found')),
      );
    }

    final canCancel = booking.status == BookingStatus.pending ||
        booking.status == BookingStatus.approved ||
        booking.status == BookingStatus.confirmed;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(booking.resourceName, style: Theme.of(context).textTheme.titleLarge)),
                  StatusBadge(status: booking.status),
                ],
              ),
              const SizedBox(height: 6),
              Text(booking.location, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              _infoRow(context, 'Rental Period', '${fmt.format(booking.startDate)}  →  ${fmt.format(booking.endDate)}'),
              _infoRow(context, 'Duration', '${booking.durationDays} day(s)'),
              _infoRow(context, 'Requested On', fmt.format(booking.requestDate)),
              if (booking.rejectionReason != null)
                _infoRow(context, 'Reason', booking.rejectionReason!),
              const SizedBox(height: AppSpacing.lg),
              PriceSummaryWidget(rentalAmount: booking.rentalAmount, deposit: booking.deposit),
              const SizedBox(height: AppSpacing.xl),
              if (booking.status == BookingStatus.paymentPending)
                AppButton(
                  label: 'Complete Payment',
                  onPressed: () => context.push('/payment', extra: booking.id),
                ),
              if (canCancel) ...[
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Cancel Booking',
                  variant: AppButtonVariant.secondary,
                  onPressed: () async {
                    final confirm = await showConfirmationDialog(
                      context,
                      title: 'Cancel this booking?',
                      message: 'This will cancel the rental request per the cancellation policy.',
                      confirmLabel: 'Yes, Cancel',
                      isDestructive: true,
                    );
                    if (confirm && context.mounted) {
                      context.read<BookingProvider>().updateStatus(booking.id, BookingStatus.cancelled);
                    }
                  },
                ),
              ],
              if (booking.status == BookingStatus.completed) ...[
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Give Review & Rating',
                  variant: AppButtonVariant.accent,
                  icon: Icons.star_outline,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thanks! Your review has been submitted.')),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
