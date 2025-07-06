import 'package:flutter/material.dart';

import '0.heavy_widget_screen.dart';
import '1.heavy_widget_optimized_screen.dart';
import '2.heavy_widget_optimized_better_screen.dart';

class ProfilingScreen extends StatelessWidget {
  const ProfilingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16.0,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HeavyWidgetScreen(),
                    transitionsBuilder: (_, __, ___, child) => child,
                  ),
                );
              },
              child: const ColoredBox(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Heavy Widget'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const HeavyWidgetOptimizedScreen(),
                    transitionsBuilder: (_, __, ___, child) => child,
                  ),
                );
              },
              child: const ColoredBox(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Heavy Widget with const'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const HeavyWidgetOptimizedBetterScreen(),
                    transitionsBuilder: (_, __, ___, child) => child,
                  ),
                );
              },
              child: const ColoredBox(
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Heavy Widget with const and Separated Widget'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
