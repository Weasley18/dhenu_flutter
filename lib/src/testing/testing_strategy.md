# Dhenu Flutter App Testing Strategy

This document outlines the testing strategy for the Dhenu Flutter application, covering unit tests, widget tests, and integration tests.

## 1. Unit Tests

### Purpose
Unit tests verify that individual units of code (typically functions and classes) work as expected in isolation from the rest of the application.

### What to Test
- **Models**: Ensure model classes correctly parse data and provide expected behavior
- **Providers**: Test provider logic and state management
- **Repositories**: Verify data access and manipulation logic
- **Utilities**: Test helper functions and utility classes

### Testing Tools
- `flutter_test` package
- `mockito` or `mocktail` for mocking dependencies

### Example Test Cases

#### Model Tests
```dart
// Test for Product model in test/models/product_test.dart
void main() {
  group('Product Model', () {
    test('should create Product from map correctly', () {
      // Arrange
      final Map<String, dynamic> productMap = {
        'name': 'Test Product',
        'category': 'Test Category',
        'enquiries': 5,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
        'userId': 'user123',
      };
      
      // Act
      final product = Product.fromMap(productMap, 'product123');
      
      // Assert
      expect(product.id, equals('product123'));
      expect(product.name, equals('Test Product'));
      expect(product.category, equals('Test Category'));
      expect(product.enquiries, equals(5));
      expect(product.userId, equals('user123'));
    });
    
    test('should convert Product to map correctly', () {
      // Arrange
      final DateTime createdAt = DateTime(2023, 1, 1);
      final product = Product(
        id: 'product123',
        name: 'Test Product',
        category: 'Test Category',
        enquiries: 5,
        createdAt: createdAt,
        userId: 'user123',
      );
      
      // Act
      final productMap = product.toMap();
      
      // Assert
      expect(productMap['name'], equals('Test Product'));
      expect(productMap['category'], equals('Test Category'));
      expect(productMap['enquiries'], equals(5));
      expect(productMap['createdAt'], equals(Timestamp.fromDate(createdAt)));
      expect(productMap['userId'], equals('user123'));
    });
  });
}
```

#### Repository Tests
```dart
// Test for MarketplaceRepository in test/repositories/marketplace_repository_test.dart
@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, QuerySnapshot, DocumentSnapshot])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MarketplaceRepository repository;
  
  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    repository = MarketplaceRepository(apiUrl: 'test-url', firestore: mockFirestore);
  });
  
  group('fetchProducts', () {
    test('should return list of products when successful', () async {
      // Set up mocks...
      // Arrange your test...
      // Act
      final products = await repository.fetchProducts();
      // Assert...
    });
    
    test('should return empty list when error occurs', () async {
      // Test error case...
    });
  });
}
```

## 2. Widget Tests

### Purpose
Widget tests verify that UI components render correctly and respond appropriately to user interactions.

### What to Test
- **Screens**: Test that screens render correctly with different data states
- **Widgets**: Verify custom widgets behave as expected
- **Forms**: Test form validation and submission
- **Navigation**: Ensure navigation works as expected

### Testing Tools
- `flutter_test` package
- `network_image_mock` for testing widgets with network images

### Example Test Cases

```dart
// Test for ProductCard widget in test/widgets/product_card_test.dart
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
    await tester.tap(find.byType(ProductCard));
    expect(tapped, isTrue);
  });
}
```

## 3. Integration Tests

### Purpose
Integration tests verify that multiple parts of the application work together correctly and that the application meets its requirements.

### What to Test
- **User Flows**: Test complete user journeys through the app
- **API Integration**: Verify interactions with backend services
- **Firebase Integration**: Test Firebase authentication and data storage
- **Performance**: Measure app performance under various conditions

### Testing Tools
- `integration_test` package
- Firebase Emulator Suite for testing Firebase interactions

### Example Test Cases

```dart
// Test for authentication flow in integration_test/auth_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete sign-in flow works correctly', (WidgetTester tester) async {
    // Start the app
    await tester.pumpWidget(const DhenuApp());
    await tester.pumpAndSettle();
    
    // Navigate to sign-in screen
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    // Enter credentials
    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    
    // Submit form
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    
    // Verify user is signed in and redirected to dashboard
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
```

## 4. Testing Pyramid Strategy

Implement testing according to the Testing Pyramid approach:
1. **Many Unit Tests**: Cover all business logic and data layers
2. **Some Widget Tests**: Cover key UI components and interactions
3. **Few Integration Tests**: Cover critical user flows

### Test Coverage Goals
- **Unit Tests**: 80% coverage for models, repositories, and utilities
- **Widget Tests**: Cover all reusable widgets and critical screens
- **Integration Tests**: Cover main user journeys (authentication, cow management, marketplace)

## 5. Continuous Integration Setup

### CI Pipeline Tasks
1. Run static analysis with Flutter Analyze
2. Run unit and widget tests
3. Build the app for both Android and iOS
4. Run integration tests on Firebase Test Lab

### Recommended CI Tools
- GitHub Actions for CI/CD pipeline
- Firebase Test Lab for device testing
- Codecov for tracking test coverage

## 6. Test Documentation

### Requirements
- All test files should include documentation explaining what they're testing and why
- Test files should be organized in a directory structure that mirrors the project structure
- Each test file should contain multiple test cases grouped logically

## 7. Test Implementation Plan

### Phase 1
1. Set up test environment and configurations
2. Implement core model unit tests
3. Create widget tests for common components

### Phase 2
1. Implement repository and provider unit tests
2. Create widget tests for main screens
3. Set up CI pipeline for automated testing

### Phase 3
1. Implement integration tests for critical user flows
2. Set up device testing with Firebase Test Lab
3. Optimize test performance and coverage

## Conclusion

This testing strategy ensures comprehensive test coverage across the Dhenu Flutter application, from individual components to complete user flows. Following this strategy will lead to a more reliable and maintainable application.
