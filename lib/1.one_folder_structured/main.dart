import 'package:flutter/material.dart';

import 'characters_notifier_provider.dart';
import 'presentation/characters_app_bar.dart';
import 'presentation/characters_bottom_navigation_bar.dart';
import 'presentation/characters_list.dart';
import 'presentation/favorites_list.dart';
import 'state_manager/characters_notifier.dart';

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
    return CharactersNotifierProvider(
      notifier: notifier,
      child: const Scaffold(
        appBar: CharactersAppBar(),
        body: CharactersBody(),
        bottomNavigationBar: CharactersBottomNavigationBar(),
      ),
    );
  }
}

class CharactersBody extends StatelessWidget {
  const CharactersBody({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = CharactersNotifierProvider.of(context)!.notifier!;
    return notifier.selectedIndex == 0
        ? const CharactersList()
        : const FavoritesList();
  }
}
