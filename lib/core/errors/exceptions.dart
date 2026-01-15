class AppException implements Exception {
  final String message;
  final String? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

class FirebaseException extends AppException {
  FirebaseException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class DatabaseException extends AppException {
  DatabaseException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}
