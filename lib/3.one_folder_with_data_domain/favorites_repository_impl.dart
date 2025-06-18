import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl();

  @override
  Future<List<Character>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    final List<Character> characters = [];

    final Dio dio = Dio();
    for (final id in favorites) {
      final response =
          await dio.get('https://rickandmortyapi.com/api/character/$id');
      characters.add(Character.fromJson(response.data as Map<String, dynamic>));
    }
    return characters;
  }

  @override
  Future<void> addFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(id);
    await prefs.setStringList('favorites', favorites);
  }

  @override
  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(id);
    await prefs.setStringList('favorites', favorites);
  }
}
