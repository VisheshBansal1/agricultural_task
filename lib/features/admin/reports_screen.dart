import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../providers/resource_provider.dart';
import 'admin_scaffold.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.watch<ResourceProvider>();
    final bookings = context.watch<BookingProvider>();

    final categoryCounts = <String, int>{};
    for (final r in resources.all) {
      categoryCounts[r.categoryId] = (categoryCounts[r.categoryId] ?? 0) + 1;
    }

    return AdminScaffold(
      title: 'Reports & Analytics',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: AppShadows.subtle),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Listings by Category', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 180,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final keys = categoryCounts.keys.toList();
                              if (value.toInt() >= keys.length) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(keys[value.toInt()], style: const TextStyle(fontSize: 10)),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: categoryCounts.entries
                          .toList()
                          .asMap()
                          .entries
                          .map((e) => BarChartGroupData(x: e.key, barRods: [
                                BarChartRodData(toY: double.parse(e.value.toString()), color: AppColors.primary, width: 18, borderRadius: BorderRadius.circular(4)),
                              ]))
                          .toList(),
                    ),
                  ),
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
                Text('Booking Status Breakdown', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSpacing.md),
                ...BookingStatus.values.map((s) {
                  final count = bookings.byStatus(s).length;
                  final total = bookings.bookings.length.clamp(1, 999999);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(width: 110, child: Text(s.label, style: Theme.of(context).textTheme.bodySmall)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: count / total,
                              minHeight: 8,
                              backgroundColor: AppColors.cardBorder,
                              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$count'),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
