import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String resourceId) => _favoriteIds.contains(resourceId);

  void toggle(String resourceId) {
    if (_favoriteIds.contains(resourceId)) {
      _favoriteIds.remove(resourceId);
    } else {
      _favoriteIds.add(resourceId);
    }
    notifyListeners();
  }

  List<String> get favoriteIds => _favoriteIds.toList();
}
