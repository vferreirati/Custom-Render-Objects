import 'package:flutter/material.dart';

import 'features/chat_bubble/chat_bubble_screen.dart';
import 'features/text_wave/text_wave_screen.dart';

class RenderObjectApplication extends StatelessWidget {
  const RenderObjectApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: ChatBubbleScreen(),
      home: TextWaveScreen(),
    );
  }
}
