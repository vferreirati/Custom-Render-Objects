import 'dart:math';

import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double waveOffset;
  final double wavePercentage;
  final Color waveColor;

  WavePainter({
    required this.waveOffset,
    required this.wavePercentage,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill;

    final path = Path();

    final effectivePercentage = 1.0 - wavePercentage;

    final y = size.height * effectivePercentage;

    // Move to the initial position, just outside the left edge of the canvas
    path.moveTo(-size.width * 0.5, y);

    // Loop to create the wave effect
    for (double x = -size.width * 0.5; x < size.width * 1.5; x += 10) {
      // Calculate the vertical position (waveY) of the wave using the sine function.
      // The waveOffset is applied to shift the wave horizontally.
      final waveY = y + 10 * sin((x + waveOffset * size.width) * 2 * pi / 200);

      // Add a point to the path at the calculated (x, waveY) position
      path.lineTo(x, waveY);
    }

    // Complete the path by drawing lines along the bottom and the left side of the canvas
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // Close the path by connecting the last point to the starting point
    path.close();

    // Draw the filled wave shape on the canvas using the specified paint
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      oldDelegate.waveColor != waveColor ||
      oldDelegate.waveOffset != waveOffset ||
      oldDelegate.wavePercentage != wavePercentage;
}
