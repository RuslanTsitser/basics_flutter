import 'package:flutter/material.dart';

import 'core/presentation/characters_app_bar.dart';
import 'core/presentation/characters_body.dart';
import 'core/presentation/characters_bottom_navigation_bar.dart';
import 'core/providers/characters_notifier_provider.dart';
import 'core/providers/favorites_notifier_provider.dart';
import 'core/providers/navigation_bar_notifier_provider.dart';
import 'core/state_manager/navigation_bar_notifier.dart';
import 'features/characters/data/characters_repository.dart';
import 'features/characters/logic/characters_notifier.dart';
import 'features/favorites/data/favorites_repository.dart';
import 'features/favorites/logic/favorites_notifier.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final scrollController = ScrollController();
  late final CharactersNotifier charactersNotifier = CharactersNotifier(
    charactersRepository: CharactersRepositoryImpl(),
    scrollController: scrollController,
  );
  final NavigationBarNotifier navigationBarNotifier = NavigationBarNotifier();
  late final FavoritesNotifier favoritesNotifier = FavoritesNotifier(
    repository: FavoritesRepositoryImpl(),
  );

  @override
  void initState() {
    super.initState();
    charactersNotifier.loadCharacters();
    favoritesNotifier.loadFavorites();
    charactersNotifier.initListeners();
  }

  @override
  void dispose() {
    charactersNotifier.dispose();
    navigationBarNotifier.dispose();
    favoritesNotifier.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarNotifierProvider(
      notifier: navigationBarNotifier,
      child: FavoritesNotifierProvider(
        notifier: favoritesNotifier,
        child: CharactersNotifierProvider(
          notifier: charactersNotifier,
          child: const Scaffold(
            appBar: CharactersAppBar(),
            body: CharactersBody(),
            bottomNavigationBar: CharactersBottomNavigationBar(),
          ),
        ),
      ),
    );
  }
}
