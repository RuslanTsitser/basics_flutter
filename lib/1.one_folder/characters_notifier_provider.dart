import 'package:flutter/material.dart';

import 'characters_notifier.dart';

class CharactersNotifierProvider extends InheritedNotifier<CharactersNotifier> {
  const CharactersNotifierProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static CharactersNotifierProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CharactersNotifierProvider>();
  }
}
