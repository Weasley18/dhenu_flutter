import 'package:flutter/material.dart';

/// Network screen component
class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people,
              size: 80,
              color: Colors.brown,
            ),
            const SizedBox(height: 24),
            const Text(
              'Network',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your network connections would be shown here',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Find Connections'),
            ),
          ],
        ),
      ),
    );
  }
}
