import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: BookingStatus.values.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return AdminScaffold(
      title: 'Booking Management',
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.mutedGray,
            indicatorColor: AppColors.primary,
            tabs: BookingStatus.values.map((s) => Tab(text: s.label)).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: BookingStatus.values.map((status) {
                final items = bookingProvider.byStatus(status);
                if (items.isEmpty) {
                  return EmptyState(icon: Icons.calendar_today_outlined, title: 'No ${status.label} bookings', message: 'Nothing here right now.');
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final b = items[i];
                    return StaggeredFadeIn(
                      index: i,
                      child: BookingCard(
                      booking: b,
                      onTap: () => context.push('/booking/${b.id}'),
                      trailingActions: status == BookingStatus.pending
                          ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => context.read<BookingProvider>().updateStatus(b.id, BookingStatus.rejected, reason: 'Rejected by admin'),
                                    child: const Text('Reject'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => context.read<BookingProvider>().updateStatus(b.id, BookingStatus.approved),
                                    child: const Text('Approve'),
                                  ),
                                ),
                              ],
                            )
                          : null,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
