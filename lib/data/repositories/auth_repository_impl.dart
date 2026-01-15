import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../core/errors/exceptions.dart' as app_exceptions;
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementación del repositorio de autenticación
/// Orquesta el uso de datasources remoto y local
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final Logger _logger;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    Logger? logger,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _logger = logger ?? Logger();

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _logger.i('Registrando usuario: $email');

      // Registrar en Firebase (remoto)
      final userModel = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );

      // Guardar en caché local
      await _localDataSource.saveUser(userModel);

      _logger.i('Usuario registrado exitosamente');
      return Right(userModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      _logger.e('Error de autenticación: ${e.message}');
      return Left(AuthFailure(message: e.message, code: e.code));
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error inesperado: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(ServerFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Iniciando sesión: $email');

      // Iniciar sesión en Firebase (remoto)
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Guardar en caché local
      await _localDataSource.saveUser(userModel);

      _logger.i('Sesión iniciada exitosamente');
      return Right(userModel.toEntity());
    } on app_exceptions.AuthException catch (e) {
      _logger.e('Error de autenticación: ${e.message}');
      return Left(AuthFailure(message: e.message, code: e.code));
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error inesperado: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(ServerFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      _logger.i('Cerrando sesión');

      // Cerrar sesión en Firebase
      await _remoteDataSource.logout();

      // Limpiar datos de autenticación locales
      await _localDataSource.clearUserToken();
      await _localDataSource.clearCachedUser();

      _logger.i('Sesión cerrada exitosamente');
      return const Right(null);
    } on app_exceptions.AuthException catch (e) {
      _logger.e('Error al cerrar sesión: ${e.message}');
      return Left(AuthFailure(message: e.message, code: e.code));
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error inesperado: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(ServerFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      _logger.i('Obteniendo usuario actual');

      // Intentar obtener del datasource remoto
      final userModel = await _remoteDataSource.getCurrentUser();

      // Guardar en caché
      if (userModel != null) {
        await _localDataSource.saveUser(userModel);
        _logger.i('Usuario actual obtenido');
        return Right(userModel.toEntity());
      } else {
        // Si no hay usuario remoto, intentar obtener del caché local
        final cachedUser = await _localDataSource.getCachedUser();
        if (cachedUser != null) {
          _logger.i('Usuario obtenido del caché');
          return Right(cachedUser.toEntity());
        }

        _logger.w('No hay usuario autenticado');
        return Left(AuthFailure(message: 'No hay usuario autenticado'));
      }
    } on app_exceptions.AuthException catch (e) {
      _logger.e('Error de autenticación: ${e.message}');
      return Left(AuthFailure(message: e.message, code: e.code));
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error inesperado: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(ServerFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email}) async {
    try {
      _logger.i('Enviando instrucciones de reset para: $email');

      await _remoteDataSource.resetPassword(email: email);

      _logger.i('Instrucciones de reset enviadas');
      return const Right(null);
    } on app_exceptions.AuthException catch (e) {
      _logger.e('Error de autenticación: ${e.message}');
      return Left(AuthFailure(message: e.message, code: e.code));
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error inesperado: ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(ServerFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      _logger.i('Obteniendo usuario del caché');

      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        _logger.i('Usuario obtenido del caché');
        return Right(cachedUser.toEntity());
      }

      _logger.w('No hay usuario en caché');
      return const Right(null);
    } on app_exceptions.AppException catch (e) {
      _logger.e('Error: ${e.message}');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      _logger.e('Error desconocido: $e');
      return Left(CacheFailure(message: 'Error desconocido: $e'));
    }
  }

  @override
  Future<bool> hasUserCached() async {
    try {
      return await _localDataSource.hasUserCached();
    } catch (e) {
      _logger.e('Error al verificar caché: $e');
      return false;
    }
  }
}
