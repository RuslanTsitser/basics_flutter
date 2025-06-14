import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character.dart';

class FavoritesRepository {
  const FavoritesRepository();

  Future<List<Character>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final List<Character> characters = [];

    final Dio dio = Dio();
    for (final id in favorites) {
      final response = await dio.get('https://rickandmortyapi.com/api/character/$id');
      characters.add(Character.fromJson(response.data as Map<String, dynamic>));
    }
    return characters;
  }

  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(id);
    await prefs.setStringList('favorites', favorites);
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(id);
    await prefs.setStringList('favorites', favorites);
  }
}
