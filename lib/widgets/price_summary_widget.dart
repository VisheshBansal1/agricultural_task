import 'package:flutter/material.dart';
import '../core/theme.dart';

class PriceSummaryWidget extends StatelessWidget {
  final double rentalAmount;
  final double deposit;
  final double deliveryFee;
  const PriceSummaryWidget({
    super.key,
    required this.rentalAmount,
    required this.deposit,
    this.deliveryFee = 0,
  });

  @override
  Widget build(BuildContext context) {
    final total = rentalAmount + deposit + deliveryFee;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Summary', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.md),
          _row(context, 'Rental amount', rentalAmount),
          _row(context, 'Security deposit (refundable)', deposit),
          if (deliveryFee > 0) _row(context, 'Delivery charges', deliveryFee),
          const Divider(height: AppSpacing.xl),
          _row(context, 'Total payable', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, String label, double amount, {bool isTotal = false}) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleSmall
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('₹${amount.toStringAsFixed(0)}',
              style: style?.copyWith(color: isTotal ? AppColors.primary : null)),
        ],
      ),
    );
  }
}
