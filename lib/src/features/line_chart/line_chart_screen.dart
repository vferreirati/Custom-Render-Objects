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
    _generateOffsets();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
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
                pointColor: Colors.blue[100]!,
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
  final Color pointColor;
  final double animationScale;

  const LineChart({
    super.key,
    required this.offsets,
    required this.pointColor,
    required this.lineColor,
    this.animationScale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        lineColor: lineColor,
        offsets: offsets,
        pointColor: pointColor,
        animationScale: animationScale,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final Color pointColor;
  final List<Offset> offsets;
  final double animationScale;

  LineChartPainter({
    super.repaint,
    required this.lineColor,
    required this.offsets,
    required this.pointColor,
    this.animationScale = 1.0,
  });

  Paint get _linePaint => Paint()
    ..color = lineColor
    ..strokeWidth = 2.0
    ..strokeCap = StrokeCap.round;

  Paint get _containerPaint => Paint()
    ..color = Colors.grey
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = size.width;
    final totalHeight = size.height;

    final offsetWidth = totalWidth / offsets.length;
    final maxY = offsets
        .map((e) => e.dy.floor())
        .reduce((value, element) => max(value, element));

    final steps = offsets.length - 1;
    final stepDuration = 1.0 / steps;

    drawContainer(
      height: totalHeight,
      width: totalWidth,
      canvas: canvas,
    );

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
      final y1 = yToLocal(pointA.dy, totalHeight, maxY);

      double x2 = (pointB.dx * offsetWidth) +
          (i + 2 == offsets.length ? offsetWidth : offsetWidth / 2);
      double y2 = yToLocal(pointB.dy, totalHeight, maxY);

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
    }
  }

  void drawContainer({
    required double height,
    required double width,
    required Canvas canvas,
  }) {
    const count = 10;
    final widthOffset = width / count;
    final heightOffset = height / count;

    for (int i = 0; i <= count; i++) {
      // Vertical lines
      final xVertPos = widthOffset * i;
      final vertStart = Offset(xVertPos, 0.0);
      final vertEnd = Offset(xVertPos, height);
      canvas.drawLine(vertStart, vertEnd, _containerPaint);

      // Horizontal lines
      final yPos = heightOffset * i;
      final horStart = Offset(0.0, yPos);
      final horEnd = Offset(width, yPos);
      canvas.drawLine(horStart, horEnd, _containerPaint);
    }
  }

  @override
  bool shouldRepaint(
    covariant LineChartPainter oldDelegate,
  ) =>
      oldDelegate.lineColor != lineColor ||
      oldDelegate.offsets != offsets ||
      oldDelegate.animationScale != animationScale ||
      oldDelegate.pointColor != pointColor;

  double yToLocal(double y, double availableHeight, int maxY) {
    final localY = (y * availableHeight) / maxY;

    return availableHeight - localY;
  }
}
