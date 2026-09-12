import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_resources.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/resource_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final favResources = mockResources.where((r) => favorites.isFavorite(r.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: SafeArea(
        child: favResources.isEmpty
            ? EmptyState(
                icon: Icons.favorite_border,
                title: 'No favorites yet',
                message: 'Tap the heart icon on any resource to save it here.',
                ctaLabel: 'Browse Resources',
                onCta: () => context.push('/search'),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72),
                itemCount: favResources.length,
                itemBuilder: (context, i) {
                  final r = favResources[i];
                  return ResourceCard(resource: r, width: double.infinity, onTap: () => context.push('/resource/${r.id}'));
                },
              ),
      ),
    );
  }
}
