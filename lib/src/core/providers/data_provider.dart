import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mock_data_service.dart';

/// Provider for the mock data service
final mockDataServiceProvider = Provider<MockDataService>((ref) {
  final service = MockDataService();
  
  // Seed the service with some initial data
  _seedMockData(service);
  
  // Dispose the service when the provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Seed the mock data service with initial data
void _seedMockData(MockDataService service) {
  // Add some sample users
  service.addDocument('users', {
    'name': 'John Doe',
    'email': 'john@example.com',
    'role': 'Farmer',
  });
  
  service.addDocument('users', {
    'name': 'Jane Smith',
    'email': 'jane@example.com',
    'role': 'Gaushala Owner',
  });
  
  // Add some sample cows
  service.addDocument('cows', {
    'name': 'Lakshmi',
    'breed': 'Gir',
    'age': 5,
    'weight': 450,
    'milkYield': 15,
    'userId': '1',
    'createdAt': DateTime.now().toIso8601String(),
  });
  
  service.addDocument('cows', {
    'name': 'Nandini',
    'breed': 'Sahiwal',
    'age': 3,
    'weight': 380,
    'milkYield': 12,
    'userId': '1',
    'createdAt': DateTime.now().toIso8601String(),
  });
  
  // Add some sample products
  service.addDocument('products', {
    'name': 'Organic Cow Milk',
    'category': 'Dairy',
    'description': 'Fresh organic milk from grass-fed cows',
    'location': 'Bangalore Rural',
    'enquiries': 5,
    'userId': '1',
    'createdAt': DateTime.now().toIso8601String(),
  });
  
  service.addDocument('products', {
    'name': 'Cow Dung Cakes',
    'category': 'Other',
    'description': 'Traditional cow dung cakes for rituals and fuel',
    'location': 'Mysore',
    'enquiries': 3,
    'userId': '2',
    'createdAt': DateTime.now().toIso8601String(),
  });
  
  // Add some sample forum posts
  service.addDocument('posts', {
    'title': 'Best practices for cow health',
    'content': 'I wanted to share some tips for maintaining cow health...',
    'authorId': '1',
    'authorName': 'John Doe',
    'likes': 12,
    'dislikes': 2,
    'createdAt': DateTime.now().toIso8601String(),
    'replies': [],
  });
  
  service.addDocument('posts', {
    'title': 'Seeking advice on feed supplements',
    'content': 'Has anyone tried these new feed supplements?',
    'authorId': '2',
    'authorName': 'Jane Smith',
    'likes': 8,
    'dislikes': 0,
    'createdAt': DateTime.now().toIso8601String(),
    'replies': [
      {
        'authorId': '1',
        'authorName': 'John Doe',
        'content': 'Yes, I\'ve tried them and they work well!',
        'createdAt': DateTime.now().toIso8601String(),
      }
    ],
  });
}
