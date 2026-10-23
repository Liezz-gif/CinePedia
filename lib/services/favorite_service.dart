import 'package:flutter/material.dart';

class FavoriteService {
  static final FavoriteService instance = FavoriteService._internal();
  FavoriteService._internal();

  final ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier<Set<String>>({});

  bool isFavorite(String movieId) {
    return favoritesNotifier.value.contains(movieId);
  }

  void toggleFavorite(String movieId) {
    final current = Set<String>.from(favoritesNotifier.value);
    if (current.contains(movieId)) {
      current.remove(movieId);
    } else {
      current.add(movieId);
    }
    favoritesNotifier.value = current;
  }
}
