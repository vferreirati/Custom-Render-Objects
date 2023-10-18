import 'package:flutter/material.dart';

import 'widgets/text_wave.dart';

class TextWaveScreen extends StatelessWidget {
  const TextWaveScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const percentage = 0.65;

    return Scaffold(
      body: Center(
        child: TextWave(
          text: '${(percentage * 100).floor()}%',
          wavePercentage: percentage,
          style: TextStyle(
            color: Colors.blue[100],
            fontWeight: FontWeight.bold,
            fontSize: 128,
          ),
        ),
      ),
    );
  }
}
