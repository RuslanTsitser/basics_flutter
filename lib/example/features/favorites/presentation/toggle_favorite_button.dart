import 'package:flutter/material.dart';

import '../../../core/providers/favorites_notifier_provider.dart';

class ToggleFavoriteButton extends StatelessWidget {
  const ToggleFavoriteButton({super.key, required this.characterId});
  final String characterId;

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = FavoritesNotifierProvider.of(context)!.notifier!;
    final isFavorite = favoritesNotifier.favorites.contains(characterId);
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onPressed: () => favoritesNotifier.toggleFavorite(characterId),
    );
  }
}
