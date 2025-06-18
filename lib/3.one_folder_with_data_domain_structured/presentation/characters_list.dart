import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../characters_notifier_provider.dart';

class CharactersList extends StatelessWidget {
  const CharactersList({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = CharactersNotifierProvider.of(context)!.notifier!;
    return RefreshIndicator(
      onRefresh: notifier.refreshCharacters,
      child: ListView.builder(
        controller: notifier.scrollController,
        itemCount: notifier.characters.length + (notifier.hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifier.characters.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final character = notifier.characters[index];
          final isFavorite =
              notifier.favorites.contains(character.id.toString());

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
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () =>
                    notifier.toggleFavorite(character.id.toString()),
              ),
            ),
          );
        },
      ),
    );
  }
}
