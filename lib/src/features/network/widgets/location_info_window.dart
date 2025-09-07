import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location_data.dart';
import '../providers/network_providers.dart';

class LocationInfoWindow extends ConsumerWidget {
  final LocationData location;
  final VoidCallback onDirectionsTap;
  final VoidCallback onContactTap;
  final VoidCallback onCloseTap;
  
  const LocationInfoWindow({
    super.key,
    required this.location,
    required this.onDirectionsTap,
    required this.onContactTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            _buildHeader(theme),
            
            // Content padding
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location image if available
                  if (location.imageUrl != null) ...[
                    Container(
                      height: 140,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(location.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  
                  // Location name
                  Text(
                    location.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Location address
                  if (location.address != null) 
                    Text(
                      location.address!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Distance information
                  if (location.distanceKm != null)
                    Text(
                      '${location.distanceKm!.toStringAsFixed(2)} km away',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Directions button
                      TextButton.icon(
                        onPressed: onDirectionsTap,
                        icon: Icon(
                          Icons.directions,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'Directions',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      
                      // Contact button
                      TextButton.icon(
                        onPressed: onContactTap,
                        icon: Icon(
                          Icons.phone,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          'Contact',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _getIconForLocationType(location.type),
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                location.type,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onCloseTap,
            icon: const Icon(Icons.close),
            iconSize: 18,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForLocationType(String type) {
    switch (type.toLowerCase()) {
      case 'farm':
        return Icons.agriculture;
      case 'gaushala':
        return Icons.pets;
      case 'veterinary':
        return Icons.local_hospital;
      case 'dairy':
        return Icons.local_drink;
      default:
        return Icons.place;
    }
  }
}