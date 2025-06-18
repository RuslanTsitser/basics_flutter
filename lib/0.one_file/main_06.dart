import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CharactersNotifier notifier = CharactersNotifier();

  @override
  void initState() {
    super.initState();
    notifier.loadCharacters();
    notifier.loadFavorites();
    notifier.initListeners();
  }

  @override
  void dispose() {
    notifier.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: notifier,
        builder: (context, child) {
          return Scaffold(
            appBar: CharactersAppBar(notifier: notifier),
            body: CharactersBody(notifier: notifier),
            bottomNavigationBar:
                CharactersBottomNavigationBar(notifier: notifier),
          );
        });
  }
}

class CharactersBottomNavigationBar extends StatelessWidget {
  const CharactersBottomNavigationBar({
    super.key,
    required this.notifier,
  });

  final CharactersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: notifier.selectedIndex,
      onTap: notifier.onIndexSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Персонажи',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Избранное',
        ),
      ],
    );
  }
}

class CharactersBody extends StatelessWidget {
  const CharactersBody({super.key, required this.notifier});

  final CharactersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return notifier.selectedIndex == 0
        ? CharactersList(notifier: notifier)
        : FavoritesList(notifier: notifier);
  }
}

class CharactersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CharactersAppBar({
    super.key,
    required this.notifier,
  });

  final CharactersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(notifier.selectedIndex == 0 ? 'Персонажи' : 'Избранное'),
      actions: [
        if (notifier.error != null && notifier.selectedIndex == 0)
          const Row(
            spacing: 4,
            children: [
              Text('Ошибка сети'),
              Icon(Icons.error),
            ],
          ),
        if (notifier.selectedIndex == 0)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: notifier.refreshCharacters,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Character {
  final int id;
  final String name;
  final String image;
  final String species;
  final String status;

  const Character({
    required this.id,
    required this.name,
    required this.image,
    required this.species,
    required this.status,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      species: json['species'] as String,
      status: json['status'] as String,
    );
  }
}

class CharactersNotifier with ChangeNotifier {
  final Dio dio = Dio();
  final List<Character> characters = [];
  final List<Character> favoriteCharacters = [];
  bool isLoading = false;
  String? error;
  final ScrollController scrollController = ScrollController();
  int currentPage = 1;
  bool hasMorePages = true;
  Set<String> favorites = {};
  int selectedIndex = 0;

  Future<void> loadCharacters() async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (currentPage == 1) {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('characters_page_$currentPage');
        if (cachedData != null) {
          final List<dynamic> decodedData =
              json.decode(cachedData) as List<dynamic>;
          characters.clear();
          characters.addAll(decodedData
              .map((json) => Character.fromJson(json as Map<String, dynamic>)));
          notifyListeners();
        }
      }

      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': currentPage},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] as List<dynamic>;
        final List<Map<String, dynamic>> newCharacters =
            results.map((json) => json as Map<String, dynamic>).toList();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'characters_page_$currentPage',
          json.encode(results),
        );

        if (currentPage == 1) {
          characters.clear();
        }
        characters
            .addAll(newCharacters.map((json) => Character.fromJson(json)));
        currentPage++;
        hasMorePages = response.data['info']['next'] != null;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      error = 'Failed to load characters: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    this.favorites = favorites.toSet();
    notifyListeners();
    await _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteCharacters() async {
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

    favoriteCharacters.clear();
    favoriteCharacters.addAll(characters);
    notifyListeners();
  }

  void initListeners() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMorePages && selectedIndex == 0) {
        loadCharacters();
      }
    }
  }

  void disposeControllers() {
    scrollController.dispose();
  }

  Future<void> toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (this.favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList('favorites', favorites);
    await loadFavorites();
  }

  Future<void> refreshCharacters() async {
    currentPage = 1;
    hasMorePages = true;
    notifyListeners();
    await loadCharacters();
  }

  void onIndexSelected(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class CharactersList extends StatelessWidget {
  const CharactersList({super.key, required this.notifier});

  final CharactersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: notifier.refreshCharacters,
      child: ListView.builder(
        controller: notifier.scrollController,
        itemCount: notifier.characters.length + (notifier.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifier.characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final character = notifier.characters[index];
          final isFavorite =
              notifier.favorites.contains(character.id.toString());

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              title: Text(character.name),
              subtitle: Text('${character.species} - ${character.status}'),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () =>
                    notifier.toggleFavorite(character.id.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key, required this.notifier});

  final CharactersNotifier notifier;

  @override
  Widget build(BuildContext context) {
    if (notifier.favoriteCharacters.isEmpty) {
      return const Center(child: Text('Нет избранных персонажей'));
    }

    return ListView.builder(
      itemCount: notifier.favoriteCharacters.length,
      itemBuilder: (context, index) {
        final character = notifier.favoriteCharacters[index];
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: character.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
            title: Text(character.name),
            subtitle: Text('${character.species} - ${character.status}'),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => notifier.toggleFavorite(character.id.toString()),
            ),
          ),
        );
      },
    );
  }
}
