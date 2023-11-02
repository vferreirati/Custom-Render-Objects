import 'package:flutter/material.dart';

import 'line_chart.dart';

class AnimatedLineChart extends StatefulWidget {
  final List<Offset> offsets;
  final Color lineColor;
  final Gradient lineGradient;
  final double height;
  final Duration duration;

  const AnimatedLineChart({
    super.key,
    required this.offsets,
    required this.lineColor,
    required this.lineGradient,
    required this.height,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    super.initState();
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
      builder: (context, value, child) => LineChart(
        lineColor: widget.lineColor,
        offsets: widget.offsets,
        lineGradient: widget.lineGradient,
        height: widget.height,
        animationScale: value,
      ),
    );
  }
}
