import 'package:flutter/material.dart';

import '../../features/characters/presentation/characters_error_widget.dart';
import '../../features/characters/presentation/refresh_characters_button.dart';
import '../providers/navigation_bar_notifier_provider.dart';

class CharactersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CharactersAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = NavigationBarNotifierProvider.of(context)!.notifier!;

    return AppBar(
      title: Text(notifier.selectedIndex == 0 ? 'Персонажи' : 'Избранное'),
      actions: [
        if (notifier.selectedIndex == 0) const RefreshCharactersButton(),
        if (notifier.selectedIndex == 0) const CharactersErrorWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
