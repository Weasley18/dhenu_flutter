import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dhenu_flutter/src/features/marketplace/models/product.dart';
import 'package:dhenu_flutter/src/features/marketplace/widgets/product_card.dart';

void main() {
  testWidgets('ProductCard displays product information correctly', (WidgetTester tester) async {
    // Arrange
    final product = Product(
      id: 'product123',
      name: 'Test Product',
      category: 'Test Category',
      enquiries: 5,
      createdAt: DateTime.now(),
      userId: 'user123',
      location: 'Test Location',
    );
    
    bool tapped = false;
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            product: product,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Category'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
    expect(find.text('5 enquiries'), findsOneWidget);
    
    // Test tap interaction
    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });
  
  testWidgets('ProductCard handles null location', (WidgetTester tester) async {
    // Arrange
    final product = Product(
      id: 'product123',
      name: 'Test Product',
      category: 'Test Category',
      enquiries: 0,
      createdAt: DateTime.now(),
      userId: 'user123',
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            product: product,
            onTap: () {},
          ),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Test Category'), findsOneWidget);
    expect(find.text('0 enquiries'), findsOneWidget);
    
    // Location widget should not be present
    expect(find.byIcon(Icons.location_on_outlined), findsNothing);
  });
  
  testWidgets('ProductCard has correct styling', (WidgetTester tester) async {
    // Arrange
    final product = Product(
      id: 'product123',
      name: 'Test Product',
      category: 'Test Category',
      enquiries: 5,
      createdAt: DateTime.now(),
      userId: 'user123',
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.brown,
          ),
        ),
        home: Scaffold(
          body: ProductCard(
            product: product,
            onTap: () {},
          ),
        ),
      ),
    );
    
    // Assert
    final card = tester.widget<Card>(find.byType(Card));
    expect(card.elevation, equals(2));
    
    final shape = card.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, equals(BorderRadius.circular(12)));
    
    // Check for primary color in category chip
    final container = tester.widget<Container>(
      find.ancestor(
        of: find.text('Test Category'),
        matching: find.byType(Container),
      ),
    );
    
    // The container should have a decoration
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.borderRadius, equals(BorderRadius.circular(16)));
    
    // The color should be a variant of the primary color (with opacity)
    final color = decoration.color as Color;
    expect(color.red, equals(Colors.brown.red));
    expect(color.green, equals(Colors.brown.green));
    expect(color.blue, equals(Colors.brown.blue));
    expect(color.opacity, lessThan(1.0)); // It has some opacity
  });
}
