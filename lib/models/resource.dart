import '../core/constants.dart';

class ResourceItem {
  final String id;
  final String ownerId;
  final String ownerName;
  final String categoryId;
  final String name;
  final String description;
  final List<String> imageEmojis; // stand-ins for bundled illustration assets
  final String location;
  final double distanceKm;
  final double price;
  final PricingType pricingType;
  final double rating;
  final int reviewCount;
  final ResourceStatus status;
  final Map<String, String> specs;
  final double securityDeposit;
  final List<String> availableDateRange; // e.g. ["15 Sept", "30 Sept"]
  final bool isAvailableNow;

  const ResourceItem({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageEmojis,
    required this.location,
    required this.distanceKm,
    required this.price,
    required this.pricingType,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.specs,
    required this.securityDeposit,
    required this.availableDateRange,
    this.isAvailableNow = true,
  });

  String get priceLabel => '₹${price.toStringAsFixed(0)}${pricingType.label}';
}
