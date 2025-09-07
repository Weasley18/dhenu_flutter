import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

/// Simple user model to replace Firebase User
class DhenuUser {
  final String uid;
  final String email;
  final String? displayName;

  DhenuUser({
    required this.uid,
    required this.email,
    this.displayName,
  });
}

/// Credentials returned on successful auth operations
class UserCredential {
  final DhenuUser user;
  
  UserCredential({required this.user});
}

/// Authentication exception to replace FirebaseAuthException
class AuthException implements Exception {
  final String code;
  final String message;
  
  AuthException({required this.code, required this.message});
}

/// Local authentication service to replace FirebaseAuthService
class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  DhenuUser? _currentUser;
  final StreamController<DhenuUser?> _authStateController = StreamController<DhenuUser?>.broadcast();

  /// Get the current user
  DhenuUser? get currentUser => _currentUser;
  
  /// Stream of authentication state changes
  Stream<DhenuUser?> get authStateChanges => _authStateController.stream;
  
  /// Initialize the auth service by checking for stored credentials
  Future<void> initialize() async {
    try {
      final storedEmail = await _secureStorage.read(key: 'user_email');
      final storedUid = await _secureStorage.read(key: 'user_uid');
      final storedName = await _secureStorage.read(key: 'user_name');
      
      if (storedEmail != null && storedUid != null) {
        _currentUser = DhenuUser(
          uid: storedUid,
          email: storedEmail,
          displayName: storedName,
        );
        _authStateController.add(_currentUser);
      } else {
        _authStateController.add(null);
      }
    } catch (e) {
      debugPrint("[Error initializing auth] ==> $e");
      _authStateController.add(null);
    }
  }

  /// Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Get stored password for this email
      final storedPassword = await _secureStorage.read(key: 'password_$email');
      final storedUid = await _secureStorage.read(key: 'uid_$email');
      final storedName = await _secureStorage.read(key: 'name_$email');
      
      // Validate credentials
      if (storedPassword == null || storedUid == null) {
        throw AuthException(
          code: 'user-not-found',
          message: 'No user found with this email address',
        );
      }
      
      if (storedPassword != password) {
        throw AuthException(
          code: 'wrong-password',
          message: 'Incorrect password',
        );
      }
      
      // Create user object
      _currentUser = DhenuUser(
        uid: storedUid,
        email: email,
        displayName: storedName,
      );
      
      // Save current user session
      await _secureStorage.write(key: 'user_email', value: email);
      await _secureStorage.write(key: 'user_uid', value: storedUid);
      if (storedName != null) {
        await _secureStorage.write(key: 'user_name', value: storedName);
      }
      
      // Notify listeners
      _authStateController.add(_currentUser);
      
      return UserCredential(user: _currentUser!);
    } catch (e) {
      debugPrint("[Error logging in] ==> $e");
      rethrow;
    }
  }
  
  /// Create a new user account
  Future<UserCredential> register(
    String email,
    String password,
    String? name,
  ) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Check if email already exists
      final existingPassword = await _secureStorage.read(key: 'password_$email');
      if (existingPassword != null) {
        throw AuthException(
          code: 'email-already-in-use',
          message: 'An account with this email already exists',
        );
      }
      
      // Validate password strength
      if (password.length < 6) {
        throw AuthException(
          code: 'weak-password',
          message: 'Password must be at least 6 characters',
        );
      }
      
      // Generate a unique ID
      final uid = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Store user credentials
      await _secureStorage.write(key: 'password_$email', value: password);
      await _secureStorage.write(key: 'uid_$email', value: uid);
      if (name != null && name.isNotEmpty) {
        await _secureStorage.write(key: 'name_$email', value: name);
      }
      
      // Create and store current user
      _currentUser = DhenuUser(
        uid: uid,
        email: email,
        displayName: name,
      );
      
      // Save current user session
      await _secureStorage.write(key: 'user_email', value: email);
      await _secureStorage.write(key: 'user_uid', value: uid);
      if (name != null && name.isNotEmpty) {
        await _secureStorage.write(key: 'user_name', value: name);
      }
      
      // Notify listeners
      _authStateController.add(_currentUser);
      
      return UserCredential(user: _currentUser!);
    } catch (e) {
      debugPrint("[Error registering] ==> $e");
      rethrow;
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    try {
      _currentUser = null;
      await _secureStorage.delete(key: 'user_email');
      await _secureStorage.delete(key: 'user_uid');
      await _secureStorage.delete(key: 'user_name');
      _authStateController.add(null);
    } catch (e) {
      debugPrint("[Error signing out] ==> $e");
      rethrow;
    }
  }
  
  /// Store user role in secure storage
  Future<void> storeUserRole(String userId, String role) async {
    try {
      await _secureStorage.write(key: 'user_role_$userId', value: role);
    } catch (e) {
      debugPrint("[Error storing user role] ==> $e");
      rethrow;
    }
  }
  
  /// Get user role from secure storage
  Future<String?> getUserRole(String userId) async {
    try {
      return await _secureStorage.read(key: 'user_role_$userId');
    } catch (e) {
      debugPrint("[Error getting user role] ==> $e");
      return null;
    }
  }
}
