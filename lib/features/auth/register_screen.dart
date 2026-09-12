import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/aurora_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
            child: AuroraBackground(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Join KrishiRent', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text('Rent equipment or list your own — takes less than a minute.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8))),
                  ],
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
                  AppTextField(label: 'Full Name', hint: 'e.g. Vishesh Sharma', controller: _nameController, prefixIcon: Icons.person_outline),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Phone Number', hint: '+91 98765 43210', controller: _phoneController, keyboardType: TextInputType.phone, prefixIcon: Icons.phone_outlined),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Email (optional)', hint: 'you@example.com', controller: _emailController, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.mail_outline),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.push('/otp', extra: 'user'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(onPressed: () => context.pop(), child: const Text('Login')),
                      ],
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
}
