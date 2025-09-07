import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/providers/data_provider.dart';

/// Provider for the cow repository
final cowRepositoryProvider = Provider<CowRepository>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return CowRepository(mockDataService);
});

/// Repository for cow management
class CowRepository {
  final MockDataService _dataService;

  CowRepository(this._dataService);

  /// Get all cows for a user
  Stream<List<Map<String, dynamic>>> getCowsForUser(String userId) {
    return _dataService.queryCollection(
      'cows',
      where: (doc) => doc['userId'] == userId,
    );
  }

  /// Get a cow by ID
  Stream<Map<String, dynamic>?> getCowById(String cowId) {
    return _dataService.getCollection('cows').map((docs) {
      try {
        return docs.firstWhere((doc) => doc['id'] == cowId);
      } catch (e) {
        return null;
      }
    });
  }

  /// Add a new cow
  Future<String> addCow(Map<String, dynamic> cow) async {
    return await _dataService.addDocument('cows', cow);
  }

  /// Update an existing cow
  Future<void> updateCow(String cowId, Map<String, dynamic> cow) async {
    await _dataService.updateDocument('cows', cowId, cow);
  }

  /// Delete a cow
  Future<void> deleteCow(String cowId) async {
    await _dataService.deleteDocument('cows', cowId);
  }
}