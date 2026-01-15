import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para registrar un nuevo usuario
class RegisterUsecase {
  final AuthRepository _repository;

  RegisterUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await _repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}

/// Caso de uso para iniciar sesión
class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(
      email: email,
      password: password,
    );
  }
}

/// Caso de uso para cerrar sesión
class LogoutUsecase {
  final AuthRepository _repository;

  LogoutUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, void>> call() async {
    return await _repository.logout();
  }
}

/// Caso de uso para obtener el usuario actual
class GetCurrentUserUsecase {
  final AuthRepository _repository;

  GetCurrentUserUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser();
  }
}

/// Caso de uso para resetear contraseña
class ResetPasswordUsecase {
  final AuthRepository _repository;

  ResetPasswordUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<Either<Failure, void>> call({required String email}) async {
    return await _repository.resetPassword(email: email);
  }
}

/// Caso de uso para obtener usuario en caché
class GetCachedUserUsecase {
  final AuthRepository _repository;

  GetCachedUserUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<Either<Failure, UserEntity?>> call() async {
    return await _repository.getCachedUser();
  }
}

/// Caso de uso para verificar si hay usuario en caché
class CheckUserCachedUsecase {
  final AuthRepository _repository;

  CheckUserCachedUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<bool> call() async {
    return await _repository.hasUserCached();
  }
}
