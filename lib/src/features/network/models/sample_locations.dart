import 'location_data.dart';

/// Sample location data for testing the network map when the API is not available
final List<Map<String, dynamic>> sampleLocationsData = [
  {
    'id': 'loc-1',
    'name': 'Shri Krishna Gaushala',
    'address': 'Mathura, Uttar Pradesh',
    'latitude': 27.4924,
    'longitude': 77.6737,
    'type': 'gaushala',
    'phone': '9876543210',
    'userId': 'user-123',
  },
  {
    'id': 'loc-2',
    'name': 'Kamdhenu Farm',
    'address': 'Vrindavan, Uttar Pradesh',
    'latitude': 27.5795,
    'longitude': 77.7030,
    'type': 'farm',
    'phone': '9876543211',
    'userId': 'user-123',
  },
  {
    'id': 'loc-3',
    'name': 'Dr. Verma\'s Veterinary Clinic',
    'address': 'Agra, Uttar Pradesh',
    'latitude': 27.1767,
    'longitude': 78.0081,
    'type': 'vet',
    'phone': '9876543212',
    'userId': 'user-124',
  },
  {
    'id': 'loc-4',
    'name': 'Rural Dairy Cooperative',
    'address': 'Faridabad, Haryana',
    'latitude': 28.4089,
    'longitude': 77.3178,
    'type': 'dairy',
    'phone': '9876543213',
    'userId': 'user-125',
  },
  {
    'id': 'loc-5',
    'name': 'Govansh Raksha Kendra',
    'address': 'Jaipur, Rajasthan',
    'latitude': 26.9124,
    'longitude': 75.7873,
    'type': 'gaushala',
    'phone': '9876543214',
    'userId': 'user-126',
  },
];

/// Convert the sample data to LocationData objects
List<LocationData> getSampleLocations() {
  return sampleLocationsData.map((map) => 
    LocationData(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String?,
      phone: map['phone'] as String?,
      userId: map['userId'] as String,
      imageUrl: map['imageUrl'] as String?,
      rating: map['rating'] as double?,
      reviewCount: map['reviewCount'] as int?,
    )
  ).toList();
}