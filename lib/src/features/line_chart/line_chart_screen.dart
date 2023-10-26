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
      lowerBound: 0.1,
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
                offsets: offsets
                    .take((offsets.length * _controller.value).floor())
                    .toList(),
                lineColor: Colors.blue,
                pointColor: Colors.blue[100]!,
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
        10,
        (index) => Offset(index.toDouble(), random.nextDouble() * 255),
      );
    });
  }
}

class LineChart extends StatelessWidget {
  final List<Offset> offsets;
  final Color lineColor;
  final Color pointColor;

  const LineChart({
    super.key,
    required this.offsets,
    required this.pointColor,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LineChartPainter(
        lineColor: lineColor,
        offsets: offsets,
        pointColor: pointColor,
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final Color lineColor;
  final Color pointColor;
  final List<Offset> offsets;

  LineChartPainter({
    super.repaint,
    required this.lineColor,
    required this.offsets,
    required this.pointColor,
  });

  Paint get _linePaint => Paint()
    ..color = lineColor
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  Paint get _pointPaint => Paint()
    ..color = pointColor
    ..strokeWidth = 1.0;

  Paint get _boxPaint => Paint()
    ..color = pointColor
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final totalWidth = size.width;
    final totalHeight = size.height;

    final offsetWidth = totalWidth / offsets.length;
    final maxY = offsets
        .map((e) => e.dy.floor())
        .reduce((value, element) => max(value, element));

    final effectivePoints = <Offset>[];
    for (int i = 0; i < offsets.length; i++) {
      final rect = Offset(
            (i * offsetWidth).toDouble(),
            0.0,
          ) &
          Size(
            offsetWidth.toDouble(),
            totalHeight,
          );
      canvas.drawRect(
        rect,
        _boxPaint,
      );

      final hasNext = i + 1 < offsets.length;
      // if (!hasNext) continue;

      final pointA = offsets[i];
      // final pointB = offsets[i + 1];

      final x1 = (pointA.dx * offsetWidth) + (i > 0 ? offsetWidth / 2 : 0);
      final y1 = yToLocal(pointA.dy, totalHeight, maxY);

      // final x2 = (pointB.dx * offsetWidth) +
      //     (i + 2 == offsets.length ? offsetWidth : offsetWidth / 2);
      // final y2 = yToLocal(pointB.dy, totalHeight, maxY);

      final offsetA = Offset(x1, y1);
      effectivePoints.add(offsetA);
      // final offsetB = Offset(x2, y2);

      // canvas.drawLine(offsetA, offsetB, _linePaint);
    }

    canvas.drawPoints(PointMode.polygon, effectivePoints, _linePaint);
  }

  @override
  bool shouldRepaint(
    covariant LineChartPainter oldDelegate,
  ) =>
      oldDelegate.lineColor != lineColor || oldDelegate.offsets != offsets;

  double yToLocal(double y, double availableHeight, int maxY) {
    final localY = (y * availableHeight) / maxY;

    return availableHeight - localY;
  }
}
