import 'package:flutter/material.dart';

import '0.one_file/main_00.dart' as one_file_00;
import '0.one_file/main_07.dart' as one_file_07;
import '1.one_folder/main.dart' as one_folder;
import '1.one_folder_structured/main.dart' as one_folder_structured;
import '2.one_folder_with_repositories/main.dart' as one_folder_with_repository;
import '2.one_folder_with_repositories_structured/main.dart'
    as one_folder_with_repositories_structured;
import '3.one_folder_with_data_domain/main.dart' as one_folder_with_data_domain;
import '3.one_folder_with_data_domain_structured/main.dart'
    as one_folder_with_data_domain_structured;
import 'example/main_screen.dart' as example;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

const screens = {
  '0.one_file_00': one_file_00.MainScreen(),
  '0.one_file_07': one_file_07.MainScreen(),
  '1.one_folder': one_folder.MainScreen(),
  '1.one_folder_structured': one_folder_structured.MainScreen(),
  '2.one_folder_with_repository': one_folder_with_repository.MainScreen(),
  '2.one_folder_with_repositories_structured':
      one_folder_with_repositories_structured.MainScreen(),
  '3.one_folder_with_data_domain': one_folder_with_data_domain.MainScreen(),
  '3.one_folder_with_data_domain_structured':
      one_folder_with_data_domain_structured.MainScreen(),
  'example': example.MainScreen(),
};

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...screens.entries.map((screen) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => screen.value));
                  },
                  child: Text(screen.key),
                )),
          ],
        ),
      ),
    );
  }
}
