import 'package:equatable/equatable.dart';

import 'user_entity.dart';

/// Estado base para la autenticación
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial - Usuario no autenticado
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de carga - Procesando autenticación
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado autenticado - Usuario con sesión iniciada
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado de error - Error en autenticación
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

/// Estado desconectado - Usuario cerró sesión
class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}
