import 'package:flutter/material.dart';

import 'animated_line_chart_painter.dart';

class LineChart extends LeafRenderObjectWidget {
  final List<Offset> offsets;
  final Color lineColor;
  final Gradient lineGradient;
  final double animationScale;
  final double height;

  const LineChart({
    super.key,
    required this.offsets,
    required this.lineColor,
    required this.lineGradient,
    required this.height,
    this.animationScale = 1.0,
  });

  @override
  RenderLineChart createRenderObject(BuildContext context) {
    return RenderLineChart(
      height: height,
      animationScale: animationScale,
      lineColor: lineColor,
      lineGradient: lineGradient,
      offsets: offsets,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderLineChart renderObject,
  ) {
    renderObject.animationScale = animationScale;
    renderObject.height = height;
    renderObject.lineColor = lineColor;
    renderObject.lineGradient = lineGradient;
    renderObject.offsets = offsets;
  }
}

class RenderLineChart extends RenderBox {
  RenderLineChart({
    required List<Offset> offsets,
    required Color lineColor,
    required Gradient lineGradient,
    required double animationScale,
    required double height,
  }) {
    _offsets = offsets;
    _lineColor = lineColor;
    _lineGradient = lineGradient;
    _animationScale = animationScale;
    _height = height;
  }

  late List<Offset> _offsets;
  List<Offset> get offsets => _offsets;
  set offsets(List<Offset> value) {
    if (value == _offsets) return;

    _offsets = value;

    // Only paint since the layout dimensions are still the same
    markNeedsPaint();
  }

  late Color _lineColor;
  Color get lineColor => _lineColor;
  set lineColor(Color value) {
    if (value == _lineColor) return;

    _lineColor = value;

    // Only paint since the layout dimensions are still the same
    markNeedsPaint();
  }

  late Gradient _lineGradient;
  Gradient get lineGradient => _lineGradient;
  set lineGradient(Gradient value) {
    if (value == _lineGradient) return;

    _lineGradient = value;

    // Only paint since the layout dimensions are still the same
    markNeedsPaint();
  }

  late double _animationScale;
  double get animationScale => _animationScale;
  set animationScale(double value) {
    if (value == _animationScale) return;

    _animationScale = value;

    // Only paint since the layout dimensions are still the same
    markNeedsPaint();
  }

  late double _height;
  double get height => _height;
  set height(double value) {
    if (value == _height) return;

    _height = value;

    markNeedsLayout();
  }

  AnimatedLineChartPainter get painter => AnimatedLineChartPainter(
        lineColor: lineColor,
        lineGradient: lineGradient,
        offsets: offsets,
        animationScale: animationScale,
      );

  @override
  void performLayout() {
    final computedSize = Size(constraints.maxWidth, height);

    size = constraints.constrain(computedSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);

    painter.paint(canvas, size);

    canvas.restore();
  }
}
