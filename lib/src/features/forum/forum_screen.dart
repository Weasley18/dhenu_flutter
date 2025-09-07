import 'package:flutter/material.dart';

/// Forum screen component
class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.forum,
              size: 80,
              color: Colors.brown,
            ),
            const SizedBox(height: 24),
            const Text(
              'Forum',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Forum discussions would be displayed here',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Start Discussion'),
            ),
          ],
        ),
      ),
    );
  }
}
