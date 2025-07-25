import 'package:flutter/material.dart';

class BlockingExampleScreen extends StatelessWidget {
  const BlockingExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocking Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Block the UI Thread
          print('Blocking the UI Thread');
          final start = DateTime.now();
          int value = 0;
          for (var i = 0; i < 100000; i++) {
            value++;
            print('Value: $value');
          }
          final end = DateTime.now();
          print(
              'Unblocked the UI Thread after ${end.difference(start).inMilliseconds}ms');
          print('Value: $value');
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
          // child: CircularProgressIndicator(),
          ),
    );
  }
}
