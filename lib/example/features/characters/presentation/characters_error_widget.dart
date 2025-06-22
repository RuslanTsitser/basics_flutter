import 'package:flutter/material.dart';

import '../../../core/providers/characters_notifier_provider.dart';

class CharactersErrorWidget extends StatelessWidget {
  const CharactersErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final charactersNotifier =
        CharactersNotifierProvider.of(context)!.notifier!;

    if (charactersNotifier.error == null) {
      return const SizedBox.shrink();
    }

    return const Row(
      spacing: 4,
      children: [
        Text('Ошибка сети'),
        Icon(Icons.error),
      ],
    );
  }
}
