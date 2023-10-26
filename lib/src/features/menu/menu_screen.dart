import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          children: [
            ListTile(
              title: const Text('Chat bubble'),
              subtitle: const Text(
                'Widget that mimics the chat bubble of popular chatting apps',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/chat_bubble'),
            ),
            const Divider(),
            ListTile(
              title: const Text('Text wave'),
              subtitle: const Text(
                'Widget that displays a wave animation on the background of the text',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/text_wave'),
            ),
            const Divider(),
            ListTile(
              title: const Text('Animated Line Chart'),
              subtitle: const Text(
                'Widget that displays a basic Line Chart with animations',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/line_chart'),
            ),
          ],
        ),
      ),
    );
  }
}
