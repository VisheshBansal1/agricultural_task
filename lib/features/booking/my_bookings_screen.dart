import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/booking_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/staggered_fade_in.dart';

class MyBookingsScreen extends StatefulWidget {
  final bool embedded;
  const MyBookingsScreen({super.key, this.embedded = false});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final userId = auth.currentUser?.id ?? 'u1';
    final all = bookingProvider.forUser(userId);

    final upcoming = all.where((b) => b.status.name == 'pending' || b.status.name == 'approved' || b.status.name == 'paymentPending').toList();
    final confirmed = all.where((b) => b.status.name == 'confirmed' || b.status.name == 'active').toList();
    final completed = all.where((b) => b.status.name == 'completed').toList();
    final other = all.where((b) => b.status.name == 'rejected' || b.status.name == 'cancelled' || b.status.name == 'expired').toList();

    final body = Column(
      children: [
        if (widget.embedded)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
            child: Text('My Bookings', style: Theme.of(context).textTheme.headlineMedium),
          ),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.mutedGray,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Confirmed/Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Other'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _list(context, upcoming, 'No upcoming bookings', 'Requests awaiting approval or payment will show here.'),
              _list(context, confirmed, 'Nothing confirmed yet', 'Confirmed and active rentals will show here.'),
              _list(context, completed, 'No completed rentals', 'Your rental history will appear here once completed.'),
              _list(context, other, 'Nothing here', 'Rejected, cancelled, or expired requests will show here.'),
            ],
          ),
        ),
      ],
    );

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: SafeArea(child: body),
    );
  }

  Widget _list(BuildContext context, List bookings, String emptyTitle, String emptyMessage) {
    if (bookings.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_outlined,
        title: emptyTitle,
        message: emptyMessage,
        ctaLabel: 'Browse Resources',
        onCta: () => context.push('/search'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.navClearance),
      itemCount: bookings.length,
      itemBuilder: (context, i) {
        final b = bookings[i];
        return StaggeredFadeIn(
          index: i,
          child: BookingCard(booking: b, onTap: () => context.push('/booking/${b.id}')),
        );
      },
    );
  }
}
