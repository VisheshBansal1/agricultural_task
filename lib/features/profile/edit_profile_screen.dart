import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _location;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _name = TextEditingController(text: user?.name);
    _phone = TextEditingController(text: user?.phone);
    _email = TextEditingController(text: user?.email);
    _location = TextEditingController(text: user?.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(radius: 44, backgroundColor: AppColors.primary, child: Icon(Icons.person, color: Colors.white, size: 44)),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(radius: 15, backgroundColor: AppColors.accent, child: const Icon(Icons.camera_alt, size: 15, color: AppColors.textDark)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(label: 'Full Name', controller: _name, prefixIcon: Icons.person_outline),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Phone Number', controller: _phone, keyboardType: TextInputType.phone, prefixIcon: Icons.phone_outlined),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Email', controller: _email, keyboardType: TextInputType.emailAddress, prefixIcon: Icons.mail_outline),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Location', controller: _location, prefixIcon: Icons.location_on_outlined),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Save Changes',
                onPressed: () {
                  context.read<AuthProvider>().updateProfile(
                        name: _name.text,
                        phone: _phone.text,
                        email: _email.text,
                        location: _location.text,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile updated successfully')),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
