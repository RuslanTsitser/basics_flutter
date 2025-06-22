import 'package:flutter/material.dart';

import '../../features/favorites/logic/favorites_notifier.dart';

class FavoritesNotifierProvider extends InheritedNotifier<FavoritesNotifier> {
  const FavoritesNotifierProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static FavoritesNotifierProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FavoritesNotifierProvider>();
  }
}
