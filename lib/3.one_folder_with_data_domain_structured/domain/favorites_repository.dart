import 'character.dart';

abstract class FavoritesRepository {
  Future<List<Character>> getFavorites();
  Future<void> addFavorite(String id);
  Future<void> removeFavorite(String id);
}
