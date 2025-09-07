import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/network_providers.dart';

class SearchOptionsBar extends ConsumerWidget {
  const SearchOptionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchDistance = ref.watch(searchDistanceProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by distance:',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDistanceOption(
                  context, 
                  ref, 
                  label: 'Within 10 km',
                  distance: 10.0,
                  isSelected: searchDistance == 10.0,
                ),
                _buildDistanceOption(
                  context, 
                  ref, 
                  label: 'Within 15 km',
                  distance: 15.0,
                  isSelected: searchDistance == 15.0,
                ),
                _buildDistanceOption(
                  context, 
                  ref, 
                  label: 'Within 20 km',
                  distance: 20.0,
                  isSelected: searchDistance == 20.0,
                ),
                _buildDistanceOption(
                  context, 
                  ref, 
                  label: 'All',
                  distance: null,
                  isSelected: searchDistance == null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceOption(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required double? distance,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(searchDistanceProvider.notifier).state = distance;
        },
        backgroundColor: theme.colorScheme.surface,
        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
        checkmarkColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
