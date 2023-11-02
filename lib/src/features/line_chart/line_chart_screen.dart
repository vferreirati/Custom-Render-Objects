import 'dart:math';

import 'package:flutter/material.dart';

import 'widgets/animated_line_chart.dart';
import 'widgets/line_chart.dart';

class LineChartScreen extends StatefulWidget {
  const LineChartScreen({
    super.key,
  });

  @override
  State<LineChartScreen> createState() => _LineChartScreenState();
}

class _LineChartScreenState extends State<LineChartScreen>
    with SingleTickerProviderStateMixin {
  late List<Offset> offsets;

  @override
  void initState() {
    super.initState();

    _generateOffsets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Static line chart'),
          ),
          Container(
            height: 250.0,
            width: double.infinity,
            margin: const EdgeInsets.all(12.0),
            child: LineChart(
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
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('Animated line chart'),
          ),
          Container(
            height: 250.0,
            width: double.infinity,
            margin: const EdgeInsets.all(12.0),
            child: AnimatedLineChart(
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
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void _generateOffsets() {
    final random = Random();

    setState(() {
      offsets = List.generate(
        50,
        (index) => Offset(index.toDouble(), random.nextDouble() * 250),
      );
    });
  }
}
