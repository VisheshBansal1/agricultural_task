import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const StatusBadge({super.key, required this.status});

  Color get _color {
    switch (status) {
      case BookingStatus.confirmed:
      case BookingStatus.approved:
      case BookingStatus.completed:
      case BookingStatus.active:
        return AppColors.success;
      case BookingStatus.pending:
      case BookingStatus.paymentPending:
        return AppColors.warning;
      case BookingStatus.rejected:
      case BookingStatus.cancelled:
      case BookingStatus.expired:
        return AppColors.error;
    }
  }

  IconData get _icon {
    switch (status) {
      case BookingStatus.confirmed:
        return Icons.verified_rounded;
      case BookingStatus.approved:
        return Icons.thumb_up_alt_rounded;
      case BookingStatus.completed:
        return Icons.check_circle_rounded;
      case BookingStatus.active:
        return Icons.bolt_rounded;
      case BookingStatus.pending:
        return Icons.hourglass_top_rounded;
      case BookingStatus.paymentPending:
        return Icons.payments_rounded;
      case BookingStatus.rejected:
        return Icons.cancel_rounded;
      case BookingStatus.cancelled:
        return Icons.block_rounded;
      case BookingStatus.expired:
        return Icons.timer_off_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(color: color, fontSize: 11.5, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
