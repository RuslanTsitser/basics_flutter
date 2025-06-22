import '../../../core/domain/character.dart';

abstract class CharactersRepository {
  Future<List<Character>> getCharacters(int currentPage);
}
