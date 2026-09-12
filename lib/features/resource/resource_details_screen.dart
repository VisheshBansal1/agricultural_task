import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_resources.dart';
import '../../providers/booking_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/app_button.dart';

class ResourceDetailsScreen extends StatelessWidget {
  final String resourceId;
  const ResourceDetailsScreen({super.key, required this.resourceId});

  @override
  Widget build(BuildContext context) {
    final resource = findResourceById(resourceId);
    final favorites = context.watch<FavoritesProvider>();

    if (resource == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resource')),
        body: const Center(child: Text('Resource not found')),
      );
    }

    final isFav = favorites.isFavorite(resource.id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: const BackButton(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () => context.read<FavoritesProvider>().toggle(resource.id),
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined, color: Colors.white)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppGradients.hero),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle),
                      ),
                    ),
                    Text(resource.imageEmojis.first, style: const TextStyle(fontSize: 100)),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(resource.name, style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      Text(resource.priceLabel,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: AppColors.accent),
                      Text(' ${resource.rating} (${resource.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 10),
                      const Icon(Icons.location_on, size: 16, color: AppColors.mutedGray),
                      Expanded(
                        child: Text(' ${resource.location} · ${resource.distanceKm} km',
                            style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadii.field),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.event_available, color: AppColors.info, size: 18),
                        const SizedBox(width: 8),
                        Text('Available: ${resource.availableDateRange.join(' – ')}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Description', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text(resource.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Specifications', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: resource.specs.entries
                        .map((e) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppRadii.chip),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Text('${e.key}: ${e.value}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Owner', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadii.card),
                      boxShadow: AppShadows.subtle,
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.secondary,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(resource.ownerName, style: Theme.of(context).textTheme.titleSmall),
                              Text('Resource owner', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.mutedGray),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadii.field),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.warning, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Refundable security deposit of ₹${resource.securityDeposit.toStringAsFixed(0)} applies to this rental.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: AppButton(
            label: 'Select Dates & Request Rental',
            icon: Icons.calendar_month,
            onPressed: () {
              context.read<BookingProvider>().startDraft(resource);
              context.push('/select-dates');
            },
          ),
        ),
      ),
    );
  }
}
