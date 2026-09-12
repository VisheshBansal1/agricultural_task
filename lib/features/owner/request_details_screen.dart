import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/price_summary_widget.dart';
import '../../widgets/status_badge.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String bookingId;
  const RequestDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().byId(bookingId);
    final fmt = DateFormat('EEE, d MMM yyyy');

    if (booking == null) {
      return Scaffold(appBar: AppBar(title: const Text('Request')), body: const Center(child: Text('Not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
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
              const SizedBox(height: AppSpacing.md),
              _row(context, 'Requester', booking.userName),
              _row(context, 'Rental Period', '${fmt.format(booking.startDate)} → ${fmt.format(booking.endDate)}'),
              _row(context, 'Duration', '${booking.durationDays} day(s)'),
              _row(context, 'Location', booking.location),
              _row(context, 'Requested On', fmt.format(booking.requestDate)),
              const SizedBox(height: AppSpacing.lg),
              PriceSummaryWidget(rentalAmount: booking.rentalAmount, deposit: booking.deposit),
              const SizedBox(height: AppSpacing.xl),
              if (booking.status == BookingStatus.pending)
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Reject',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => context.read<BookingProvider>().updateStatus(
                              booking.id,
                              BookingStatus.rejected,
                              reason: 'Resource unavailable for selected dates',
                            ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Approve',
                        onPressed: () => context.read<BookingProvider>().updateStatus(booking.id, BookingStatus.approved),
                      ),
                    ),
                  ],
                ),
              if (booking.status == BookingStatus.approved || booking.status == BookingStatus.confirmed)
                AppButton(
                  label: 'Mark Resource Handed Over',
                  onPressed: () => context.read<BookingProvider>().updateStatus(booking.id, BookingStatus.active),
                ),
              if (booking.status == BookingStatus.active)
                AppButton(
                  label: 'Mark Rental Completed',
                  onPressed: () => context.read<BookingProvider>().updateStatus(booking.id, BookingStatus.completed),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
