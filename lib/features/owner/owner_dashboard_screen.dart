import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/staggered_fade_in.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final ownerId = auth.currentUser?.id ?? 'o1';
    final resources = context.watch<ResourceProvider>();
    final bookings = context.watch<BookingProvider>();

    final myResources = resources.forOwner(ownerId);
    final myBookings = bookings.forOwner(ownerId);
    final pendingRequests = myBookings.where((b) => b.status == BookingStatus.pending).toList();
    final earnings = myBookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.active || b.status == BookingStatus.confirmed)
        .fold<double>(0, (sum, b) => sum + b.rentalAmount);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                child: AuroraBackground(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (context.canPop())
                              IconButton(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                              ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => context.go('/home'),
                              icon: const Icon(Icons.storefront_outlined, color: Colors.white, size: 18),
                              label: const Text('Switch to Renter', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Welcome back,', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                                  Text(auth.currentUser?.name ?? 'Owner',
                                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                                  const SizedBox(height: 6),
                                  Text('Turn idle assets into steady income',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
                                ],
                              ),
                            ),
                            const Text('🚜', style: TextStyle(fontSize: 46)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.55,
                  children: [
                    _statTile(context, '₹${earnings.toStringAsFixed(0)}', 'Total Earnings', Icons.currency_rupee, AppColors.success),
                    _statTile(context, '${myResources.length}', 'My Resources', Icons.inventory_2_outlined, AppColors.categoryAccent('equipment')),
                    _statTile(context, '${pendingRequests.length}', 'Pending Requests', Icons.hourglass_bottom, AppColors.warning),
                    _statTile(context, '${myBookings.length}', 'Total Bookings', Icons.calendar_month_outlined, AppColors.categoryAccent('irrigation')),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppButton(label: 'Add New Resource', icon: Icons.add, onPressed: () => context.push('/owner/add-resource')),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'My Resources',
                            variant: AppButtonVariant.secondary,
                            onPressed: () => context.push('/owner/resources'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppButton(
                            label: 'Requests',
                            variant: AppButtonVariant.secondary,
                            onPressed: () => context.push('/owner/requests'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Requests', style: Theme.of(context).textTheme.titleMedium),
                    TextButton(onPressed: () => context.push('/owner/requests'), child: const Text('View All')),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xxl),
              sliver: myBookings.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                        child: Text('No booking requests yet.', style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    )
                  : SliverList.builder(
                      itemCount: myBookings.take(5).length,
                      itemBuilder: (context, i) {
                        final b = myBookings[i];
                        return StaggeredFadeIn(
                          index: i,
                          child: BookingCard(booking: b, onTap: () => context.push('/owner/requests/${b.id}')),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile(BuildContext context, String value, String label, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
