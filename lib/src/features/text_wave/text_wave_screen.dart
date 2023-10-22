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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            TextWave(
              text: 'Wave',
              wavePercentage: percentage,
              style: TextStyle(
                color: Colors.blue[100],
                fontWeight: FontWeight.bold,
                fontSize: 128,
              ),
            ),
            const SizedBox(height: 24.0),
            TextWave(
              text: 'Text',
              axis: Axis.vertical,
              wavePercentage: percentage,
              style: TextStyle(
                color: Colors.blue[100],
                fontWeight: FontWeight.bold,
                fontSize: 128,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
