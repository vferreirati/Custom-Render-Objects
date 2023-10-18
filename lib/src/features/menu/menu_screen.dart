import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Chat bubble'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/chat_bubble'),
            ),
            ListTile(
              title: const Text('Text wave'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/text_wave'),
            ),
          ],
        ),
      ),
    );
  }
}
