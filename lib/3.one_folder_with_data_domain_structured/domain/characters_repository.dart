import 'character.dart';

typedef CharacterResponse = (List<Character> characters, bool hasMorePages);

abstract class CharactersRepository {
  Future<CharacterResponse> getCharacters(int page);
}
