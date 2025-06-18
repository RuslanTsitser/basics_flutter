import 'package:flutter/material.dart';

import '../domain/character.dart';
import '../domain/characters_repository.dart';
import '../domain/favorites_repository.dart';

class CharactersNotifier with ChangeNotifier {
  final CharactersRepository charactersRepository;
  final FavoritesRepository favoritesRepository;

  CharactersNotifier(
      {required this.charactersRepository, required this.favoritesRepository});

  final List<Character> characters = [];
  final List<Character> favoriteCharacters = [];
  bool isLoading = false;
  String? error;
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool hasMorePages = true;
  Set<String> favorites = {};
  int selectedIndex = 0;

  Future<void> loadCharacters() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await charactersRepository.getCharacters(currentPage);
      characters.addAll(result.$1);
      hasMorePages = result.$2;
      currentPage++;
      notifyListeners();
    } catch (e) {
      print(e);
      error = 'Failed to load characters: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    final result = await favoritesRepository.getFavorites();
    favorites = result.map((character) => character.id.toString()).toSet();
    favoriteCharacters.clear();
    favoriteCharacters.addAll(result);
    notifyListeners();
  }

  void initListeners() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMorePages && selectedIndex == 0) {
        loadCharacters();
      }
    }
  }

  void disposeControllers() {
    scrollController.dispose();
  }

  Future<void> toggleFavorite(String characterId) async {
    if (favorites.contains(characterId)) {
      await favoritesRepository.removeFavorite(characterId);
      favorites.remove(characterId);
    } else {
      await favoritesRepository.addFavorite(characterId);
      favorites.add(characterId);
    }
    notifyListeners();
    await loadFavorites();
  }

  Future<void> refreshCharacters() async {
    currentPage = 1;
    hasMorePages = true;
    notifyListeners();
    await loadCharacters();
  }

  void onIndexSelected(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
