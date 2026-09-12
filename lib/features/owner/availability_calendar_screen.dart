import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_resources.dart';
import '../../widgets/app_button.dart';

class AvailabilityCalendarScreen extends StatefulWidget {
  final String resourceId;
  const AvailabilityCalendarScreen({super.key, required this.resourceId});

  @override
  State<AvailabilityCalendarScreen> createState() => _AvailabilityCalendarScreenState();
}

class _AvailabilityCalendarScreenState extends State<AvailabilityCalendarScreen> {
  final Set<int> _blockedDays = {5, 6, 19, 20};
  DateTime _month = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final resource = findResourceById(widget.resourceId);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday % 7;

    return Scaffold(
      appBar: AppBar(title: Text(resource?.name ?? 'Availability')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tap a date to block or unblock it for renters.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('${_monthName(_month.month)} ${_month.year}', style: Theme.of(context).textTheme.titleSmall),
                  IconButton(
                    onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
                itemCount: daysInMonth + firstWeekday,
                itemBuilder: (context, i) {
                  if (i < firstWeekday) return const SizedBox.shrink();
                  final day = i - firstWeekday + 1;
                  final blocked = _blockedDays.contains(day);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (blocked) {
                        _blockedDays.remove(day);
                      } else {
                        _blockedDays.add(day);
                      }
                    }),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: blocked ? AppColors.error.withOpacity(0.12) : AppColors.success.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: blocked ? AppColors.error.withOpacity(0.4) : AppColors.success.withOpacity(0.3)),
                      ),
                      alignment: Alignment.center,
                      child: Text('$day', style: TextStyle(color: blocked ? AppColors.error : AppColors.success, fontWeight: FontWeight.w600)),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  _legend(AppColors.success, 'Available'),
                  const SizedBox(width: AppSpacing.lg),
                  _legend(AppColors.error, 'Blocked'),
                ],
              ),
              const Spacer(),
              AppButton(
                label: 'Save Availability',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Availability updated')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(height: 12, width: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  String _monthName(int m) {
    const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return names[m - 1];
  }
}
