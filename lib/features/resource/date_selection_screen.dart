import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_date_range_picker.dart';
import '../../widgets/price_summary_widget.dart';

class DateSelectionScreen extends StatelessWidget {
  const DateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final resource = booking.draftResource;

    if (resource == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Dates')),
        body: const Center(child: Text('No resource selected')),
      );
    }

    final hasDates = booking.draftStart != null && booking.draftEnd != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Rental Dates')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  boxShadow: AppShadows.subtle,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: AppColors.categoryAccent(resource.categoryId).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(resource.imageEmojis.first, style: const TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resource.name, style: Theme.of(context).textTheme.titleSmall),
                          Text('${resource.priceLabel}  ·  ${resource.location}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('Rental Period', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              AppDateRangePicker(
                start: booking.draftStart,
                end: booking.draftEnd,
                onChanged: (range) {
                  context.read<BookingProvider>().setDraftDates(range.start, range.end);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              if (hasDates) ...[
                Text('${booking.draftDuration.toInt()} day(s) selected',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                PriceSummaryWidget(
                  rentalAmount: booking.draftRentalAmount,
                  deposit: resource.securityDeposit,
                ),
              ] else
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(AppRadii.field),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.info),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Pick a start and end date to see the estimated price.'),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              AppButton(
                label: 'Continue to Summary',
                onPressed: hasDates ? () => context.push('/booking-summary') : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
