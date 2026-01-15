import 'package:equatable/equatable.dart';
import 'user_entity.dart';

/// Estado de autenticación de la aplicación.
/// Representa los diferentes estados por los que puede pasar la autenticación.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial: no autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de carga: procesando autenticación
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado autenticado: usuario ha iniciado sesión correctamente
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Estado de error: ocurrió un error durante la autenticación
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Estado de logout: usuario cerró sesión
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
