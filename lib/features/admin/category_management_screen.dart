import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_categories.dart';
import '../../widgets/app_button.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final Set<String> _disabled = {};

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Category Management',
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: mockCategories.length,
        itemBuilder: (context, i) {
          final c = mockCategories[i];
          final disabled = _disabled.contains(c.id);
          final accent = AppColors.categoryAccent(c.id);
          return StaggeredFadeIn(
            index: i,
            child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Icon(Icons.category_rounded, color: accent, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: Theme.of(context).textTheme.titleSmall),
                      Text(c.description, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Switch(
                  value: !disabled,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() {
                    if (v) {
                      _disabled.remove(c.id);
                    } else {
                      _disabled.add(c.id);
                    }
                  }),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.card)),
        title: const Text('Add Category'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Category name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          AppButton(
            label: 'Add',
            width: 100,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${controller.text}" added')));
            },
          ),
        ],
      ),
    );
  }
}
