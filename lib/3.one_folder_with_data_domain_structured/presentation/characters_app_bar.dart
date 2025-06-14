import 'package:flutter/material.dart';

import '../characters_notifier_provider.dart';

class CharactersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CharactersAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = CharactersNotifierProvider.of(context)!.notifier!;
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
