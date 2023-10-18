import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class TextWave extends StatefulWidget {
  const TextWave({
    super.key,
    required this.text,
    required this.style,
    this.wavePercentage = 0.5,
  });

  final String text;

  final TextStyle style;

  final double wavePercentage;

  @override
  State<TextWave> createState() => _TextWaveState();
}

class _TextWaveState extends State<TextWave> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) => ShaderMask(
        shaderCallback: (bounds) {
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder, bounds);
          final painter = WavePainter(
            waveOffset: value,
            wavePercentage: widget.wavePercentage,
          );

          painter.paint(canvas, bounds.size);
          final image = recorder.endRecording().toImageSync(
                bounds.size.width.toInt(),
                bounds.size.height.toInt(),
              );
          return ImageShader(
            image,
            TileMode.repeated,
            TileMode.repeated,
            Matrix4.identity().storage,
          );
        },
        blendMode: BlendMode.srcATop,
        child: Text(
          widget.text,
          style: widget.style,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final double waveOffset;
  final double wavePercentage;

  WavePainter({
    required this.waveOffset,
    required this.wavePercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
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
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
