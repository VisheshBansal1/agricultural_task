import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/staggered_fade_in.dart';
import '../../widgets/status_badge.dart';

class MyResourcesScreen extends StatelessWidget {
  const MyResourcesScreen({super.key});

  Color _statusColor(ResourceStatus s) {
    switch (s) {
      case ResourceStatus.listed:
        return AppColors.success;
      case ResourceStatus.pendingApproval:
        return AppColors.warning;
      case ResourceStatus.rejected:
        return AppColors.error;
      case ResourceStatus.disabled:
        return AppColors.mutedGray;
    }
  }

  String _statusLabel(ResourceStatus s) {
    switch (s) {
      case ResourceStatus.listed:
        return 'Listed';
      case ResourceStatus.pendingApproval:
        return 'Pending Approval';
      case ResourceStatus.rejected:
        return 'Rejected';
      case ResourceStatus.disabled:
        return 'Disabled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final resources = context.watch<ResourceProvider>();
    final ownerId = auth.currentUser?.id ?? 'o1';
    final mine = resources.forOwner(ownerId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resources'),
        actions: [IconButton(onPressed: () => context.push('/owner/add-resource'), icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
        child: mine.isEmpty
            ? EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No resources listed yet',
                message: 'Add your first resource to start earning from idle equipment or land.',
                ctaLabel: 'Add Resource',
                onCta: () => context.push('/owner/add-resource'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: mine.length,
                itemBuilder: (context, i) {
                  final r = mine[i];
                  final color = _statusColor(r.status);
                  return StaggeredFadeIn(
                    index: i,
                    child: Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      boxShadow: AppShadows.subtle,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Text(r.imageEmojis.first, style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name, style: Theme.of(context).textTheme.titleSmall),
                              Text(r.priceLabel, style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                                child: Text(_statusLabel(r.status), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'edit') context.push('/owner/edit-resource/${r.id}');
                            if (v == 'availability') context.push('/owner/availability/${r.id}');
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'availability', child: Text('Availability')),
                          ],
                        ),
                      ],
                    ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
