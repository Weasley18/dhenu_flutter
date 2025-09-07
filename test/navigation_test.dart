import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dhenu_flutter/main.dart';
import 'package:dhenu_flutter/src/navigation/router.dart';

void main() {
  testWidgets('Navigation works without auth', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: DhenuApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify landing screen is displayed
    expect(find.text('Welcome to Dhenu'), findsOneWidget);
    expect(find.text('Go to Dashboard'), findsOneWidget);

    // Navigate to dashboard
    await tester.tap(find.text('Go to Dashboard'));
    await tester.pumpAndSettle();

    // Verify dashboard is displayed
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
