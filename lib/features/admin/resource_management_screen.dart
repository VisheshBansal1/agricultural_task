import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/staggered_fade_in.dart';
import 'admin_scaffold.dart';

class ResourceManagementScreen extends StatefulWidget {
  const ResourceManagementScreen({super.key});

  @override
  State<ResourceManagementScreen> createState() => _ResourceManagementScreenState();
}

class _ResourceManagementScreenState extends State<ResourceManagementScreen> {
  ResourceStatus? _filter;

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

  @override
  Widget build(BuildContext context) {
    final resources = context.watch<ResourceProvider>();
    final filtered = _filter == null ? resources.all : resources.all.where((r) => r.status == _filter).toList();

    return AdminScaffold(
      title: 'Resource Management',
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(label: const Text('All'), selected: _filter == null, onSelected: (_) => setState(() => _filter = null)),
                const SizedBox(width: 8),
                ...ResourceStatus.values.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s.name),
                        selected: _filter == s,
                        onSelected: (_) => setState(() => _filter = s),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final r = filtered[i];
                final color = _statusColor(r.status);
                return StaggeredFadeIn(
                  index: i,
                  child: Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadii.field), boxShadow: AppShadows.subtle),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name, style: Theme.of(context).textTheme.titleSmall),
                                Text('${r.ownerName} · ${r.location}', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                            child: Text(r.status.name, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          if (r.status == ResourceStatus.pendingApproval) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.rejected),
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.listed),
                                child: const Text('Approve'),
                              ),
                            ),
                          ] else if (r.status == ResourceStatus.listed) ...[
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.disabled),
                                child: const Text('Disable'),
                              ),
                            ),
                          ] else if (r.status == ResourceStatus.disabled)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.read<ResourceProvider>().updateResourceStatus(r.id, ResourceStatus.listed),
                                child: const Text('Re-enable'),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
