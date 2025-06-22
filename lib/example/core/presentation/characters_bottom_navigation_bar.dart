import 'package:flutter/material.dart';

import '../providers/navigation_bar_notifier_provider.dart';

class CharactersBottomNavigationBar extends StatelessWidget {
  const CharactersBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = NavigationBarNotifierProvider.of(context)!.notifier!;
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
