/// Base exception class
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server/API exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });
}

/// Network exceptions
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network connection failed',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// AI service exceptions
class AIException extends AppException {
  const AIException({required super.message, super.code, super.originalError});
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    this.fieldErrors,
  });
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code = 'PERMISSION_DENIED',
    super.originalError,
  });
}
