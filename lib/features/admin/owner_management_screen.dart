import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class OwnerManagementScreen extends StatelessWidget {
  const OwnerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.watch<ResourceProvider>();
    final owners = <String, List<String>>{};
    for (final r in resources.all) {
      owners.putIfAbsent(r.ownerName, () => []).add(r.name);
    }
    final ownerNames = owners.keys.toList();

    return AdminScaffold(
      title: 'Owner / Provider Management',
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: ownerNames.length,
        itemBuilder: (context, i) {
          final name = ownerNames[i];
          final listings = owners[name]!;
          return StaggeredFadeIn(
            index: i,
            child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.15), child: Icon(Icons.agriculture, color: AppColors.primary)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: Theme.of(context).textTheme.titleSmall),
                      Text('${listings.length} listing(s)', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View')),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}
