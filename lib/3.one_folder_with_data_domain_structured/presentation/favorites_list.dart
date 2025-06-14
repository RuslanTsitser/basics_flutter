import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../characters_notifier_provider.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = CharactersNotifierProvider.of(context)!.notifier!;
    if (notifier.favoriteCharacters.isEmpty) {
      return const Center(child: Text('Нет избранных персонажей'));
    }

    return ListView.builder(
      itemCount: notifier.favoriteCharacters.length,
      itemBuilder: (context, index) {
        final character = notifier.favoriteCharacters[index];
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
              onPressed: () => notifier.toggleFavorite(character.id.toString()),
            ),
          ),
        );
      },
    );
  }
}
