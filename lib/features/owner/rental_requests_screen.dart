import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/staggered_fade_in.dart';

class RentalRequestsScreen extends StatelessWidget {
  const RentalRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final ownerId = auth.currentUser?.id ?? 'o1';
    final requests = bookingProvider.forOwner(ownerId);

    return Scaffold(
      appBar: AppBar(title: const Text('Rental Requests')),
      body: SafeArea(
        child: requests.isEmpty
            ? const EmptyState(
                icon: Icons.inbox_outlined,
                title: 'No requests yet',
                message: 'Rental requests for your resources will appear here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: requests.length,
                itemBuilder: (context, i) {
                  final b = requests[i];
                  return StaggeredFadeIn(
                    index: i,
                    child: BookingCard(
                    booking: b,
                    onTap: () => context.push('/owner/requests/${b.id}'),
                    trailingActions: b.status == BookingStatus.pending
                        ? Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: 'Reject',
                                  variant: AppButtonVariant.secondary,
                                  onPressed: () => context.read<BookingProvider>().updateStatus(
                                        b.id,
                                        BookingStatus.rejected,
                                        reason: 'Not available for selected dates',
                                      ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: AppButton(
                                  label: 'Approve',
                                  onPressed: () => context.read<BookingProvider>().updateStatus(b.id, BookingStatus.approved),
                                ),
                              ),
                            ],
                          )
                        : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
