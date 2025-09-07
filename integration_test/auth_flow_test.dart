import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhenu_flutter/main.dart' as app;

void main() {
  // Integration test binding is commented out as it's not available in dependencies
  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Authentication Flow Tests', () {
    testWidgets('Complete sign-in flow works correctly', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      
      // We should start at the landing page
      expect(find.text('Dhenu'), findsOneWidget);
      
      // Navigate to sign-in screen
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();
      
      // Check that we're on the sign in screen
      expect(find.text('Sign In'), findsOneWidget);
      
      // Find the email and password fields
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      
      // Enter credentials
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      
      // Submit the form
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      
      // We should be redirected to the dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
    
    testWidgets('Sign-up flow creates new account', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to sign-up screen
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      
      // Check that we're on the sign up screen
      expect(find.text('Create Account'), findsOneWidget);
      
      // Find the input fields
      final nameField = find.byType(TextField).at(0);
      final emailField = find.byType(TextField).at(1);
      final passwordField = find.byType(TextField).at(2);
      final confirmPasswordField = find.byType(TextField).at(3);
      
      // Enter user information
      await tester.enterText(nameField, 'Test User');
      await tester.enterText(emailField, 'newuser@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.enterText(confirmPasswordField, 'password123');
      
      // Select role (Farmer)
      await tester.tap(find.text('Select Role'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Farmer').last);
      await tester.pumpAndSettle();
      
      // Submit the form
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      
      // We should be redirected to the dashboard
      expect(find.text('Dashboard'), findsOneWidget);
    });
    
    testWidgets('Sign out works correctly', (WidgetTester tester) async {
      // Start the app (assuming already signed in from previous test)
      app.main();
      await tester.pumpAndSettle();
      
      // Open the drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();
      
      // Find and tap the sign out button
      await tester.dragUntilVisible(
        find.text('Sign Out'),
        find.byType(ListView),
        const Offset(0, 50),
      );
      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();
      
      // Confirm sign out in dialog
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      
      // We should be back at the landing page
      expect(find.text('Dhenu'), findsOneWidget);
    });
  });
}