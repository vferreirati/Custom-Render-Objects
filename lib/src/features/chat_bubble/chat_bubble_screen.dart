import 'package:flutter/material.dart';

import 'widgets/chat_bubble.dart';

class ChatBubbleScreen extends StatefulWidget {
  const ChatBubbleScreen({
    super.key,
  });

  @override
  State<ChatBubbleScreen> createState() => _ChatBubbleScreenState();
}

class _ChatBubbleScreenState extends State<ChatBubbleScreen> {
  final _controller = TextEditingController(text: 'Lorem Ipsum');
  final sentAt = '09:02';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 24.0),
            const Text(
              'This screen showcases a custom render object widget'
              ' that acts as an chat bubble similar to popular chatting apps.\n'
              'It computes the line width to determine if the sentAt label'
              ' fits on the same line as the text',
            ),
            const Spacer(),
            const ChatBubble(
              text: 'Hey, how is everything?',
              sentAt: '08:37',
              isLocal: false,
            ),
            const SizedBox(height: 24.0),
            ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, val, child) => _controller.text.isEmpty
                  ? const SizedBox.shrink()
                  : ChatBubble(
                      text: val.text,
                      sentAt: sentAt,
                    ),
            ),
            TextField(
              controller: _controller,
            )
          ],
        ),
      ),
    );
  }
}
