/// Constants for route paths in the app
class AppRoutes {
  // Core routes
  static const String landing = '/';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  
  // Cow management
  static const String cowList = '/cow-list';
  static const String addCow = '/add-cow';
  static const String cowProfile = '/cow-profile/:id';
  static String cowProfilePath(String id) => '/cow-profile/$id';
  
  // Marketplace
  static const String marketplace = '/marketplace';
  static const String addProduct = '/add-product';
  static const String productDetails = '/product-details/:id';
  static String productDetailsPath(String id) => '/product-details/$id';
  
  // Community
  static const String forum = '/forum';
  
  // Location & Network
  static const String network = '/network';
  static const String strayCows = '/stray-cows';
  
  // AI & ML
  static const String crossBreeding = '/cross-breeding';
  static const String chatbot = '/chatbot';
  
  // Settings
  static const String settings = '/settings';
  static const String language = '/language';
}