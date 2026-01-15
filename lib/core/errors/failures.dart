abstract class Failure {
  final String message;
  final String? code;

  Failure({required this.message, this.code});
}

class FirebaseFailure extends Failure {
  FirebaseFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  NetworkFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class DatabaseFailure extends Failure {
  DatabaseFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class AuthFailure extends Failure {
  AuthFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  ValidationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  UnknownFailure()
      : super(message: 'An unknown error occurred');
}
