import 'package:flutter_test/flutter_test.dart';
import 'package:dhenu_flutter/src/features/marketplace/models/product.dart';
import 'package:dhenu_flutter/src/core/models/timestamp.dart';

void main() {
  group('Product Model', () {
    test('should create Product from map correctly', () {
      // Arrange
      final createdAtTimestamp = Timestamp.fromDateTime(DateTime(2023, 1, 1));
      final Map<String, dynamic> productMap = {
        'name': 'Test Product',
        'category': 'Test Category',
        'description': 'Test Description',
        'location': 'Test Location',
        'enquiries': 5,
        'createdAt': createdAtTimestamp,
        'userId': 'user123',
        'enquiryList': [],
      };
      
      // Act
      final product = Product.fromMap(productMap, 'product123');
      
      // Assert
      expect(product.id, equals('product123'));
      expect(product.name, equals('Test Product'));
      expect(product.category, equals('Test Category'));
      expect(product.description, equals('Test Description'));
      expect(product.location, equals('Test Location'));
      expect(product.enquiries, equals(5));
      expect(product.userId, equals('user123'));
      expect(product.createdAt.year, equals(2023));
      expect(product.createdAt.month, equals(1));
      expect(product.createdAt.day, equals(1));
      expect(product.enquiryList, isEmpty);
    });
    
    test('should convert Product to map correctly', () {
      // Arrange
      final DateTime createdAt = DateTime(2023, 1, 1);
      final product = Product(
        id: 'product123',
        name: 'Test Product',
        category: 'Test Category',
        description: 'Test Description',
        location: 'Test Location',
        enquiries: 5,
        createdAt: createdAt,
        userId: 'user123',
      );
      
      // Act
      final productMap = product.toMap();
      
      // Assert
      expect(productMap['name'], equals('Test Product'));
      expect(productMap['category'], equals('Test Category'));
      expect(productMap['description'], equals('Test Description'));
      expect(productMap['location'], equals('Test Location'));
      expect(productMap['enquiries'], equals(5));
      expect(productMap['userId'], equals('user123'));
      expect(productMap['enquiryList'], isEmpty);
      
      // Verify the createdAt timestamp
      final timestamp = productMap['createdAt'] as Timestamp;
      expect(timestamp.toDateTime().year, equals(2023));
      expect(timestamp.toDateTime().month, equals(1));
      expect(timestamp.toDateTime().day, equals(1));
    });
    
    test('should create a product with enquiry list', () {
      // Arrange
      final createdAtTimestamp = Timestamp.fromDateTime(DateTime(2023, 1, 1));
      final enquiryCreatedAtStr = '2023-01-02T00:00:00.000';
      final Map<String, dynamic> productMap = {
        'name': 'Test Product',
        'category': 'Test Category',
        'enquiries': 1,
        'createdAt': createdAtTimestamp,
        'userId': 'user123',
        'enquiryList': [
          {
            'name': 'John Doe',
            'contact': '1234567890',
            'message': 'I am interested in this product',
            'createdAt': enquiryCreatedAtStr,
          }
        ],
      };
      
      // Act
      final product = Product.fromMap(productMap, 'product123');
      
      // Assert
      expect(product.enquiryList.length, equals(1));
      expect(product.enquiryList[0].name, equals('John Doe'));
      expect(product.enquiryList[0].contact, equals('1234567890'));
      expect(product.enquiryList[0].message, equals('I am interested in this product'));
      expect(product.enquiryList[0].createdAt.year, equals(2023));
      expect(product.enquiryList[0].createdAt.month, equals(1));
      expect(product.enquiryList[0].createdAt.day, equals(2));
    });
    
    test('should create a copy with updated fields', () {
      // Arrange
      final product = Product(
        id: 'product123',
        name: 'Test Product',
        category: 'Test Category',
        enquiries: 5,
        createdAt: DateTime(2023, 1, 1),
        userId: 'user123',
      );
      
      // Act
      final updatedProduct = product.copyWith(
        name: 'Updated Product',
        enquiries: 10,
      );
      
      // Assert
      expect(updatedProduct.id, equals('product123')); // Unchanged
      expect(updatedProduct.name, equals('Updated Product')); // Changed
      expect(updatedProduct.category, equals('Test Category')); // Unchanged
      expect(updatedProduct.enquiries, equals(10)); // Changed
      expect(updatedProduct.userId, equals('user123')); // Unchanged
    });
  });
  
  group('Enquiry Model', () {
    test('should create Enquiry from map correctly', () {
      // Arrange
      final createdAtStr = '2023-01-01T00:00:00.000';
      final Map<String, dynamic> enquiryMap = {
        'name': 'John Doe',
        'contact': '1234567890',
        'message': 'I am interested in this product',
        'createdAt': createdAtStr,
      };
      
      // Act
      final enquiry = Enquiry.fromMap(enquiryMap);
      
      // Assert
      expect(enquiry.name, equals('John Doe'));
      expect(enquiry.contact, equals('1234567890'));
      expect(enquiry.message, equals('I am interested in this product'));
      expect(enquiry.createdAt.year, equals(2023));
      expect(enquiry.createdAt.month, equals(1));
      expect(enquiry.createdAt.day, equals(1));
    });
    
    test('should convert Enquiry to map correctly', () {
      // Arrange
      final DateTime createdAt = DateTime(2023, 1, 1);
      final enquiry = Enquiry(
        name: 'John Doe',
        contact: '1234567890',
        message: 'I am interested in this product',
        createdAt: createdAt,
      );
      
      // Act
      final enquiryMap = enquiry.toMap();
      
      // Assert
      expect(enquiryMap['name'], equals('John Doe'));
      expect(enquiryMap['contact'], equals('1234567890'));
      expect(enquiryMap['message'], equals('I am interested in this product'));
      expect(enquiryMap['createdAt'], equals(createdAt.toIso8601String()));
    });
    
    test('should handle string ISO date format in fromMap', () {
      // Arrange
      final Map<String, dynamic> enquiryMap = {
        'name': 'John Doe',
        'contact': '1234567890',
        'message': 'I am interested in this product',
        'createdAt': '2023-01-01T00:00:00.000',
      };
      
      // Act
      final enquiry = Enquiry.fromMap(enquiryMap);
      
      // Assert
      expect(enquiry.name, equals('John Doe'));
      expect(enquiry.contact, equals('1234567890'));
      expect(enquiry.message, equals('I am interested in this product'));
      expect(enquiry.createdAt.year, equals(2023));
      expect(enquiry.createdAt.month, equals(1));
      expect(enquiry.createdAt.day, equals(1));
    });
  });
}