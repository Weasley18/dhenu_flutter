/// Model for location data 
class LocationData {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String? address;
  final String? phone;
  final String userId;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final double? distanceKm;
  
  LocationData({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.address,
    this.phone,
    required this.userId,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.distanceKm,
  });
  
  /// Create a copy with distance
  LocationData copyWithDistance(double distance) {
    return LocationData(
      id: id,
      name: name,
      type: type,
      latitude: latitude,
      longitude: longitude,
      address: address,
      phone: phone,
      userId: userId,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      distanceKm: distance,
    );
  }
}