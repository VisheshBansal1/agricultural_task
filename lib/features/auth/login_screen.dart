import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _role = 'user';
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
            child: AuroraBackground(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md, AppSpacing.xl, AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassContainer(
                        borderRadius: 16,
                        padding: const EdgeInsets.all(10),
                        child: const Text('🌱', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Welcome Back', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Log in to rent or list agricultural resources.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('I am a', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(child: _roleChip('user', 'Renter', Icons.person)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: _roleChip('owner', 'Owner', Icons.agriculture)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(
                    label: 'Phone Number',
                    hint: '+91 98765 43210',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Send OTP',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.push('/otp', extra: _role),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                          onPressed: () => context.push('/register'),
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push('/admin/login'),
                      child: Text('Admin Login',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.underline)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String value, String label, IconData icon) {
    final selected = _role == value;
    return GestureDetector(
      onTap: () => setState(() => _role = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.heroSubtle : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(AppRadii.button),
          border: Border.all(color: selected ? Colors.transparent : AppColors.cardBorder),
          boxShadow: selected ? AppShadows.glow(AppColors.primary, opacity: 0.25) : AppShadows.subtle,
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : AppColors.mutedGray),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : AppColors.textDark,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
