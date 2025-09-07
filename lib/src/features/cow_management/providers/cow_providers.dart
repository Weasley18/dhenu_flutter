import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cow.dart' as model;
import '../repositories/cow_repository.dart';
import '../../auth/providers/auth_provider.dart';

/// Provider for the CowRepository
final cowRepositoryProvider = Provider<CowRepository>((ref) {
  final mockDataService = ref.watch(mockDataServiceProvider);
  return CowRepository(mockDataService);
});

/// Mock data service provider
final mockDataServiceProvider = Provider<dynamic>((ref) {
  // This would normally be injected
  return null;
});

/// Provider for the list of cows owned by the current user
final userCowsProvider = StreamProvider<List<model.Cow>>((ref) {
  final userId = ref.watch(currentUserProvider)?.uid;
  final cowRepository = ref.watch(cowRepositoryProvider);
  
  if (userId == null) {
    return Stream.value([]);
  }
  
  return cowRepository.getCowsForUser(userId).map((docsList) {
    return docsList.map((doc) {
      // Add id to the map if it's not already there
      final Map<String, dynamic> docWithId = Map<String, dynamic>.from(doc);
      final id = docWithId['id'] ?? '';
      return model.Cow.fromMap(docWithId, id);
    }).toList();
  });
});

/// Provider for a specific cow by ID
final cowProvider = StreamProvider.family<model.Cow?, String>((ref, cowId) {
  final cowRepository = ref.watch(cowRepositoryProvider);
  return cowRepository.getCowById(cowId).map((doc) {
    if (doc == null) return null;
    final Map<String, dynamic> docWithId = Map<String, dynamic>.from(doc);
    return model.Cow.fromMap(docWithId, cowId);
  });
});

/// Provider for selected cow ID
final selectedCowIdProvider = StateProvider<String?>((ref) => null);

/// Provider for filtered cows (search or filter)
final filteredCowsProvider = Provider<List<model.Cow>>((ref) {
  final cows = ref.watch(userCowsProvider);
  final searchQuery = ref.watch(cowSearchQueryProvider);
  final selectedBreed = ref.watch(selectedBreedFilterProvider);
  
  return cows.when(
    data: (cowList) {
      if (searchQuery.isEmpty && selectedBreed == null) {
        return cowList;
      }
      
      return cowList.where((cow) {
        final matchesSearch = searchQuery.isEmpty ||
            cow.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesBreed = selectedBreed == null ||
            cow.breed.toLowerCase() == selectedBreed.toLowerCase();
        
        return matchesSearch && matchesBreed;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for the search query
final cowSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for the selected breed filter
final selectedBreedFilterProvider = StateProvider<String?>((ref) => null);

/// Provider for the list of unique breeds from cows
final breedListProvider = Provider<List<String>>((ref) {
  final cows = ref.watch(userCowsProvider);
  
  return cows.when(
    data: (cowList) {
      final breeds = cowList.map((cow) => cow.breed).toSet().toList();
      breeds.sort();
      return breeds;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});