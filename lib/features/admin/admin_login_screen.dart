import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _idController = TextEditingController(text: 'admin@krishirent.in');
  final _passController = TextEditingController(text: '••••••••');
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        alignment: Alignment.center,
                        child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text('KrishiRent Admin', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextField(label: 'Admin Email', controller: _idController, prefixIcon: Icons.mail_outline),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(label: 'Password', controller: _passController, obscureText: true, prefixIcon: Icons.lock_outline),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: 'Login to Admin Panel',
                    isLoading: _loading,
                    onPressed: () async {
                      setState(() => _loading = true);
                      await Future.delayed(const Duration(milliseconds: 700));
                      if (!mounted) return;
                      context.read<AuthProvider>().loginAsAdmin();
                      context.go('/admin/dashboard');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
