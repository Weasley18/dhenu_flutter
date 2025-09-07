import 'dart:async';
import 'package:flutter/foundation.dart';

/// A service that provides mock data for the application
class MockDataService {
  // In-memory storage for collections
  final Map<String, List<Map<String, dynamic>>> _collections = {};
  
  // Stream controllers for each collection
  final Map<String, StreamController<List<Map<String, dynamic>>>> _controllers = {};

  /// Constructor
  MockDataService() {
    // Initialize with some default collections
    _collections['cows'] = [];
    _collections['products'] = [];
    _collections['posts'] = [];
    _collections['users'] = [];
    
    // Create stream controllers
    _collections.forEach((key, _) {
      _controllers[key] = StreamController<List<Map<String, dynamic>>>.broadcast();
    });
  }

  /// Get a stream of all documents in a collection
  Stream<List<Map<String, dynamic>>> getCollection(String collectionName) {
    if (!_collections.containsKey(collectionName)) {
      _collections[collectionName] = [];
      _controllers[collectionName] = StreamController<List<Map<String, dynamic>>>.broadcast();
    }
    
    // Initial data
    _controllers[collectionName]!.add(_collections[collectionName]!);
    
    return _controllers[collectionName]!.stream;
  }

  /// Get a single document by ID
  Map<String, dynamic>? getDocument(String collectionName, String documentId) {
    if (!_collections.containsKey(collectionName)) {
      return null;
    }
    
    try {
      return _collections[collectionName]!.firstWhere(
        (doc) => doc['id'] == documentId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Add a document to a collection
  Future<String> addDocument(String collectionName, Map<String, dynamic> data) async {
    if (!_collections.containsKey(collectionName)) {
      _collections[collectionName] = [];
      _controllers[collectionName] = StreamController<List<Map<String, dynamic>>>.broadcast();
    }
    
    // Generate a unique ID
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Add ID to the document
    final document = {
      'id': id,
      ...data,
    };
    
    // Add to collection
    _collections[collectionName]!.add(document);
    
    // Notify listeners
    _controllers[collectionName]!.add(_collections[collectionName]!);
    
    return id;
  }

  /// Update a document in a collection
  Future<void> updateDocument(String collectionName, String documentId, Map<String, dynamic> data) async {
    if (!_collections.containsKey(collectionName)) {
      return;
    }
    
    final index = _collections[collectionName]!.indexWhere(
      (doc) => doc['id'] == documentId,
    );
    
    if (index != -1) {
      // Update document
      _collections[collectionName]![index] = {
        'id': documentId,
        ..._collections[collectionName]![index],
        ...data,
      };
      
      // Notify listeners
      _controllers[collectionName]!.add(_collections[collectionName]!);
    }
  }

  /// Delete a document from a collection
  Future<void> deleteDocument(String collectionName, String documentId) async {
    if (!_collections.containsKey(collectionName)) {
      return;
    }
    
    _collections[collectionName]!.removeWhere(
      (doc) => doc['id'] == documentId,
    );
    
    // Notify listeners
    _controllers[collectionName]!.add(_collections[collectionName]!);
  }

  /// Query documents in a collection
  Stream<List<Map<String, dynamic>>> queryCollection(
    String collectionName, {
    required bool Function(Map<String, dynamic>) where,
  }) {
    if (!_collections.containsKey(collectionName)) {
      return Stream.value([]);
    }
    
    final filteredDocs = _collections[collectionName]!.where(where).toList();
    
    // Create a new controller for this query
    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    
    // Add initial data
    controller.add(filteredDocs);
    
    // Listen to changes in the main collection
    _controllers[collectionName]!.stream.listen((allDocs) {
      final newFilteredDocs = allDocs.where(where).toList();
      controller.add(newFilteredDocs);
    });
    
    return controller.stream;
  }

  /// Dispose all stream controllers
  void dispose() {
    _controllers.forEach((_, controller) {
      controller.close();
    });
  }
}
