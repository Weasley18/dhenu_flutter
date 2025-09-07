import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

// Forward declarations for screens (to be implemented)
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Dashboard')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Profile')));
}

class AddCowScreen extends StatelessWidget {
  const AddCowScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Add Cow')));
}

class CowProfileScreen extends StatelessWidget {
  final String cowId;
  const CowProfileScreen({super.key, required this.cowId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Cow Profile: $cowId')));
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Add Product')));
}

class ProductDetailsScreen extends StatelessWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Product Details: $productId')));
}

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Forum')));
}

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Network')));
}

class CrossBreedingScreen extends StatelessWidget {
  const CrossBreedingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Cross Breeding')));
}

class StrayCowsScreen extends StatelessWidget {
  const StrayCowsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Stray Cows')));
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Page Not Found')));
}

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Dhenu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A scaffold with a drawer for navigation
class ScaffoldWithDrawer extends StatelessWidget {
  final Widget child;
  final String location;

  const ScaffoldWithDrawer({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dhenu'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Dhenu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            _buildDrawerItem(context, 'Dashboard', '/dashboard', location),
            _buildDrawerItem(context, 'Profile', '/profile', location),
            _buildDrawerItem(context, 'Forum', '/forum', location),
            _buildDrawerItem(context, 'Network', '/network', location),
            _buildDrawerItem(context, 'Cross Breeding', '/cross-breeding', location),
            _buildDrawerItem(context, 'Stray Cows', '/stray-cows', location),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route, String currentLocation) {
    final isSelected = currentLocation == route;
    
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.brown.withOpacity(0.1) : null,
      onTap: () {
        if (currentLocation != route) {
          Navigator.pop(context); // Close the drawer
          GoRouter.of(context).go(route);
        }
      },
    );
  }
}

/// Provider for the router
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Landing page
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingScreen(),
      ),
      
      // App routes - wrapped in a ShellRoute for the drawer navigation
      ShellRoute(
        builder: (context, state, child) {
          final String currentPath = state.uri.toString();
          return ScaffoldWithDrawer(
            location: currentPath,
            child: child,
          );
        },
        routes: [
          // Dashboard route
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: DashboardScreen(),
            ),
          ),
          
          // Profile route
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProfileScreen(),
            ),
          ),
          
          // Cow management routes
          GoRoute(
            path: '/add-cow',
            builder: (context, state) => const AddCowScreen(),
          ),
          GoRoute(
            path: '/cow-profile/:id',
            builder: (context, state) {
              final cowId = state.pathParameters['id'] ?? '';
              return CowProfileScreen(cowId: cowId);
            },
          ),
          
          // Marketplace routes
          GoRoute(
            path: '/add-product',
            builder: (context, state) => const AddProductScreen(),
          ),
          GoRoute(
            path: '/product-details/:id',
            builder: (context, state) {
              final productId = state.pathParameters['id'] ?? '';
              return ProductDetailsScreen(productId: productId);
            },
          ),
          
          // Other app routes
          GoRoute(
            path: '/forum',
            builder: (context, state) => const ForumScreen(),
          ),
          GoRoute(
            path: '/network',
            builder: (context, state) => const NetworkScreen(),
          ),
          GoRoute(
            path: '/cross-breeding',
            builder: (context, state) => const CrossBreedingScreen(),
          ),
          GoRoute(
            path: '/stray-cows',
            builder: (context, state) => const StrayCowsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});