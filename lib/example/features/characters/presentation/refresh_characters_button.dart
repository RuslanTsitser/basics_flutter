import 'package:flutter/material.dart';

import '../../../core/providers/characters_notifier_provider.dart';

class RefreshCharactersButton extends StatelessWidget {
  const RefreshCharactersButton({super.key});

  @override
  Widget build(BuildContext context) {
    final charactersNotifier =
        CharactersNotifierProvider.of(context)!.notifier!;
    return IconButton(
      onPressed: () {
        charactersNotifier.loadCharacters();
      },
      icon: const Icon(Icons.refresh),
    );
  }
}
