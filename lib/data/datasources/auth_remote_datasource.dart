import '../models/user_model.dart';

/// Interfaz para datasource remoto de autenticación (Firebase)
abstract class AuthRemoteDataSource {
  /// Registra un nuevo usuario
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  });

  /// Inicia sesión con email y contraseña
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Cierra sesión del usuario actual
  Future<void> logout();

  /// Obtiene el usuario actualmente autenticado
  Future<UserModel?> getCurrentUser();

  /// Envía instrucciones de reseteo de contraseña
  Future<void> resetPassword({required String email});
}
