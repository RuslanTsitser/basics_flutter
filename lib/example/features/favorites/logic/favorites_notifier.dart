import 'package:flutter/material.dart';

import '../../../core/domain/character.dart';
import '../domain/favorites_repository.dart';

class FavoritesNotifier with ChangeNotifier {
  final FavoritesRepository repository;

  FavoritesNotifier({
    required this.repository,
  });

  // favorites
  final List<Character> favoriteCharacters = [];

  List<String> get favorites =>
      favoriteCharacters.map((e) => e.id.toString()).toList();

  Future<void> loadFavorites() async {
    favoriteCharacters.clear();
    favoriteCharacters.addAll(await repository.loadFavorites());
    notifyListeners();
  }

  Future<void> toggleFavorite(String characterId) async {
    await repository.toggleFavorite(characterId);
    await loadFavorites();
  }
}
