import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/price_summary_widget.dart';

class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final resource = booking.draftResource!;
    final fmt = DateFormat('EEE, d MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Summary')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: AppColors.categoryAccent(resource.categoryId).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(resource.imageEmojis.first, style: const TextStyle(fontSize: 26)),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resource.name, style: Theme.of(context).textTheme.titleSmall),
                          Text(resource.location, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Rental Period', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(
                '${fmt.format(booking.draftStart!)}  →  ${fmt.format(booking.draftEnd!)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              PriceSummaryWidget(
                rentalAmount: booking.draftRentalAmount,
                deposit: resource.securityDeposit,
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadii.field),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.info, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your request needs owner/admin approval before payment. You will be notified once reviewed.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: SafeArea(
          top: false,
          child: AppButton(
            label: 'Submit Rental Request',
            isLoading: _submitting,
            onPressed: () async {
              setState(() => _submitting = true);
              await Future.delayed(const Duration(milliseconds: 900));
              if (!mounted) return;
              final auth = context.read<AuthProvider>();
              final created = context.read<BookingProvider>().submitDraftBooking(
                    auth.currentUser?.id ?? 'u1',
                    auth.currentUser?.name ?? 'Guest User',
                  );
              if (!mounted) return;
              context.push('/payment', extra: created.id);
            },
          ),
        ),
      ),
    );
  }
}
