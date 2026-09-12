import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';

class OtpScreen extends StatefulWidget {
  final String role;
  const OtpScreen({super.key, required this.role});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());
  bool _loading = false;

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _verify() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (widget.role == 'owner') {
      auth.loginAsOwner();
      context.go('/owner/dashboard');
    } else {
      auth.loginAsUser();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  gradient: AppGradients.heroSubtle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.glow(AppColors.primary, opacity: 0.25),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.sms_rounded, size: 28, color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Enter the 4-digit code', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text('We sent a verification code to your phone. Enter any 4 digits to continue this demo.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (i) {
                  final filled = _controllers[i].text.isNotEmpty;
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadii.field),
                      border: Border.all(color: filled ? AppColors.primary : AppColors.cardBorder, width: filled ? 1.6 : 1),
                      boxShadow: AppShadows.subtle,
                    ),
                    child: TextField(
                      controller: _controllers[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                      decoration: const InputDecoration(counterText: '', border: InputBorder.none, filled: false),
                      onChanged: (value) {
                        if (value.isNotEmpty && i < 3) {
                          _nodes[i + 1].requestFocus();
                        }
                        setState(() {});
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Verify & Continue',
                isLoading: _loading,
                onPressed: _code.length == 4 ? _verify : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(onPressed: () {}, child: const Text("Didn't receive code? Resend")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
