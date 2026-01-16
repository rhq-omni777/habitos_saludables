import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user_entity.dart';
import 'auth_providers.dart';

/// StateNotifier para manejar el estado de autenticación
class AuthStateNotifier extends StateNotifier<AuthState> {
  final dynamic _loginUsecase;
  final dynamic _registerUsecase;
  final dynamic _logoutUsecase;
  final dynamic _getCurrentUserUsecase;
  final dynamic _resetPasswordUsecase;
  final dynamic _getCachedUserUsecase;
  final dynamic _checkUserCachedUsecase;

  AuthStateNotifier({
    required dynamic loginUsecase,
    required dynamic registerUsecase,
    required dynamic logoutUsecase,
    required dynamic getCurrentUserUsecase,
    required dynamic resetPasswordUsecase,
    required dynamic getCachedUserUsecase,
    required dynamic checkUserCachedUsecase,
  })  : _loginUsecase = loginUsecase,
        _registerUsecase = registerUsecase,
        _logoutUsecase = logoutUsecase,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        _resetPasswordUsecase = resetPasswordUsecase,
        _getCachedUserUsecase = getCachedUserUsecase,
        _checkUserCachedUsecase = checkUserCachedUsecase,
        super(const AuthUnauthenticated());

  /// Registra un nuevo usuario
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AuthLoading();
    try {
      final result = await _registerUsecase(
        email: email,
        password: password,
        name: name,
      );

      result.fold(
        (failure) {
          state = AuthError(
            message: failure.message,
            code: failure.code,
          );
        },
        (user) {
          state = AuthAuthenticated(user: user);
        },
      );
    } catch (e) {
      // Fallback para no dejar el estado en loading si ocurre un error inesperado
      state = AuthError(message: 'Error inesperado al registrar: $e');
    }
  }

  /// Inicia sesión del usuario
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _loginUsecase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = AuthError(
        message: failure.message,
        code: failure.code,
      ),
      (user) => state = AuthAuthenticated(user: user),
    );
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    state = const AuthLoading();

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = AuthError(
        message: failure.message,
        code: failure.code,
      ),
      (_) => state = const AuthLoggedOut(),
    );
  }

  /// Obtiene el usuario actual
  Future<void> getCurrentUser() async {
    state = const AuthLoading();

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) {
        // Intentar obtener del caché
        _tryGetCachedUser();
      },
      (user) => state = AuthAuthenticated(user: user),
    );
  }

  /// Resetea la contraseña del usuario
  Future<void> resetPassword({required String email}) async {
    state = const AuthLoading();

    final result = await _resetPasswordUsecase(email: email);

    result.fold(
      (failure) => state = AuthError(
        message: failure.message,
        code: failure.code,
      ),
      (_) => state = const AuthUnauthenticated(),
    );
  }

  /// Intenta obtener el usuario del caché
  Future<void> _tryGetCachedUser() async {
    final result = await _getCachedUserUsecase();

    result.fold(
      (failure) => state = AuthError(
        message: failure.message,
        code: failure.code,
      ),
      (user) {
        if (user != null) {
          state = AuthAuthenticated(user: user);
        } else {
          state = const AuthUnauthenticated();
        }
      },
    );
  }

  /// Verifica si hay usuario en caché e inicializa el estado
  Future<void> initializeAuth() async {
    final hasCached = await _checkUserCachedUsecase();

    if (hasCached) {
      await _tryGetCachedUser();
    } else {
      state = const AuthUnauthenticated();
    }
  }
}

/// Provider para el estado de autenticación
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final loginUsecase = ref.watch(loginUsecaseProvider);
    final registerUsecase = ref.watch(registerUsecaseProvider);
    final logoutUsecase = ref.watch(logoutUsecaseProvider);
    final getCurrentUserUsecase = ref.watch(getCurrentUserUsecaseProvider);
    final resetPasswordUsecase = ref.watch(resetPasswordUsecaseProvider);
    final getCachedUserUsecase = ref.watch(getCachedUserUsecaseProvider);
    final checkUserCachedUsecase = ref.watch(checkUserCachedUsecaseProvider);

    return AuthStateNotifier(
      loginUsecase: loginUsecase,
      registerUsecase: registerUsecase,
      logoutUsecase: logoutUsecase,
      getCurrentUserUsecase: getCurrentUserUsecase,
      resetPasswordUsecase: resetPasswordUsecase,
      getCachedUserUsecase: getCachedUserUsecase,
      checkUserCachedUsecase: checkUserCachedUsecase,
    );
  },
);

/// Provider para obtener el usuario actual autenticado
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState is AuthAuthenticated) {
    return authState.user;
  }

  return null;
});

/// Provider para verificar si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthAuthenticated;
});

/// Provider para verificar si se está cargando
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState is AuthLoading;
});

/// Provider para obtener mensajes de error
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState is AuthError) {
    return authState.message;
  }

  return null;
});
