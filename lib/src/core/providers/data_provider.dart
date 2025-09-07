import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/static_data_service.dart';

/// Provider for cows data
final cowsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return StaticDataService.getCows();
});

/// Provider for products data
final productsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return StaticDataService.getProducts();
});

/// Provider for forum posts data
final postsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return StaticDataService.getPosts();
});

/// Provider for user profile data
final userProfileProvider = Provider<Map<String, dynamic>>((ref) {
  return StaticDataService.getUserProfile();
});

/// Provider for network farmers data
final networkFarmersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return StaticDataService.getNetworkFarmers();
});

/// Provider for stray cows data
final strayCowsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return StaticDataService.getStrayCows();
});
