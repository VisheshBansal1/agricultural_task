import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme.dart';

class AppDateRangePicker extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  final ValueChanged<DateTimeRange> onChanged;

  const AppDateRangePicker({super.key, required this.start, required this.end, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM yyyy');
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final range = await showDateRangePicker(
          context: context,
          firstDate: now,
          lastDate: now.add(const Duration(days: 365)),
          initialDateRange: start != null && end != null ? DateTimeRange(start: start!, end: end!) : null,
          builder: (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primary),
            ),
            child: child!,
          ),
        );
        if (range != null) onChanged(range);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                start != null && end != null
                    ? '${fmt.format(start!)}  -  ${fmt.format(end!)}'
                    : 'Select rental dates',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedGray),
          ],
        ),
      ),
    );
  }
}
