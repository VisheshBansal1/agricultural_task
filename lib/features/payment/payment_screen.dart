import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/app_button.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  const PaymentScreen({super.key, required this.bookingId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = kPaymentMethods.first;
  bool _processing = false;
  bool _failedOnce = false;

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    if (!_failedOnce) {
      setState(() {
        _processing = false;
        _failedOnce = true;
      });
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Failed'),
          content: const Text('Your bank did not approve this transaction. Please try again.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
      return;
    }

    context.read<BookingProvider>().updateStatus(widget.bookingId, BookingStatus.confirmed);
    if (!mounted) return;
    setState(() => _processing = false);
    context.go('/booking-success', extra: widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>().byId(widget.bookingId);

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount Payable', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text('₹${booking?.totalAmount.toStringAsFixed(0) ?? '0'}',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.xl),
              Text('Select Payment Method', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              ...kPaymentMethods.map((m) => _methodTile(m)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppRadii.field),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, color: AppColors.warning, size: 18),
                    SizedBox(width: 8),
                    Expanded(child: Text('This is a demo payment — no real transaction will occur.')),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: 'Pay Now',
                isLoading: _processing,
                icon: Icons.lock,
                onPressed: _pay,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodTile(String method) {
    final selected = _method == method;
    final icons = {'UPI': Icons.qr_code, 'Card': Icons.credit_card, 'Wallet': Icons.account_balance_wallet};
    return GestureDetector(
      onTap: () => setState(() => _method = method),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.field),
          border: Border.all(color: selected ? AppColors.primary : AppColors.cardBorder, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icons[method], color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(method, style: Theme.of(context).textTheme.bodyLarge)),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.mutedGray),
          ],
        ),
      ),
    );
  }
}
