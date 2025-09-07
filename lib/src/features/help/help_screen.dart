import 'package:flutter/material.dart';

/// Help screen component
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.help,
              size: 80,
              color: Colors.brown,
            ),
            const SizedBox(height: 24),
            const Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Help content and support information would be shown here',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }
}
