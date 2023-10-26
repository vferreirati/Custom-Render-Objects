import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/chat_bubble/chat_bubble_screen.dart';
import 'features/line_chart/line_chart_screen.dart';
import 'features/menu/menu_screen.dart';
import 'features/text_wave/text_wave_screen.dart';

class RenderObjectApplication extends StatefulWidget {
  const RenderObjectApplication({super.key});

  @override
  State<RenderObjectApplication> createState() =>
      _RenderObjectApplicationState();
}

class _RenderObjectApplicationState extends State<RenderObjectApplication> {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/chat_bubble',
        builder: (context, state) => const ChatBubbleScreen(),
      ),
      GoRoute(
        path: '/text_wave',
        builder: (context, state) => const TextWaveScreen(),
      ),
      GoRoute(
        path: '/line_chart',
        builder: (context, state) => const LineChartScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Custom render objects',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }
}
