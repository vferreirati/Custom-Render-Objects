import 'package:flutter/material.dart';

import 'animated_line_chart_painter.dart';

// TODO: This could be the render object widget itself
class LineChart extends StatelessWidget {
  final List<Offset> offsets;
  final Color lineColor;
  final Gradient lineGradient;

  const LineChart({
    super.key,
    required this.offsets,
    required this.lineColor,
    required this.lineGradient,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AnimatedLineChartPainter(
        lineColor: lineColor,
        offsets: offsets,
        lineGradient: lineGradient,
      ),
    );
  }
}
