import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementación del datasource local usando SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _tokenKey = 'user_token';
  static const String _userKey = 'cached_user';

  final SharedPreferences _sharedPreferences;
  final Logger _logger;

  AuthLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
    Logger? logger,
  })  : _sharedPreferences = sharedPreferences,
        _logger = logger ?? Logger();

  @override
  Future<void> saveUserToken(String token) async {
    try {
      _logger.i('Guardando token de usuario');
      await _sharedPreferences.setString(_tokenKey, token);
      _logger.i('Token guardado exitosamente');
    } catch (e) {
      _logger.e('Error al guardar token: $e');
      throw DatabaseException(
        message: 'Error al guardar token: $e',
      );
    }
  }

  @override
  Future<String?> getUserToken() async {
    try {
      _logger.i('Obteniendo token del usuario');
      final token = _sharedPreferences.getString(_tokenKey);
      if (token != null) {
        _logger.i('Token obtenido');
      } else {
        _logger.w('No hay token guardado');
      }
      return token;
    } catch (e) {
      _logger.e('Error al obtener token: $e');
      return null;
    }
  }

  @override
  Future<void> clearUserToken() async {
    try {
      _logger.i('Eliminando token del usuario');
      await _sharedPreferences.remove(_tokenKey);
      _logger.i('Token eliminado exitosamente');
    } catch (e) {
      _logger.e('Error al eliminar token: $e');
      throw DatabaseException(
        message: 'Error al eliminar token: $e',
      );
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      _logger.i('Guardando usuario en cache: ${user.id}');
      final userJson = jsonEncode(user.toJson());
      await _sharedPreferences.setString(_userKey, userJson);
      _logger.i('Usuario guardado en cache');
    } catch (e) {
      _logger.e('Error al guardar usuario en cache: $e');
      throw DatabaseException(
        message: 'Error al guardar usuario: $e',
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      _logger.i('Obteniendo usuario del cache');
      final userJson = _sharedPreferences.getString(_userKey);

      if (userJson == null) {
        _logger.w('No hay usuario en cache');
        return null;
      }

      final decoded = jsonDecode(userJson) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(decoded);
      _logger.i('Usuario obtenido del cache: ${userModel.id}');
      return userModel;
    } catch (e) {
      _logger.e('Error al obtener usuario del cache: $e');
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      _logger.i('Eliminando usuario del cache');
      await _sharedPreferences.remove(_userKey);
      _logger.i('Usuario eliminado del cache');
    } catch (e) {
      _logger.e('Error al eliminar usuario del cache: $e');
      throw DatabaseException(
        message: 'Error al eliminar usuario: $e',
      );
    }
  }

  @override
  Future<bool> hasUserCached() async {
    try {
      return _sharedPreferences.containsKey(_userKey);
    } catch (e) {
      _logger.e('Error al verificar cache: $e');
      return false;
    }
  }

  /// Limpia toda la información de autenticación
  Future<void> clearAllAuthData() async {
    try {
      _logger.i('Limpiando todos los datos de autenticación');
      await clearUserToken();
      await clearCachedUser();
      _logger.i('Datos de autenticación limpiados');
    } catch (e) {
      _logger.e('Error al limpiar datos: $e');
      throw DatabaseException(
        message: 'Error al limpiar datos: $e',
      );
    }
  }
}
