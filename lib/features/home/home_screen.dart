import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../mock_data/mock_categories.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resource_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/resource_card.dart';
import '../../widgets/staggered_fade_in.dart';
import '../booking/my_bookings_screen.dart';
import '../profile/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_results_screen.dart';

const Map<String, String> _categoryEmojis = {
  'tractor': '🚜',
  'truck': '🚚',
  'harvester': '🌾',
  'equipment': '⚙️',
  'irrigation': '💧',
  'land': '🌱',
  'tools': '🔧',
  'more': '⋯',
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final _tabs = const [
    _HomeTab(),
    SearchResultsScreen(categoryId: null, embedded: true),
    MyBookingsScreen(embedded: true),
    NotificationsScreen(embedded: true),
    ProfileScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(bottom: false, child: _tabs[_navIndex]),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.watch<ResourceProvider>();
    final auth = context.watch<AuthProvider>();
    final firstName = (auth.currentUser?.name ?? 'Farmer').split(' ').first;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
            child: AuroraBackground(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl + 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(11)),
                          alignment: Alignment.center,
                          child: const Text('🌱', style: TextStyle(fontSize: 17)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_greeting(), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
                              Text(firstName, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              onPressed: () => context.push('/notifications'),
                              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle, border: Border.all(color: AppColors.primaryDark, width: 1.5)),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.push('/profile'),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(Icons.person, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      'Rent Smarter.\nGrow Faster.',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, height: 1.1),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tractors, land, harvesters & more — near Karnal, Haryana',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GestureDetector(
                      onTap: () => context.push('/search'),
                      child: GlassContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                        borderRadius: AppRadii.field,
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('Search tractors, equipment, land...',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.85))),
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(8)),
                              child: const Icon(Icons.tune, color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadii.button),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.groups_rounded, color: AppColors.primary, size: 20),
                                SizedBox(height: 2),
                                Text('Rent', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => context.push('/owner/add-resource'),
                            child: GlassContainer(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              borderRadius: AppRadii.button,
                              child: const Column(
                                children: [
                                  Icon(Icons.local_shipping_outlined, color: Colors.white, size: 20),
                                  SizedBox(height: 2),
                                  Text('List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
            child: Row(
              children: [
                Expanded(child: _statCard(context, '2,500+', 'Farmers', Icons.groups_rounded, AppColors.categoryAccent('tractor'))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _statCard(context, '1,300+', 'Resources', Icons.inventory_2_rounded, AppColors.categoryAccent('equipment'))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _statCard(context, '12+', 'Districts', Icons.map_rounded, AppColors.categoryAccent('irrigation'))),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 88,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: mockCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, i) {
                final cat = mockCategories[i];
                return CategoryCard(
                  categoryId: cat.id,
                  name: cat.name,
                  emoji: _categoryEmojis[cat.id] ?? '🌾',
                  onTap: () => context.push('/search', extra: cat.id),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppGradients.gold,
                borderRadius: BorderRadius.circular(AppRadii.cardLg),
                boxShadow: AppShadows.glow(AppColors.accent, opacity: 0.25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quality Resources\nfor a Better Tomorrow',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textDark)),
                        const SizedBox(height: 6),
                        Text('Rent agricultural equipment near you and get the job done with ease.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textDark.withOpacity(0.75))),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => context.push('/search'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(color: AppColors.textDark, borderRadius: BorderRadius.circular(AppRadii.pill)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Explore Now', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                                const SizedBox(width: 4),
                                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('🚜', style: TextStyle(fontSize: 52)),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Featured Rentals', style: Theme.of(context).textTheme.titleMedium),
                GestureDetector(
                  onTap: () => context.push('/search'),
                  child: Row(
                    children: [
                      Text('See All', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 236,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              itemCount: resources.featured.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, i) {
                final r = resources.featured[i];
                return StaggeredFadeIn(
                  index: i,
                  child: ResourceCard(resource: r, onTap: () => context.push('/resource/${r.id}')),
                );
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0),
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Nearby Resources', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text('Within 10 km', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 110),
          sliver: SliverList.builder(
            itemCount: resources.nearby.length,
            itemBuilder: (context, i) {
              final r = resources.nearby[i];
              final accent = AppColors.categoryAccent(r.categoryId);
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: StaggeredFadeIn(
                  index: i,
                  child: GestureDetector(
                    onTap: () => context.push('/resource/${r.id}'),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadii.card),
                        boxShadow: AppShadows.subtle,
                        border: Border.all(color: AppColors.cardBorder.withOpacity(0.5)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(color: accent.withOpacity(0.14), borderRadius: BorderRadius.circular(14)),
                            alignment: Alignment.center,
                            child: Text(r.imageEmojis.first, style: const TextStyle(fontSize: 28)),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
                                    const SizedBox(width: 2),
                                    Text('${r.rating}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
                                    Text('  ·  ${r.distanceKm} km', style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.place_outlined, size: 12, color: accent),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(r.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).textTheme.bodySmall),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(r.priceLabel,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                decoration: BoxDecoration(gradient: AppGradients.heroSubtle, borderRadius: BorderRadius.circular(AppRadii.pill)),
                                child: const Text('View', style: TextStyle(fontSize: 11.5, color: Colors.white, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context, String value, String label, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadii.card),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(9)),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: accent),
          ),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
