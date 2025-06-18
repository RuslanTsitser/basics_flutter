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
    _loadCharacters();
    _loadFavorites();
    _initListeners();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _onIndexSelected(int index) {
    setState(() {
      notifier.selectedIndex = index;
    });
  }

  void _disposeControllers() {
    notifier.scrollController.dispose();
  }

  void _initListeners() {
    notifier.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (notifier.scrollController.position.pixels ==
        notifier.scrollController.position.maxScrollExtent) {
      if (!notifier.isLoading &&
          notifier.hasMorePages &&
          notifier.selectedIndex == 0) {
        _loadCharacters();
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      notifier.favorites = favorites.toSet();
    });
    await _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteCharacters() async {
    final List<Character> characters = [];

    for (final id in notifier.favorites) {
      try {
        final response = await notifier.dio
            .get('https://rickandmortyapi.com/api/character/$id');
        if (response.statusCode == 200) {
          characters
              .add(Character.fromJson(response.data as Map<String, dynamic>));
        }
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      notifier.favoriteCharacters.clear();
      notifier.favoriteCharacters.addAll(characters);
    });
  }

  Future<void> _toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (notifier.favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList('favorites', favorites);
    await _loadFavorites();
  }

  Future<void> _loadCharacters() async {
    if (notifier.isLoading) return;

    setState(() {
      notifier.isLoading = true;
      notifier.error = null;
    });

    try {
      if (notifier.currentPage == 1) {
        final prefs = await SharedPreferences.getInstance();
        final cachedData =
            prefs.getString('characters_page_${notifier.currentPage}');
        if (cachedData != null) {
          final List<dynamic> decodedData =
              json.decode(cachedData) as List<dynamic>;
          setState(() {
            notifier.characters.clear();
            notifier.characters.addAll(decodedData.map(
                (json) => Character.fromJson(json as Map<String, dynamic>)));
          });
        }
      }

      final response = await notifier.dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': notifier.currentPage},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] as List<dynamic>;
        final List<Map<String, dynamic>> newCharacters =
            results.map((json) => json as Map<String, dynamic>).toList();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'characters_page_${notifier.currentPage}',
          json.encode(results),
        );

        setState(() {
          if (notifier.currentPage == 1) {
            notifier.characters.clear();
          }
          notifier.characters
              .addAll(newCharacters.map((json) => Character.fromJson(json)));
          notifier.currentPage++;
          notifier.hasMorePages = response.data['info']['next'] != null;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        notifier.error = 'Failed to load characters: $e';
      });
    } finally {
      setState(() {
        notifier.isLoading = false;
      });
    }
  }

  Future<void> _refreshCharacters() async {
    setState(() {
      notifier.currentPage = 1;
      notifier.hasMorePages = true;
    });
    await _loadCharacters();
  }

  Widget _buildCharacterList() {
    return RefreshIndicator(
      onRefresh: _refreshCharacters,
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
                onPressed: () => _toggleFavorite(character.id.toString()),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesList() {
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
              onPressed: () => _toggleFavorite(character.id.toString()),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              onPressed: _refreshCharacters,
            ),
        ],
      ),
      body: notifier.selectedIndex == 0
          ? _buildCharacterList()
          : _buildFavoritesList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: notifier.selectedIndex,
        onTap: _onIndexSelected,
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
      ),
    );
  }
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

class CharactersNotifier {
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
}
