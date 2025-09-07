import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/providers/data_provider.dart';
import '../models/product.dart';

/// Provider for the marketplace repository
final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return MarketplaceRepository(mockDataService);
});

/// Repository for marketplace operations
class MarketplaceRepository {
  final MockDataService _dataService;

  MarketplaceRepository(this._dataService);

  /// Get all products
  Future<List<Product>> fetchProducts() async {
    final docs = await _dataService.getCollection('products').first;
    return docs.map((doc) {
      final docWithId = Map<String, dynamic>.from(doc);
      return Product.fromMap(docWithId, docWithId['id'] ?? '');
    }).toList();
  }

  /// Get a product by ID
  Future<Product?> fetchProductById(String productId) async {
    try {
      final docs = await _dataService.getCollection('products').first;
      final doc = docs.firstWhere((doc) => doc['id'] == productId);
      return Product.fromMap(doc, productId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new product
  Future<String> addProduct(Product product) async {
    return await _dataService.addDocument('products', product.toMap());
  }

  /// Update an existing product
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _dataService.updateDocument('products', productId, data);
  }

  /// Delete a product
  Future<void> deleteProduct(String productId) async {
    await _dataService.deleteDocument('products', productId);
  }

  /// Add an enquiry to a product
  Future<void> addEnquiryToProduct(String productId, Enquiry enquiry) async {
    // Get the current product
    final docs = await _dataService.getCollection('products').first;
    final productDoc = docs.firstWhere((doc) => doc['id'] == productId);
    
    if (productDoc == null) {
      throw Exception('Product not found');
    }
    
    // Get current enquiries or initialize empty list
    List<Map<String, dynamic>> enquiries = [];
    if (productDoc.containsKey('enquiryList')) {
      enquiries = List<Map<String, dynamic>>.from(productDoc['enquiryList']);
    }
    
    // Add the new enquiry
    enquiries.add(enquiry.toMap());
    
    // Update the product
    await _dataService.updateDocument('products', productId, {
      'enquiryList': enquiries,
      'enquiries': (productDoc['enquiries'] as int) + 1,
    });
  }

  /// Get seller information for a product
  Future<Seller> fetchSeller(String userId) async {
    // In a real app, this would call an API
    // For now, we'll use the mock data service
    
    try {
      final users = await _dataService.getCollection('users').first;
      final userDoc = users.firstWhere((doc) => doc['id'] == userId);
      
      return Seller(
        displayName: userDoc['name'] as String,
        email: userDoc['email'] as String,
      );
    } catch (e) {
      // Create a mock seller if user not found
      return Seller(
        displayName: 'Demo Seller',
        email: 'seller@example.com',
      );
    }
  }
}