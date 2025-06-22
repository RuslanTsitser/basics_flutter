import '../../../core/domain/character.dart';

abstract class FavoritesRepository {
  Future<List<Character>> loadFavorites();
  Future<void> toggleFavorite(String characterId);
}
