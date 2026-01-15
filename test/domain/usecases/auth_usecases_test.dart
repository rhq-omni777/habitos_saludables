import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:habitos_saludables/domain/entities/user_entity.dart';
import 'package:habitos_saludables/domain/repositories/auth_repository.dart';
import 'package:habitos_saludables/domain/usecases/auth_usecases.dart';
import 'package:habitos_saludables/core/errors/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
  });

  group('Auth Usecases', () {
    final testUser = UserEntity(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: null,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('RegisterUsecase', () {
      test('should call repository.register with correct parameters', () async {
        const email = 'test@example.com';
        const password = 'Test@1234';
        const name = 'Test User';

        when(mockRepository.register(
          email: email,
          password: password,
          name: name,
        )).thenAnswer((_) async => Right(testUser));

        final usecase = RegisterUsecase(repository: mockRepository);
        final result = await usecase(
          email: email,
          password: password,
          name: name,
        );

        expect(result, Right(testUser));
        verify(mockRepository.register(
          email: email,
          password: password,
          name: name,
        )).called(1);
      });

      test('should return failure when registration fails', () async {
        const email = 'test@example.com';
        const password = 'Test@1234';
        const name = 'Test User';

        when(mockRepository.register(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        )).thenAnswer((_) async => Left(
          AuthFailure(message: 'Email already in use'),
        ));

        final usecase = RegisterUsecase(repository: mockRepository);
        final result = await usecase(
          email: email,
          password: password,
          name: name,
        );

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('LoginUsecase', () {
      test('should call repository.login with correct parameters', () async {
        const email = 'test@example.com';
        const password = 'Test@1234';

        when(mockRepository.login(
          email: email,
          password: password,
        )).thenAnswer((_) async => Right(testUser));

        final usecase = LoginUsecase(repository: mockRepository);
        final result =
            await usecase(email: email, password: password);

        expect(result, Right(testUser));
        verify(mockRepository.login(
          email: email,
          password: password,
        )).called(1);
      });

      test('should return failure when login fails', () async {
        const email = 'test@example.com';
        const password = 'wrong';

        when(mockRepository.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => Left(
          AuthFailure(message: 'Wrong password'),
        ));

        final usecase = LoginUsecase(repository: mockRepository);
        final result =
            await usecase(email: email, password: password);

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('LogoutUsecase', () {
      test('should call repository.logout', () async {
        when(mockRepository.logout())
            .thenAnswer((_) async => const Right(null));

        final usecase = LogoutUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, const Right(null));
        verify(mockRepository.logout()).called(1);
      });

      test('should return failure when logout fails', () async {
        when(mockRepository.logout()).thenAnswer((_) async => Left(
          AuthFailure(message: 'Logout error'),
        ));

        final usecase = LogoutUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('GetCurrentUserUsecase', () {
      test('should return current user', () async {
        when(mockRepository.getCurrentUser())
            .thenAnswer((_) async => Right(testUser));

        final usecase = GetCurrentUserUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, Right(testUser));
        verify(mockRepository.getCurrentUser()).called(1);
      });

      test('should return failure when no user is authenticated', () async {
        when(mockRepository.getCurrentUser()).thenAnswer((_) async => Left(
          AuthFailure(message: 'No user authenticated'),
        ));

        final usecase = GetCurrentUserUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('ResetPasswordUsecase', () {
      test('should call repository.resetPassword with email', () async {
        const email = 'test@example.com';

        when(mockRepository.resetPassword(email: email))
            .thenAnswer((_) async => const Right(null));

        final usecase = ResetPasswordUsecase(repository: mockRepository);
        final result = await usecase(email: email);

        expect(result, const Right(null));
        verify(mockRepository.resetPassword(email: email)).called(1);
      });

      test('should return failure when reset fails', () async {
        const email = 'invalid@example.com';

        when(mockRepository.resetPassword(email: anyNamed('email')))
            .thenAnswer((_) async => Left(
              AuthFailure(message: 'Invalid email'),
            ));

        final usecase = ResetPasswordUsecase(repository: mockRepository);
        final result = await usecase(email: email);

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('GetCachedUserUsecase', () {
      test('should return cached user', () async {
        when(mockRepository.getCachedUser())
            .thenAnswer((_) async => Right(testUser));

        final usecase = GetCachedUserUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, Right(testUser));
        verify(mockRepository.getCachedUser()).called(1);
      });

      test('should return null when no cached user', () async {
        when(mockRepository.getCachedUser())
            .thenAnswer((_) async => const Right(null));

        final usecase = GetCachedUserUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, const Right(null));
      });

      test('should return failure on exception', () async {
        when(mockRepository.getCachedUser()).thenAnswer((_) async => Left(
          CacheFailure(message: 'Cache error'),
        ));

        final usecase = GetCachedUserUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('CheckUserCachedUsecase', () {
      test('should return true when user is cached', () async {
        when(mockRepository.hasUserCached()).thenAnswer((_) async => true);

        final usecase = CheckUserCachedUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, true);
        verify(mockRepository.hasUserCached()).called(1);
      });

      test('should return false when user is not cached', () async {
        when(mockRepository.hasUserCached()).thenAnswer((_) async => false);

        final usecase = CheckUserCachedUsecase(repository: mockRepository);
        final result = await usecase();

        expect(result, false);
      });
    });
  });
}
