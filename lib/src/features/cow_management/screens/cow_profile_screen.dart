import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/cow.dart';
import '../providers/cow_providers.dart';

class CowProfileScreen extends ConsumerWidget {
  final String cowId;
  
  const CowProfileScreen({
    super.key,
    required this.cowId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cowAsync = ref.watch(cowProvider(cowId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cow Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _navigateToEditCow(context, cowId),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, ref, cowId),
          ),
        ],
      ),
      body: cowAsync.when(
        data: (cow) {
          if (cow == null) {
            return const Center(child: Text('Cow not found'));
          }
          
          return _buildCowProfile(context, cow);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildCowProfile(BuildContext context, Cow cow) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMMM d, yyyy');
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image
          _buildProfileHeader(context, cow),
          const SizedBox(height: 24),
          
          // Cow Details Section
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cow Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildDetailRow('Breed', cow.breed),
                  _buildDetailRow('Age', cow.ageDisplay),
                  _buildDetailRow('Birth Date', dateFormat.format(cow.birthDate)),
                  if (cow.tagNumber != null && cow.tagNumber!.isNotEmpty)
                    _buildDetailRow('Tag Number', cow.tagNumber!),
                  if (cow.milkProduction != null)
                    _buildDetailRow('Daily Milk Yield', '${cow.milkProduction} liters'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Notes Section
          if (cow.notes != null && cow.notes!.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Text(cow.notes ?? ''),
                  ],
                ),
              ),
            ),
          
          // Timestamp info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Text(
                  'Added on: ${dateFormat.format(cow.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                if (cow.updatedAt != cow.createdAt)
                  Text(
                    'Last updated: ${dateFormat.format(cow.updatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Cow cow) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        children: [
          // Cow Image
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: cow.imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      cow.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.pets,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : Icon(
                    Icons.pets,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
          ),
          const SizedBox(height: 16),
          
          // Cow Name
          Text(
            cow.name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditCow(BuildContext context, String cowId) {
    context.go('/edit-cow/$cowId');
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, String cowId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cow'),
        content: const Text('Are you sure you want to delete this cow? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(cowRepositoryProvider).deleteCow(cowId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cow deleted successfully')),
                  );
                  context.go('/dashboard');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete cow: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
