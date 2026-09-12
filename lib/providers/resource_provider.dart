import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../mock_data/mock_resources.dart';
import '../models/resource.dart';

class ResourceProvider extends ChangeNotifier {
  final List<ResourceItem> _resources = List.of(mockResources);

  String searchQuery = '';
  String? selectedCategoryId;
  String selectedDistance = '25 km';
  RangeValues priceRange = const RangeValues(0, 40000);
  String sortBy = 'Nearest';

  List<ResourceItem> get all => List.unmodifiable(_resources);

  List<ResourceItem> get listedOnly =>
      _resources.where((r) => r.status == ResourceStatus.listed).toList();

  List<ResourceItem> forOwner(String ownerId) =>
      _resources.where((r) => r.ownerId == ownerId).toList();

  List<ResourceItem> get pendingApproval =>
      _resources.where((r) => r.status == ResourceStatus.pendingApproval).toList();

  List<ResourceItem> get featured =>
      (listedOnly.toList()..sort((a, b) => b.rating.compareTo(a.rating))).take(6).toList();

  List<ResourceItem> get nearby =>
      (listedOnly.toList()..sort((a, b) => a.distanceKm.compareTo(b.distanceKm))).take(6).toList();

  List<ResourceItem> search({String? query, String? categoryId}) {
    var results = listedOnly.where((r) {
      final q = (query ?? searchQuery).toLowerCase();
      final matchesQuery = q.isEmpty ||
          r.name.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.categoryId.toLowerCase().contains(q);
      final cat = categoryId ?? selectedCategoryId;
      final matchesCategory = cat == null || cat == 'more' || r.categoryId == cat;
      final matchesPrice = r.price >= priceRange.start && r.price <= priceRange.end;
      return matchesQuery && matchesCategory && matchesPrice;
    }).toList();

    switch (sortBy) {
      case 'Price: low to high':
        results.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: high to low':
        results.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Highest rated':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
        results = results.reversed.toList();
        break;
      case 'Nearest':
      default:
        results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return results;
  }

  void setQuery(String q) {
    searchQuery = q;
    notifyListeners();
  }

  void setCategory(String? id) {
    selectedCategoryId = id;
    notifyListeners();
  }

  void setSort(String s) {
    sortBy = s;
    notifyListeners();
  }

  void setPriceRange(RangeValues r) {
    priceRange = r;
    notifyListeners();
  }

  void setDistance(String d) {
    selectedDistance = d;
    notifyListeners();
  }

  void addResource(ResourceItem resource) {
    _resources.insert(0, resource);
    notifyListeners();
  }

  void updateResourceStatus(String id, ResourceStatus status) {
    final index = _resources.indexWhere((r) => r.id == id);
    if (index == -1) return;
    final r = _resources[index];
    _resources[index] = ResourceItem(
      id: r.id,
      ownerId: r.ownerId,
      ownerName: r.ownerName,
      categoryId: r.categoryId,
      name: r.name,
      description: r.description,
      imageEmojis: r.imageEmojis,
      location: r.location,
      distanceKm: r.distanceKm,
      price: r.price,
      pricingType: r.pricingType,
      rating: r.rating,
      reviewCount: r.reviewCount,
      status: status,
      specs: r.specs,
      securityDeposit: r.securityDeposit,
      availableDateRange: r.availableDateRange,
      isAvailableNow: r.isAvailableNow,
    );
    notifyListeners();
  }
}
