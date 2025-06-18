import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/character.dart';

typedef CharacterResponse = (List<Character> characters, bool hasMorePages);

class CharactersRepository {
  const CharactersRepository();

  Future<CharacterResponse> getCharacters(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('characters_page_$page');

    if (cachedData != null) {
      final hasMorePages = prefs.getBool('has_more_pages_$page') ?? true;
      final List<dynamic> decodedData =
          json.decode(cachedData) as List<dynamic>;
      final characters = decodedData
          .map((json) => Character.fromJson(json as Map<String, dynamic>))
          .toList();
      return (characters, hasMorePages);
    }

    final Dio dio = Dio();
    final response = await dio.get('https://rickandmortyapi.com/api/character',
        queryParameters: {'page': page});
    final List<dynamic> results = response.data['results'] as List<dynamic>;
    final List<Character> characters = results
        .map((json) => Character.fromJson(json as Map<String, dynamic>))
        .toList();
    final bool hasMorePages = response.data['info']['next'] != null;
    await prefs.setString('characters_page_$page', json.encode(results));
    await prefs.setBool('has_more_pages_$page', hasMorePages);
    return (characters, hasMorePages);
  }
}
