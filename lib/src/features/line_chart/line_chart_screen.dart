import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class LineChartScreen extends StatefulWidget {
  const LineChartScreen({
    super.key,
  });

  @override
  State<LineChartScreen> createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen>
    with SingleTickerProviderStateMixin {
  late List<Offset> offsets;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _generateOffsets();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            height: 250.0,
            width: double.infinity,
            margin: const EdgeInsets.all(12.0),
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, child) => LineChart(
                offsets: offsets,
                lineColor: Colors.blue,
                lineGradient: LinearGradient(
                  colors: [
                    Colors.blue[400]!,
                    Colors.green[400]!.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                animationScale: _controller.value,
              ),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _generateOffsets,
            child: const Text('Generate offsets'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _generateOffsets() {
    final random = Random();

    setState(() {
      offsets = List.generate(
        50,
        (index) => Offset(index.toDouble(), random.nextDouble() * 250),
      );
    });

    _controller.reset();
    _controller.forward();
  }
}

class LineChart extends StatelessWidget {
  final List<Offset> offsets;
  final Color lineColor;
  final double animationScale;
  final int sectionCount;
  final Gradient lineGradient;

  const LineChart({
    super.key,
    required this.offsets,
    required this.lineColor,
    required this.lineGradient,
    this.animationScale = 1.0,
    this.sectionCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        lineColor: lineColor,
        offsets: offsets,
        animationScale: animationScale,
        sectionCount: sectionCount,
        lineGradient: lineGradient,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final List<Offset> offsets;
  final double animationScale;
  final int sectionCount;
  final Gradient lineGradient;

  LineChartPainter({
    super.repaint,
    required this.lineColor,
    required this.offsets,
    required this.lineGradient,
    this.animationScale = 1.0,
    this.sectionCount = 10,
  });

  Paint get _linePaint => Paint()
    ..color = lineColor
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = size.width;
    final totalHeight = size.height;

    final maxY = offsets
        .map((e) => e.dy)
        .reduce((value, element) => max(value, element));
    final minY = offsets
        .map((e) => e.dy)
        .reduce((value, element) => min(value, element));

    drawLine(
      canvas: canvas,
      height: totalHeight,
      width: totalWidth,
      maxY: maxY,
      minY: minY,
    );
  }

  void drawLine({
    required Canvas canvas,
    required double height,
    required double width,
    required double maxY,
    required double minY,
  }) {
    final offsetWidth = width / offsets.length;

    final steps = offsets.length - 1;
    final stepDuration = 1.0 / steps;

    final path = Path();
    late Offset lastOffset;

    for (int i = 0; i < offsets.length; i++) {
      final hasNext = i + 1 < offsets.length;
      if (!hasNext) continue;

      final pointA = offsets[i];
      final pointB = offsets[i + 1];
      final stepStart = i * stepDuration;
      final stepEnd = stepStart + stepDuration;

      if (animationScale < stepStart) break;

      final stepAnimationScale = animationScale - (stepDuration * i);
      final stepInterpolator = stepAnimationScale / stepDuration;

      final x1 = (pointA.dx * offsetWidth) + (i > 0 ? offsetWidth / 2 : 0);
      final y1 = yToLocal(pointA.dy, height, maxY);

      double x2 = (pointB.dx * offsetWidth) +
          (i + 2 == offsets.length ? offsetWidth : offsetWidth / 2);
      double y2 = yToLocal(pointB.dy, height, maxY);

      // Current animation scale is between the start and end
      // Meaning that the line will not be completely drawn
      if (animationScale >= stepStart && animationScale <= stepEnd) {
        final lerpX = lerpDouble(x1, x2, stepInterpolator);
        final lerpY = lerpDouble(y1, y2, stepInterpolator);

        x2 = lerpX ?? x2;
        y2 = lerpY ?? y2;
      }

      final offsetA = Offset(x1, y1);
      final offsetB = Offset(x2, y2);

      canvas.drawLine(offsetA, offsetB, _linePaint);

      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
        if (i == offsets.length - 2) path.lineTo(x2, y2);
      }

      lastOffset = i == offsets.length - 2 ? offsetB : offsetA;
    }

    path.lineTo(lastOffset.dx, height);
    path.lineTo(0.0, height);
    path.close();

    final rect = const Offset(0, 0) & Size(width, height);
    final paint = Paint()..shader = lineGradient.createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant LineChartPainter oldDelegate,
  ) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.offsets != offsets ||
      oldDelegate.animationScale != animationScale ||
      oldDelegate.lineGradient != lineGradient;

  double yToLocal(
    double y,
    double availableHeight,
    double maxY,
  ) {
    final localY = (y * availableHeight) / maxY;

    return availableHeight - localY;
  }

  double calculateLinearIncrement({
    required double minValue,
    required double maxValue,
    required int numberOfIncrements,
  }) {
    if (numberOfIncrements <= 1) {
      return 0.0;
    }

    double range = maxValue - minValue;

    double increment = range / (numberOfIncrements - 1);

    increment = increment.roundToDouble();

    return increment;
  }
}
