import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;

  const Failure({required this.message, this.code, this.originalError});

  @override
  List<Object?> get props => [message, code];
}

/// Server/API related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Network connectivity failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Cache/Storage failures
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code, super.originalError});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password.',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthFailure.userNotFound() => const AuthFailure(
    message: 'No account found with this email.',
    code: 'USER_NOT_FOUND',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    message: 'An account already exists with this email.',
    code: 'EMAIL_IN_USE',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    message: 'Password is too weak. Use at least 8 characters.',
    code: 'WEAK_PASSWORD',
  );

  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: 'Your session has expired. Please sign in again.',
    code: 'SESSION_EXPIRED',
  );
}

/// AI/Gemini API failures
class AIFailure extends Failure {
  const AIFailure({required super.message, super.code, super.originalError});

  factory AIFailure.rateLimited() => const AIFailure(
    message: 'Too many requests. Please try again in a moment.',
    code: 'RATE_LIMITED',
  );

  factory AIFailure.invalidResponse() => const AIFailure(
    message: 'Received an invalid response from AI service.',
    code: 'INVALID_RESPONSE',
  );

  factory AIFailure.contentFiltered() => const AIFailure(
    message: 'The content was filtered for safety reasons.',
    code: 'CONTENT_FILTERED',
  );
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
  });
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code = 'PERMISSION_DENIED',
    super.originalError,
  });
}
