import 'package:flutter/material.dart';

import '../../../core/domain/character.dart';
import '../domain/characters_repository.dart';

class CharactersNotifier with ChangeNotifier {
  final CharactersRepository charactersRepository;
  final ScrollController scrollController;

  CharactersNotifier({
    required this.charactersRepository,
    required this.scrollController,
  });

  // characters
  final List<Character> characters = [];
  bool isLoading = false;

  int currentPage = 1;
  bool hasMorePages = true;
  String? error;

  Future<void> loadCharacters() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      characters.addAll(await charactersRepository.getCharacters(currentPage));
      currentPage++;
      hasMorePages = characters.isNotEmpty;
      notifyListeners();
    } catch (e) {
      print(e);
      error = 'Failed to load characters: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void initListeners() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMorePages) {
        loadCharacters();
      }
    }
  }

  Future<void> refreshCharacters() async {
    currentPage = 1;
    hasMorePages = true;
    notifyListeners();
    await loadCharacters();
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }
}
