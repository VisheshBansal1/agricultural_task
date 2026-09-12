import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_categories.dart';
import '../../models/resource.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});

  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}

class _AddResourceScreenState extends State<AddResourceScreen> {
  int _step = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController(text: 'Karnal, Haryana');
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  String _categoryId = mockCategories.first.id;
  PricingType _pricingType = PricingType.daily;
  int _photosAdded = 3;

  static const _stepTitles = ['Basic Info', 'Details', 'Pricing', 'Availability', 'Review'];

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() {
    final auth = context.read<AuthProvider>();
    final category = mockCategories.firstWhere((c) => c.id == _categoryId, orElse: () => mockCategories.first);
    final newResource = ResourceItem(
      id: 'r_new_${DateTime.now().millisecondsSinceEpoch}',
      ownerId: auth.currentUser?.id ?? 'o1',
      ownerName: auth.currentUser?.name ?? 'You',
      categoryId: _categoryId,
      name: _titleController.text.isEmpty ? 'New ${category.name.substring(0, category.name.length - 1)}' : _titleController.text,
      description: _descController.text.isEmpty ? 'Well-maintained resource, ready to rent.' : _descController.text,
      imageEmojis: const ['🚜'],
      location: _addressController.text,
      distanceKm: 1.0,
      price: double.tryParse(_priceController.text) ?? 1000,
      pricingType: _pricingType,
      rating: 0,
      reviewCount: 0,
      status: ResourceStatus.pendingApproval,
      specs: const {'Condition': 'Good'},
      securityDeposit: double.tryParse(_depositController.text) ?? 0,
      availableDateRange: const ['Available now'],
    );
    context.read<ResourceProvider>().addResource(newResource);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.card)),
        title: const Text('Submitted for Approval'),
        content: const Text('Your resource has been submitted. It will be visible to renters once an admin approves it.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/owner/resources');
            },
            child: const Text('Go to My Resources'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Your Resource')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Row(
                children: const [
                  _Perk(icon: Icons.currency_rupee, label: 'Earn Extra\nIncome'),
                  _Perk(icon: Icons.calendar_month, label: 'You Set\nAvailability'),
                  _Perk(icon: Icons.groups, label: 'Help Farmers\nGrow'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: List.generate(_stepTitles.length, (i) {
                  final active = i <= _step;
                  return Expanded(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: active ? AppColors.primary : AppColors.cardBorder,
                          child: Text('${i + 1}', style: TextStyle(color: active ? Colors.white : AppColors.mutedGray, fontSize: 12)),
                        ),
                        const SizedBox(height: 4),
                        Text(_stepTitles[i], style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildStep(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child: AppButton(
                        label: 'Back',
                        variant: AppButtonVariant.secondary,
                        onPressed: () => setState(() => _step--),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      label: _step == 4 ? 'Submit for Approval' : 'Save & Next',
                      icon: _step == 4 ? Icons.check : Icons.arrow_forward,
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Basic Information', style: Theme.of(context).textTheme.titleMedium),
            Text('Tell us what you want to list', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Resource Title', hint: 'e.g. AgroMax 5310', controller: _titleController),
            const SizedBox(height: AppSpacing.lg),
            Text('Category', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: mockCategories.where((c) => c.id != 'more').map((c) {
                final selected = _categoryId == c.id;
                return ChoiceChip(
                  label: Text(c.name),
                  selected: selected,
                  onSelected: (_) => setState(() => _categoryId = c.id),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Short Description',
              hint: 'Describe your resource, its condition, features, and any other details...',
              controller: _descController,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Add Photos', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _photosAdded = (_photosAdded + 1).clamp(0, 8).toInt()),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(AppRadii.field),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text('$_photosAdded photo(s) added — tap to add more'),
                  ],
                ),
              ),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location & Documents', style: Theme.of(context).textTheme.titleMedium),
            Text('Set where your resource is available', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Address', hint: 'e.g. Village, Area, City, State, Pincode', controller: _addressController, prefixIcon: Icons.location_on_outlined),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('Use Current Location'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Documents (Optional)', style: Theme.of(context).textTheme.titleSmall),
            Text('Add relevant documents to build trust (e.g. RC, Insurance, Ownership)', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['RC Document', 'Insurance', 'Ownership Proof', 'Other Document']
                  .map((d) => OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file, size: 16), label: Text(d)))
                  .toList(),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pricing', style: Theme.of(context).textTheme.titleMedium),
            Text('Set your rental rate and deposit', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Base Price (₹)', hint: 'e.g. 2500', controller: _priceController, keyboardType: TextInputType.number, prefixIcon: Icons.currency_rupee),
            const SizedBox(height: AppSpacing.lg),
            Text('Pricing Type', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PricingType.values.map((p) {
                final selected = _pricingType == p;
                return ChoiceChip(
                  label: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                  selected: selected,
                  onSelected: (_) => setState(() => _pricingType = p),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(label: 'Security Deposit (₹)', hint: 'e.g. 5000', controller: _depositController, keyboardType: TextInputType.number, prefixIcon: Icons.shield_outlined),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Availability', style: Theme.of(context).textTheme.titleMedium),
            Text('When is this resource available for rent?', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.card), boxShadow: AppShadows.subtle),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Icon(Icons.calendar_month, color: AppColors.primary), const SizedBox(width: 8), Text('Available immediately', style: Theme.of(context).textTheme.bodyMedium)]),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.block, color: AppColors.mutedGray), const SizedBox(width: 8), Text('No blocked dates set', style: Theme.of(context).textTheme.bodySmall)]),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('You can manage blocked dates any time from My Resources → Availability.',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        );
      case 4:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Review Your Listing', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.lg),
            _reviewRow('Title', _titleController.text.isEmpty ? '—' : _titleController.text),
            _reviewRow('Category', mockCategories.firstWhere((c) => c.id == _categoryId).name),
            _reviewRow('Address', _addressController.text),
            _reviewRow('Price', '₹${_priceController.text.isEmpty ? '0' : _priceController.text}${_pricingType.label}'),
            _reviewRow('Security Deposit', '₹${_depositController.text.isEmpty ? '0' : _depositController.text}'),
            _reviewRow('Photos', '$_photosAdded added'),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.info.withOpacity(0.08), borderRadius: BorderRadius.circular(AppRadii.field)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.info, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Your listing will be reviewed by an admin before it appears to renters.')),
                ],
              ),
            ),
          ],
        );
    }
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _Perk extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Perk({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.primary, child: Icon(icon, color: Colors.white, size: 16)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
