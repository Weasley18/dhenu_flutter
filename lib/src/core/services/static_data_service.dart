/// A simple service that provides static data for the application
/// without requiring database connections
class StaticDataService {
  /// Get user profile data
  static Map<String, dynamic> getUserProfile() {
    return {
      'name': 'Demo User',
      'email': 'demo@example.com',
      'joinDate': '2023-01-15',
    };
  }

  /// Get forum posts data
  static List<Map<String, dynamic>> getForumPosts() {
    return [
      {
        'id': '1',
        'title': 'Welcome to the Forum',
        'content': 'This is a sample forum post.',
        'authorName': 'Admin',
        'createdAt': '2023-07-15T10:30:00Z',
      },
      {
        'id': '2',
        'title': 'Community Guidelines',
        'content': 'Please be respectful to other community members.',
        'authorName': 'Admin',
        'createdAt': '2023-07-14T08:45:00Z',
      },
    ];
  }

  /// Get forum posts (compatibility with data_provider)
  static List<Map<String, dynamic>> getPosts() {
    return getForumPosts();
  }

  /// Get network connections data
  static List<Map<String, dynamic>> getNetworkConnections() {
    return [
      {
        'id': '1',
        'name': 'John Doe',
        'location': 'Bangalore',
      },
      {
        'id': '2',
        'name': 'Jane Smith',
        'location': 'Mumbai',
      },
    ];
  }

  /// Get network farmers (compatibility with data_provider)
  static List<Map<String, dynamic>> getNetworkFarmers() {
    return getNetworkConnections();
  }

  /// Get placeholder cow data for compatibility
  static List<Map<String, dynamic>> getCows() {
    return [
      {
        'id': '1',
        'name': 'Placeholder Cow 1',
        'breed': 'Placeholder',
      },
      {
        'id': '2',
        'name': 'Placeholder Cow 2',
        'breed': 'Placeholder',
      },
    ];
  }

  /// Get placeholder product data for compatibility
  static List<Map<String, dynamic>> getProducts() {
    return [
      {
        'id': '1',
        'name': 'Placeholder Product 1',
        'category': 'Placeholder',
      },
      {
        'id': '2',
        'name': 'Placeholder Product 2',
        'category': 'Placeholder',
      },
    ];
  }

  /// Get placeholder stray cows data for compatibility
  static List<Map<String, dynamic>> getStrayCows() {
    return [
      {
        'id': '1',
        'location': 'Placeholder Location 1',
      },
      {
        'id': '2',
        'location': 'Placeholder Location 2',
      },
    ];
  }
}
