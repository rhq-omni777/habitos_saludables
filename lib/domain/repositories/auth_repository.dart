import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Interfaz del repositorio de autenticación
/// Define los contratos que la capa de datos debe cumplir
abstract class AuthRepository {
  /// Registra un nuevo usuario
  /// Retorna [Right] con el usuario creado o [Left] con un error
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  /// Inicia sesión del usuario
  /// Retorna [Right] con el usuario autenticado o [Left] con un error
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Cierra la sesión del usuario actual
  /// Retorna [Right] con void o [Left] con un error
  Future<Either<Failure, void>> logout();

  /// Obtiene el usuario actualmente autenticado
  /// Retorna [Right] con el usuario o [Left] con un error
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Envía instrucciones de reset de contraseña
  /// Retorna [Right] con void o [Left] con un error
  Future<Either<Failure, void>> resetPassword({required String email});

  /// Obtiene el usuario en caché localmente
  /// Retorna [Right] con el usuario o [Left] con un error
  Future<Either<Failure, UserEntity?>> getCachedUser();

  /// Verifica si hay un usuario en caché
  /// Retorna true si existe usuario en caché, false en caso contrario
  Future<bool> hasUserCached();
}
