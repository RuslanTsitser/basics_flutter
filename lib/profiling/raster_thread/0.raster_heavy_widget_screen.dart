// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RasterHeavyWidgetScreen extends StatefulWidget {
  const RasterHeavyWidgetScreen({super.key});

  @override
  State<RasterHeavyWidgetScreen> createState() =>
      _RasterHeavyWidgetScreenState();
}

class _RasterHeavyWidgetScreenState extends State<RasterHeavyWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    debugRepaintRainbowEnabled = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heavy Widget'),
      ),
      floatingActionButton: const RepaintBoundary(child: _Hello()),
      body: Column(
        children: [
          for (var i = 0; i < 5; i++) const HeavyWidget(useCustomPaint: true),
        ],
      ),
    );
  }
}

class _Hello extends StatelessWidget {
  const _Hello();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
    );
  }
}

class HeavyWidget extends StatelessWidget {
  const HeavyWidget({super.key, this.useCustomPaint = false});
  final bool useCustomPaint;

  @override
  Widget build(BuildContext context) {
    if (useCustomPaint) {
      return CustomPaint(
        painter: HeavyPainter(),
        size: Size(100, 100),
        isComplex: true,
        willChange: false,
      );
    }
    return Stack(
      children: [
        for (var i = 0; i < 100; i++)
          for (var j = 0; j < 100; j++)
            SizedBox(
              width: 100,
              height: 100,
              child: ColoredBox(color: Colors.red),
            ),
      ],
    );
  }
}

class HeavyPainter extends CustomPainter {
  const HeavyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    print('paint');
    for (var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        canvas.drawRect(
          Rect.fromLTWH(i.toDouble(), j.toDouble(), 10, 10),
          Paint()..color = Colors.red,
        );
      }
    }
  }

  @override
  bool shouldRepaint(HeavyPainter oldDelegate) => false;
}
