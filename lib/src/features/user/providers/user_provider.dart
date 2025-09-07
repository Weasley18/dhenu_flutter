import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user.dart';

/// Provider for the current user
final currentUserProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

/// Notifier for managing the current user
class UserNotifier extends StateNotifier<User?> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  UserNotifier() : super(null) {
    _loadUser();
  }

  /// Load the user from secure storage
  Future<void> _loadUser() async {
    try {
      final userJson = await _storage.read(key: 'user');
      if (userJson != null) {
        final userData = jsonDecode(userJson) as Map<String, dynamic>;
        state = User.fromMap(userData);
      }
    } catch (e) {
      // Handle error loading user
      print('Error loading user: $e');
    }
  }

  /// Sign in a user (mock implementation)
  Future<bool> signIn(String email, String password) async {
    try {
      // In a real app, this would validate credentials against a backend
      // For now, we'll create a mock user
      final user = User(
        id: '123',
        name: 'Test User',
        email: email,
        role: 'Farmer',
      );
      
      // Save user to secure storage
      await _storage.write(key: 'user', value: jsonEncode(user.toMap()));
      
      // Update state
      state = user;
      return true;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _storage.delete(key: 'user');
      state = null;
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  /// Update the current user's profile
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    if (state == null) return;
    
    try {
      final updatedUser = state!.copyWith(
        name: name,
        photoUrl: photoUrl,
      );
      
      await _storage.write(key: 'user', value: jsonEncode(updatedUser.toMap()));
      state = updatedUser;
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
