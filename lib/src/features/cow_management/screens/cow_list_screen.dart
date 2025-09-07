import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cow_providers.dart';
import '../widgets/cow_list_item.dart';

class CowListScreen extends ConsumerWidget {
  const CowListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cowsAsyncValue = ref.watch(userCowsProvider);
    final searchQuery = ref.watch(cowSearchQueryProvider);
    
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search cows...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                ref.read(cowSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          
          // Breed Filter Dropdown
          _buildBreedFilter(ref),
          
          // Cows List
          Expanded(
            child: cowsAsyncValue.when(
              data: (cows) {
                final filteredCows = ref.watch(filteredCowsProvider);
                
                if (filteredCows.isEmpty) {
                  return _buildEmptyState(context);
                }
                
                return RefreshIndicator(
                  onRefresh: () => ref.refresh(userCowsProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemCount: filteredCows.length,
                    itemBuilder: (context, index) {
                      final cow = filteredCows[index];
                      return CowListItem(
                        cow: cow,
                        onTap: () {
                          ref.read(selectedCowIdProvider.notifier).state = cow.id;
                          context.go('/cow-profile/${cow.id}');
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Error loading cows: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-cow'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBreedFilter(WidgetRef ref) {
    final breeds = ref.watch(breedListProvider);
    final selectedBreed = ref.watch(selectedBreedFilterProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButtonFormField<String?>(
        decoration: const InputDecoration(
          labelText: 'Filter by breed',
          border: OutlineInputBorder(),
        ),
        value: selectedBreed,
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('All Breeds'),
          ),
          ...breeds.map((breed) => DropdownMenuItem<String?>(
            value: breed,
            child: Text(breed),
          )),
        ],
        onChanged: (value) {
          ref.read(selectedBreedFilterProvider.notifier).state = value;
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No cows found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add a cow to start managing your herd',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/add-cow'),
            icon: const Icon(Icons.add),
            label: const Text('Add Cow'),
          ),
        ],
      ),
    );
  }
}
