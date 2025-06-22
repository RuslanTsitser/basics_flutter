import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/domain/character.dart';
import '../domain/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  @override
  Future<List<Character>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final Dio dio = Dio();
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

    return characters;
  }

  @override
  Future<void> toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(characterId)) {
      favorites.removeWhere((e) => e == characterId);
    } else {
      favorites.add(characterId);
    }
    await prefs.setStringList('favorites', favorites);
  }
}
