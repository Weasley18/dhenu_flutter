import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

// Import screen components
import '../features/dashboard/dashboard_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/forum/forum_screen.dart';
import '../features/network/network_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/help/help_screen.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Page Not Found')));
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
            const Text('Welcome to Dhenu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            _buildDrawerItem(context, 'Settings', '/settings', location),
            _buildDrawerItem(context, 'Help', '/help', location),
          ],
        ),
      ),
      body: child,
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, String route,
      String currentLocation) {
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

          // Other basic app routes
          GoRoute(
            path: '/forum',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ForumScreen(),
            ),
          ),
          GoRoute(
            path: '/network',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: NetworkScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/help',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: HelpScreen(),
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
