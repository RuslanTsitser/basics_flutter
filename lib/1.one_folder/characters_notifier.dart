import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character.dart';

class CharactersNotifier with ChangeNotifier {
  final Dio dio = Dio();
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
      if (currentPage == 1) {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('characters_page_$currentPage');
        if (cachedData != null) {
          final List<dynamic> decodedData =
              json.decode(cachedData) as List<dynamic>;
          characters.clear();
          characters.addAll(decodedData
              .map((json) => Character.fromJson(json as Map<String, dynamic>)));
          notifyListeners();
        }
      }

      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': currentPage},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] as List<dynamic>;
        final List<Map<String, dynamic>> newCharacters =
            results.map((json) => json as Map<String, dynamic>).toList();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'characters_page_$currentPage',
          json.encode(results),
        );

        if (currentPage == 1) {
          characters.clear();
        }
        characters
            .addAll(newCharacters.map((json) => Character.fromJson(json)));
        currentPage++;
        hasMorePages = response.data['info']['next'] != null;
        notifyListeners();
      }
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
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    this.favorites = favorites.toSet();
    notifyListeners();
    await _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteCharacters() async {
    final List<Character> characters = [];

    for (final id in favorites) {
      try {
        final response =
            await dio.get('https://rickandmortyapi.com/api/character/$id');
        if (response.statusCode == 200) {
          characters
              .add(Character.fromJson(response.data as Map<String, dynamic>));
        }
      } catch (e) {
        print(e);
      }
    }

    favoriteCharacters.clear();
    favoriteCharacters.addAll(characters);
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
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (this.favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList('favorites', favorites);
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
