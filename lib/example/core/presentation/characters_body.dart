import 'package:flutter/material.dart';

import '../../features/characters/presentation/characters_list.dart';
import '../../features/favorites/presentation/favorites_list.dart';
import '../providers/navigation_bar_notifier_provider.dart';

class CharactersBody extends StatelessWidget {
  const CharactersBody({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = NavigationBarNotifierProvider.of(context)!.notifier!;
    return notifier.selectedIndex == 0
        ? const CharactersList()
        : const FavoritesList();
  }
}
