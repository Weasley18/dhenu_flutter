import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/auth_service.dart';

/// Provider for the Authentication Service
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Stream provider for authentication state changes
final authStateProvider = StreamProvider<DhenuUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Provider for the current user
final currentUserProvider = Provider<DhenuUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for the user's role
final userRoleProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  
  final authService = ref.watch(authServiceProvider);
  return await authService.getUserRole(user.uid);
});

/// Auth controller notifier to manage authentication actions
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  
  AuthNotifier({required AuthService authService})
      : _authService = authService,
        super(const AsyncValue.data(null));
  
  /// Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.signIn(email, password);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  /// Register a new user
  Future<UserCredential?> register(
    String email,
    String password,
    String? name,
    String role,
  ) async {
    state = const AsyncValue.loading();
    try {
      final result = await _authService.register(email, password, name);
      // Store user role after successful registration
      await _authService.storeUserRole(result.user.uid, role);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

/// Provider for the auth controller
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService: authService);
});