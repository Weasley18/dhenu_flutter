import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/location_data.dart';
import '../models/sample_locations.dart';

/// Service to handle network functionality
class NetworkService {
  final String? googleMapsApiKey;
  
  NetworkService({this.googleMapsApiKey});
  
  /// Get nearby locations from sample data
  Future<List<LocationData>> getNearbyLocations({
    required double latitude,
    required double longitude,
    double? radiusKm,
    String? type,
    String? searchQuery,
  }) async {
    // In a real app, we would make an API call to Google Places or similar service
    // For now, we'll use sample data and filter it based on parameters
    
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    // Get sample locations
    List<LocationData> locations = getSampleLocations();
    
    // Filter by type if specified
    if (type != null && type.isNotEmpty) {
      locations = locations.where((location) {
        return location.type.toLowerCase() == type.toLowerCase();
      }).toList();
    }
    
    // Filter by search query if specified
    if (searchQuery != null && searchQuery.isNotEmpty) {
      locations = locations.where((location) {
        return location.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }
    
    // Calculate distances and filter by radius
    locations = filterByDistance(locations, latitude, longitude, radiusKm);
    
    // Sort by distance
    locations.sort((a, b) => (a.distanceKm ?? double.infinity).compareTo(b.distanceKm ?? double.infinity));
    
    return locations;
  }
  
  /// Get locations by user ID from sample data
  Future<List<LocationData>> getLocationsByUser(String userId) async {
    // In a real app, we would make an API call to a backend server
    // For now, we'll use sample data and filter by user ID
    
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    final allLocations = getSampleLocations();
    return allLocations.where((location) => location.userId == userId).toList();
  }
  
  /// Favorite a location
  Future<bool> favoriteLocation(String locationId, String userId) async {
    // In a real app, we would make an API call to update the database
    // For now, we'll just return success
    
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return true;
  }
  
  /// Unfavorite a location
  Future<bool> unfavoriteLocation(String locationId, String userId) async {
    // In a real app, we would make an API call to update the database
    // For now, we'll just return success
    
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    return true;
  }
  
  /// Get a user's favorite locations
  Future<List<String>> getFavoriteLocationIds(String userId) async {
    // In a real app, we would make an API call to get the user's favorites
    // For now, we'll return a sample list
    
    await Future.delayed(const Duration(milliseconds: 400)); // Simulate network delay
    return ['loc1', 'loc3', 'loc5']; // Sample favorite location IDs
  }

  /// Get a readable address from coordinates using reverse geocoding
  Future<String> getReadableAddress(double latitude, double longitude) async {
    if (googleMapsApiKey == null) {
      return 'Address not available';
    }
    
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$googleMapsApiKey',
        ),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        } else {
          debugPrint('Error with reverse geocoding: ${data['status']}');
          return 'Address not available';
        }
      } else {
        return 'Address not available';
      }
    } catch (e) {
      debugPrint('Error fetching readable address: $e');
      return 'Address not available';
    }
  }
  
  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2,
  ) {
    const double radius = 6371; // Earth's radius in kilometers
    
    // Convert degrees to radians
    final double lat1Rad = lat1 * (pi / 180);
    final double lon1Rad = lon1 * (pi / 180);
    final double lat2Rad = lat2 * (pi / 180);
    final double lon2Rad = lon2 * (pi / 180);
    
    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    
    final double a = 
        (1 - cos(dLat)) / 2 + 
        cos(lat1Rad) * cos(lat2Rad) * (1 - cos(dLon)) / 2;
    final double c = 2 * asin(sqrt(a));
    
    return radius * c;
  }
  
  /// Filter locations by distance from a reference point
  List<LocationData> filterByDistance(
    List<LocationData> locations, 
    double refLat, 
    double refLon, 
    double? maxDistance,
  ) {
    if (maxDistance == null) {
      // No distance filtering, just calculate distances
      return locations.map((location) {
        final distance = calculateDistance(
          refLat, 
          refLon, 
          location.latitude, 
          location.longitude,
        );
        return location.copyWithDistance(distance);
      }).toList();
    }
    
    // Filter by distance and calculate distances
    return locations.map((location) {
      final distance = calculateDistance(
        refLat, 
        refLon, 
        location.latitude, 
        location.longitude,
      );
      return location.copyWithDistance(distance);
    }).where((location) => location.distanceKm! <= maxDistance).toList();
  }
}