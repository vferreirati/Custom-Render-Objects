import 'package:flutter/material.dart';

class TextWaveScreen extends StatelessWidget {
  const TextWaveScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: WaveBox(),
    );
  }
}

class WaveBox extends StatelessWidget {
  const WaveBox({
    super.key,
    this.size = 400.0,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 400.0,
        decoration: BoxDecoration(
          color: Colors.blue[100],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height);

    path.lineTo(size.width, size.height);

    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
