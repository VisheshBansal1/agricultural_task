import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_resources.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/confirmation_dialog.dart';

class EditResourceScreen extends StatefulWidget {
  final String resourceId;
  const EditResourceScreen({super.key, required this.resourceId});

  @override
  State<EditResourceScreen> createState() => _EditResourceScreenState();
}

class _EditResourceScreenState extends State<EditResourceScreen> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _desc;

  @override
  void initState() {
    super.initState();
    final r = findResourceById(widget.resourceId);
    _name = TextEditingController(text: r?.name);
    _price = TextEditingController(text: r?.price.toStringAsFixed(0));
    _desc = TextEditingController(text: r?.description);
  }

  @override
  Widget build(BuildContext context) {
    final resource = findResourceById(widget.resourceId);
    if (resource == null) {
      return Scaffold(appBar: AppBar(title: const Text('Edit Resource')), body: const Center(child: Text('Resource not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Resource')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(label: 'Resource Title', controller: _name),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Base Price (₹)', controller: _price, keyboardType: TextInputType.number, prefixIcon: Icons.currency_rupee),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(label: 'Description', controller: _desc, maxLines: 5),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Save Changes',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved (resubmitted for approval if needed)')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Disable Resource',
                variant: AppButtonVariant.secondary,
                onPressed: () async {
                  final confirm = await showConfirmationDialog(
                    context,
                    title: 'Disable this resource?',
                    message: 'It will be hidden from search. Existing confirmed bookings are not affected.',
                    confirmLabel: 'Disable',
                    isDestructive: true,
                  );
                  if (confirm && context.mounted) {
                    context.read<ResourceProvider>().updateResourceStatus(resource.id, ResourceStatus.disabled);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resource disabled')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
