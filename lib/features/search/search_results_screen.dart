import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_categories.dart';
import '../../models/resource.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/resource_card.dart';
import '../../widgets/staggered_fade_in.dart';

class SearchResultsScreen extends StatefulWidget {
  final String? categoryId;
  final bool embedded;
  const SearchResultsScreen({super.key, this.categoryId, this.embedded = false});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool _loading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      Future.microtask(() => context.read<ResourceProvider>().setCategory(widget.categoryId));
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.card))),
      builder: (context) {
        final provider = context.read<ResourceProvider>();
        final options = [
          'Price: low to high',
          'Price: high to low',
          'Nearest',
          'Highest rated',
          'Newest',
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((o) => ListTile(
                      title: Text(o),
                      trailing: provider.sortBy == o ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        provider.setSort(o);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResourceProvider>();
    final results = provider.search();

    final body = _buildBody(provider, results);

    if (widget.embedded) return body;

    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: SafeArea(child: body),
    );
  }

  Widget _buildBody(ResourceProvider provider, List<ResourceItem> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.field),
              boxShadow: AppShadows.subtle,
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: AppColors.mutedGray),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search resources...',
                      border: InputBorder.none,
                    ),
                    onChanged: provider.setQuery,
                  ),
                ),
                IconButton(onPressed: _showSortSheet, icon: const Icon(Icons.sort, color: AppColors.primary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 42,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            children: [
              _filterChip('All', provider.selectedCategoryId == null, () => provider.setCategory(null)),
              const SizedBox(width: 8),
              ...mockCategories.where((c) => c.id != 'more').map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _filterChip(c.name, provider.selectedCategoryId == c.id,
                          () => provider.setCategory(c.id)),
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text('${results.length} resources found', style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: _loading
              ? GridView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72),
                  itemCount: 6,
                  itemBuilder: (_, __) => const ResourceCardSkeleton(),
                )
              : results.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off,
                      title: 'No resources found',
                      message: 'Try a different category, or widen your price range and distance filters.',
                      ctaLabel: 'Clear Filters',
                      onCta: () {
                        provider.setCategory(null);
                        provider.setQuery('');
                        _searchController.clear();
                      },
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.navClearance),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72),
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final r = results[i];
                        return StaggeredFadeIn(
                          index: i,
                          child: ResourceCard(
                            resource: r,
                            width: double.infinity,
                            onTap: () => context.push('/resource/${r.id}'),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
