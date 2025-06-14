import 'package:flutter/material.dart';

import '2.one_folder_with_repositories/main.dart' as stateful;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: stateful.MainScreen(),
    );
  }
}
