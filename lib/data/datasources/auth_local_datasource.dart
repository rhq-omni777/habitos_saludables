import '../models/user_model.dart';

/// Interfaz para datasource local de autenticación (Shared Preferences + Hive)
abstract class AuthLocalDataSource {
  /// Guarda el token de usuario localmente
  Future<void> saveUserToken(String token);

  /// Obtiene el token de usuario guardado
  Future<String?> getUserToken();

  /// Elimina el token de usuario
  Future<void> clearUserToken();

  /// Guarda los datos del usuario en cache local
  Future<void> saveUser(UserModel user);

  /// Obtiene el usuario guardado en cache
  Future<UserModel?> getCachedUser();

  /// Elimina el usuario del cache
  Future<void> clearCachedUser();

  /// Verifica si hay usuario guardado localmente
  Future<bool> hasUserCached();
}
