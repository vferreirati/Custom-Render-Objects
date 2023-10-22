import 'package:flutter/material.dart';

import 'wave_shader_mask.dart';

class TextWave extends StatefulWidget {
  const TextWave({
    super.key,
    required this.text,
    required this.style,
    this.wavePercentage = 0.5,
    this.axis = Axis.horizontal,
  });

  final String text;

  final TextStyle style;

  final double wavePercentage;

  final Axis axis;

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
      builder: (context, value, child) => WaveShaderMask(
        waveColor: Colors.blue,
        waveOffset: value,
        wavePercentage:
            widget.axis == Axis.vertical ? value : widget.wavePercentage,
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
