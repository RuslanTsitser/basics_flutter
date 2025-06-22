import 'package:flutter/material.dart';

import '../state_manager/navigation_bar_notifier.dart';

class NavigationBarNotifierProvider
    extends InheritedNotifier<NavigationBarNotifier> {
  const NavigationBarNotifierProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static NavigationBarNotifierProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavigationBarNotifierProvider>();
  }
}
