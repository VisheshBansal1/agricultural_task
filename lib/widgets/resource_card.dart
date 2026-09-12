import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../models/resource.dart';
import '../providers/favorites_provider.dart';

class ResourceCard extends StatefulWidget {
  final ResourceItem resource;
  final VoidCallback onTap;
  final double width;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
    this.width = 178,
  });

  @override
  State<ResourceCard> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(widget.resource.id);
    final accent = AppColors.categoryAccent(widget.resource.categoryId);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.card),
            boxShadow: AppShadows.card,
            border: Border.all(color: AppColors.cardBorder.withOpacity(0.6)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 108,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [accent.withOpacity(0.16), accent.withOpacity(0.32)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(widget.resource.imageEmojis.first, style: const TextStyle(fontSize: 42)),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _pill(
                      color: widget.resource.isAvailableNow ? AppColors.success : AppColors.mutedGray,
                      child: Text(
                        widget.resource.isAvailableNow ? 'Available' : 'Booked',
                        style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => context.read<FavoritesProvider>().toggle(widget.resource.id),
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.subtle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 15,
                          color: isFav ? AppColors.error : AppColors.mutedGray,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: -12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.textDark,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        boxShadow: AppShadows.subtle,
                      ),
                      child: Text(
                        widget.resource.priceLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.sm, 18, AppSpacing.sm, AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.resource.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: AppColors.accent),
                        const SizedBox(width: 2),
                        Text('${widget.resource.rating}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        Text(' (${widget.resource.reviewCount})', style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        Icon(Icons.place_rounded, size: 13, color: accent),
                        const SizedBox(width: 1),
                        Text('${widget.resource.distanceKm}km', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill({required Color color, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadii.pill)),
      child: child,
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryId;
  final String name;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryId,
    required this.name,
    required this.emoji,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.categoryAccent(categoryId);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(colors: [accent, accent.withOpacity(0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null,
              color: selected ? null : accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(18),
              boxShadow: selected ? AppShadows.glow(accent, opacity: 0.28) : null,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 66,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: selected ? AppColors.textDark : AppColors.mutedGray,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
