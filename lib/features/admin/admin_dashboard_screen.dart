import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/admin_stat_card.dart';
import '../../widgets/aurora_background.dart';
import 'admin_scaffold.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final resources = context.watch<ResourceProvider>();
    final bookings = context.watch<BookingProvider>();

    final pendingResources = resources.pendingApproval;
    final pendingBookings = bookings.pendingForAdmin;
    final totalRevenue = bookings.bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.confirmed || b.status == BookingStatus.active)
        .fold<double>(0, (sum, b) => sum + b.rentalAmount);

    return AdminScaffold(
      title: 'Admin Dashboard',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.cardLg),
            child: AuroraBackground(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Morning, 👋', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          Text(auth.currentUser?.name ?? 'Admin', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Manage. Support. Grow Agriculture Together.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                    const Text('🌾', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              AdminStatCard(label: 'Total Users', value: '2,548', icon: Icons.people_outline, color: AppColors.primary, delta: '+12% vs last month'),
              AdminStatCard(label: 'Resource Owners', value: '842', icon: Icons.badge_outlined, color: AppColors.info, delta: '+8% vs last month'),
              AdminStatCard(label: 'Total Listings', value: '${resources.all.length}', icon: Icons.inventory_2_outlined, color: AppColors.secondary, delta: '+15% vs last month'),
              AdminStatCard(label: 'Total Bookings', value: '${bookings.bookings.length}', icon: Icons.calendar_month_outlined, color: AppColors.accent, delta: '+30% vs last month'),
              AdminStatCard(label: 'Total Revenue', value: '₹${totalRevenue.toStringAsFixed(0)}', icon: Icons.currency_rupee, color: AppColors.success, delta: '+18% vs last month'),
              AdminStatCard(label: 'Pending Approvals', value: '${pendingResources.length + pendingBookings.length}', icon: Icons.hourglass_bottom, color: AppColors.warning),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: AppShadows.subtle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bookings Overview — Last 30 Days', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 160,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: AppColors.success,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          spots: const [
                            FlSpot(0, 40), FlSpot(1, 55), FlSpot(2, 48), FlSpot(3, 70),
                            FlSpot(4, 65), FlSpot(5, 90), FlSpot(6, 110),
                          ],
                        ),
                        LineChartBarData(
                          isCurved: true,
                          color: AppColors.warning,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                          spots: const [
                            FlSpot(0, 20), FlSpot(1, 25), FlSpot(2, 18), FlSpot(3, 30),
                            FlSpot(4, 22), FlSpot(5, 28), FlSpot(6, 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _legendDot(AppColors.success, 'Confirmed'),
                    const SizedBox(width: AppSpacing.lg),
                    _legendDot(AppColors.warning, 'Pending'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: AppShadows.subtle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Resource Categories', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 160,
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                            sections: [
                              PieChartSectionData(value: 28, color: AppColors.primary, title: '', radius: 45),
                              PieChartSectionData(value: 14, color: AppColors.info, title: '', radius: 45),
                              PieChartSectionData(value: 12, color: AppColors.accent, title: '', radius: 45),
                              PieChartSectionData(value: 10, color: AppColors.secondary, title: '', radius: 45),
                              PieChartSectionData(value: 8, color: AppColors.warning, title: '', radius: 45),
                              PieChartSectionData(value: 28, color: AppColors.mutedGray, title: '', radius: 45),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendDot(AppColors.primary, 'Tractors 28%'),
                            _legendDot(AppColors.info, 'Trucks 14%'),
                            _legendDot(AppColors.accent, 'Harvesters 12%'),
                            _legendDot(AppColors.secondary, 'Irrigation 10%'),
                            _legendDot(AppColors.warning, 'Land 8%'),
                            _legendDot(AppColors.mutedGray, 'Other 28%'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Listings (Pending Approval)', style: Theme.of(context).textTheme.titleMedium),
              TextButton(onPressed: () => context.go('/admin/resources'), child: const Text('View All')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (pendingResources.isEmpty)
            Text('No pending resource approvals.', style: Theme.of(context).textTheme.bodyMedium)
          else
            ...pendingResources.map((r) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name, style: Theme.of(context).textTheme.titleSmall),
                            Text('${r.ownerName} · ${r.location}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.rejected),
                        child: const Text('Reject', style: TextStyle(color: AppColors.error)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14)),
                        onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.listed),
                        child: const Text('Approve'),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 10, width: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedGray)),
      ],
    );
  }
}
