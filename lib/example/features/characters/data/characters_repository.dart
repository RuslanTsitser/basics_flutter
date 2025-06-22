import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/domain/character.dart';
import '../domain/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  @override
  Future<List<Character>> getCharacters(int currentPage) async {
    final prefs = await SharedPreferences.getInstance();
    List<Character> characters = [];

    final cachedData = prefs.getString('characters_page_$currentPage');
    if (cachedData != null) {
      final List<dynamic> decodedData =
          json.decode(cachedData) as List<dynamic>;
      characters.clear();
      characters.addAll(decodedData
          .map((json) => Character.fromJson(json as Map<String, dynamic>)));
      return characters;
    }

    final Dio dio = Dio();
    final response = await dio.get(
      'https://rickandmortyapi.com/api/character',
      queryParameters: {'page': currentPage},
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = response.data['results'] as List<dynamic>;
      final List<Map<String, dynamic>> newCharacters =
          results.map((json) => json as Map<String, dynamic>).toList();

      await prefs.setString(
        'characters_page_$currentPage',
        json.encode(results),
      );

      characters.addAll(newCharacters.map((json) => Character.fromJson(json)));
    }
    return characters;
  }
}
