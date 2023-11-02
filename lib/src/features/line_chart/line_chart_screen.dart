import 'package:flutter/material.dart';

import 'widgets/animated_line_chart.dart';
import 'widgets/line_chart.dart';

class LineChartScreen extends StatelessWidget {
  const LineChartScreen({
    super.key,
    required this.offsets,
  });

  final List<Offset> offsets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text('Static line chart'),
            LineChart(
              offsets: offsets,
              lineColor: Colors.blue,
              lineGradient: LinearGradient(
                colors: [
                  Colors.blue[400]!,
                  Colors.green[400]!.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              height: 200,
            ),
            const SizedBox(height: 48),
            const Text('Animated line chart'),
            AnimatedLineChart(
              offsets: offsets,
              lineColor: Colors.blue,
              lineGradient: LinearGradient(
                colors: [
                  Colors.blue[400]!,
                  Colors.green[400]!.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              height: 200,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
