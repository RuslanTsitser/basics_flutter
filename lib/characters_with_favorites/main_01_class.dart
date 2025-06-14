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
  final Dio _dio = Dio();
  final List<Character> _characters = [];
  final List<Character> _favoriteCharacters = [];
  bool _isLoading = false;
  String? _error;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _hasMorePages = true;
  Set<String> _favorites = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    _loadFavorites();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMorePages && _selectedIndex == 0) {
        _loadCharacters();
      }
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    setState(() {
      _favorites = favorites.toSet();
    });
    await _loadFavoriteCharacters();
  }

  Future<void> _loadFavoriteCharacters() async {
    final List<Character> characters = [];

    for (final id in _favorites) {
      try {
        final response = await _dio.get('https://rickandmortyapi.com/api/character/$id');
        if (response.statusCode == 200) {
          characters.add(Character.fromJson(response.data as Map<String, dynamic>));
        }
      } catch (e) {
        print(e);
      }
    }

    setState(() {
      _favoriteCharacters.clear();
      _favoriteCharacters.addAll(characters);
    });
  }

  Future<void> _toggleFavorite(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    if (_favorites.contains(characterId)) {
      favorites.remove(characterId);
    } else {
      favorites.add(characterId);
    }

    await prefs.setStringList('favorites', favorites);
    await _loadFavorites();
  }

  Future<void> _loadCharacters() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (_currentPage == 1) {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('characters_page_$_currentPage');
        if (cachedData != null) {
          final List<dynamic> decodedData = json.decode(cachedData) as List<dynamic>;
          setState(() {
            _characters.clear();
            _characters.addAll(decodedData.map((json) => Character.fromJson(json as Map<String, dynamic>)));
          });
        }
      }

      final response = await _dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': _currentPage},
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] as List<dynamic>;
        final List<Map<String, dynamic>> newCharacters = results.map((json) => json as Map<String, dynamic>).toList();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'characters_page_$_currentPage',
          json.encode(results),
        );

        setState(() {
          if (_currentPage == 1) {
            _characters.clear();
          }
          _characters.addAll(newCharacters.map((json) => Character.fromJson(json)));
          _currentPage++;
          _hasMorePages = response.data['info']['next'] != null;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _error = 'Failed to load characters: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCharacters() async {
    setState(() {
      _currentPage = 1;
      _hasMorePages = true;
    });
    await _loadCharacters();
  }

  Widget _buildCharacterList() {
    return RefreshIndicator(
      onRefresh: _refreshCharacters,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _characters.length + (_hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final character = _characters[index];
          final isFavorite = _favorites.contains(character.id.toString());

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
    if (_favoriteCharacters.isEmpty) {
      return const Center(child: Text('Нет избранных персонажей'));
    }

    return ListView.builder(
      itemCount: _favoriteCharacters.length,
      itemBuilder: (context, index) {
        final character = _favoriteCharacters[index];
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
        title: Text(_selectedIndex == 0 ? 'Персонажи' : 'Избранное'),
        actions: [
          if (_error != null && _selectedIndex == 0)
            const Row(
              spacing: 4,
              children: [
                Text('Ошибка сети'),
                Icon(Icons.error),
              ],
            ),
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshCharacters,
            ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildCharacterList() : _buildFavoritesList(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
