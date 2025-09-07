import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_data.dart';
import '../services/network_service.dart';
import '../models/sample_locations.dart';

/// Provider for the network service
final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    googleMapsApiKey: 'YOUR_GOOGLE_MAPS_API_KEY', // Replace with your Google Maps API key
  );
});

/// Provider for user's current position
final currentPositionProvider = FutureProvider<Position>((ref) async {
  // Get current location using Geolocator directly
  final permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
  return await Geolocator.getCurrentPosition();
});

/// Provider for the initial map position
final initialCameraPositionProvider = FutureProvider<CameraPosition>((ref) async {
  try {
    final position = await ref.watch(currentPositionProvider.future);
    return CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );
  } catch (e) {
    // Default to a fallback position (Bangalore, India)
    return const CameraPosition(
      target: LatLng(12.9716, 77.5946),
      zoom: 14.0,
    );
  }
});

/// Provider for locations data
final locationsProvider = FutureProvider<List<LocationData>>((ref) async {
  try {
    final networkService = ref.watch(networkServiceProvider);
    // Use nearby locations method instead of removed fetchLocationsWithRoles
    final currentPosition = await ref.watch(currentPositionProvider.future);
    return await networkService.getNearbyLocations(
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
    );
  } catch (e) {
    // Fallback to sample locations
    return getSampleLocations();
  }
});

/// Provider for the selected location
final selectedLocationProvider = StateProvider<LocationData?>((ref) => null);

/// Provider for the search distance filter
final searchDistanceProvider = StateProvider<double?>((ref) => null);

/// Provider for filtered locations
final filteredLocationsProvider = Provider<List<LocationData>>((ref) {
  final locationsAsync = ref.watch(locationsProvider);
  final searchDistance = ref.watch(searchDistanceProvider);
  final currentPositionAsync = ref.watch(currentPositionProvider);
  
  return locationsAsync.when(
    data: (locations) {
      return currentPositionAsync.when(
        data: (position) {
          final networkService = ref.watch(networkServiceProvider);
          return networkService.filterByDistance(
            locations,
            position.latitude,
            position.longitude,
            searchDistance,
          );
        },
        loading: () => locations,
        error: (_, __) => locations,
      );
    },
    loading: () => [],
    error: (_, __) => [],
  );
});