import '../../../core/api/auth_service.dart';

/// Converts authentication error codes into user-friendly messages
String getAuthErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'user-not-found':
      return 'No user found with this email address. Please check your email or create a new account.';
    case 'wrong-password':
      return 'Incorrect password. Please try again or use the "Forgot password" option.';
    case 'invalid-email':
      return 'Invalid email address format. Please enter a valid email.';
    case 'email-already-in-use':
      return 'An account with this email already exists. Please sign in or use a different email.';
    case 'weak-password':
      return 'Password is too weak. Please use a stronger password (at least 6 characters).';
    case 'operation-not-allowed':
      return 'This sign-in method is not enabled. Please contact support.';
    case 'invalid-credential':
      return 'The authentication credential is invalid. Please try again.';
    case 'user-disabled':
      return 'This user account has been disabled. Please contact support.';
    case 'too-many-requests':
      return 'Too many unsuccessful login attempts. Please try again later or reset your password.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection and try again.';
    default:
      return 'An unexpected error occurred. Please try again later.';
  }
}

/// Extension method to easily get user-friendly error messages from AuthException
extension AuthExceptionExt on AuthException {
  String get friendlyMessage => getAuthErrorMessage(code);
}