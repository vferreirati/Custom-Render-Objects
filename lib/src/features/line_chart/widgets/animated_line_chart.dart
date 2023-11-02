import 'package:flutter/material.dart';

import 'animated_line_chart_painter.dart';

// TODO: This could be an ImplicityAnimatedWidget thingy
class AnimatedLineChart extends StatefulWidget {
  /// Duration of the animation in milliseconds
  final int animationDuration;
  final List<Offset> offsets;
  final Color lineColor;
  final Gradient lineGradient;

  const AnimatedLineChart({
    super.key,
    required this.offsets,
    required this.lineColor,
    required this.lineGradient,
    this.animationDuration = 2000,
  });

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.animationDuration,
      ),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) => CustomPaint(
        painter: AnimatedLineChartPainter(
          lineColor: widget.lineColor,
          offsets: widget.offsets,
          lineGradient: widget.lineGradient,
          animationScale: value,
        ),
      ),
    );
  }
}
