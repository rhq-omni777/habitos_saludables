import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:habitos_saludables/data/datasources/auth_local_datasource.dart';
import 'package:habitos_saludables/data/datasources/auth_remote_datasource.dart';
import 'package:habitos_saludables/data/models/user_model.dart';
import 'package:habitos_saludables/data/repositories/auth_repository_impl.dart';
import 'package:habitos_saludables/core/errors/exceptions.dart' as app_exceptions;
import 'package:habitos_saludables/core/errors/failures.dart';

// Mocks
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl authRepositoryImpl;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepositoryImpl = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepositoryImpl', () {
    const testEmail = 'test@example.com';
    const testPassword = 'Test@1234';
    const testName = 'Test User';
    const testUid = 'test_uid_123';

    final testUserModel = UserModel(
      id: testUid,
      email: testEmail,
      name: testName,
      photoUrl: null,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('register', () {
      test('should save user to local cache when registration succeeds', () async {
        when(mockRemoteDataSource.register(
          email: testEmail,
          password: testPassword,
          name: testName,
        )).thenAnswer((_) async => testUserModel);

        when(mockLocalDataSource.saveUser(testUserModel))
            .thenAnswer((_) async {});

        final result = await authRepositoryImpl.register(
          email: testEmail,
          password: testPassword,
          name: testName,
        );

        expect(result, Right(testUserModel.toEntity()));
        verify(mockRemoteDataSource.register(
          email: testEmail,
          password: testPassword,
          name: testName,
        )).called(1);
        verify(mockLocalDataSource.saveUser(testUserModel)).called(1);
      });

      test('should return AuthFailure when registration fails', () async {
        when(mockRemoteDataSource.register(
          email: anyNamed('email'),
          password: anyNamed('password'),
          name: anyNamed('name'),
        )).thenThrow(
          app_exceptions.AuthException(
            message: 'Email already in use',
            code: 'email-already-in-use',
          ),
        );

        final result = await authRepositoryImpl.register(
          email: testEmail,
          password: testPassword,
          name: testName,
        );

        expect(result, isA<Left<Failure, dynamic>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
          },
          (_) => fail('Should return failure'),
        );
      });
    });

    group('login', () {
      test('should save user to local cache when login succeeds', () async {
        when(mockRemoteDataSource.login(
          email: testEmail,
          password: testPassword,
        )).thenAnswer((_) async => testUserModel);

        when(mockLocalDataSource.saveUser(testUserModel))
            .thenAnswer((_) async {});

        final result = await authRepositoryImpl.login(
          email: testEmail,
          password: testPassword,
        );

        expect(result, Right(testUserModel.toEntity()));
        verify(mockRemoteDataSource.login(
          email: testEmail,
          password: testPassword,
        )).called(1);
        verify(mockLocalDataSource.saveUser(testUserModel)).called(1);
      });

      test('should return AuthFailure when login fails', () async {
        when(mockRemoteDataSource.login(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(
          app_exceptions.AuthException(
            message: 'Wrong password',
            code: 'wrong-password',
          ),
        );

        final result = await authRepositoryImpl.login(
          email: testEmail,
          password: testPassword,
        );

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('logout', () {
      test('should clear auth data when logout succeeds', () async {
        when(mockRemoteDataSource.logout()).thenAnswer((_) async {});
        when(mockLocalDataSource.clearUserToken()).thenAnswer((_) async {});
        when(mockLocalDataSource.clearCachedUser()).thenAnswer((_) async {});

        final result = await authRepositoryImpl.logout();

        expect(result, const Right(null));
        verify(mockRemoteDataSource.logout()).called(1);
        verify(mockLocalDataSource.clearUserToken()).called(1);
        verify(mockLocalDataSource.clearCachedUser()).called(1);
      });

      test('should return AuthFailure when logout fails', () async {
        when(mockRemoteDataSource.logout()).thenThrow(
          app_exceptions.AuthException(
            message: 'Logout error',
            code: 'logout-error',
          ),
        );

        final result = await authRepositoryImpl.logout();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('getCurrentUser', () {
      test('should return user from remote datasource', () async {
        when(mockRemoteDataSource.getCurrentUser())
            .thenAnswer((_) async => testUserModel);
        when(mockLocalDataSource.saveUser(testUserModel))
            .thenAnswer((_) async {});

        final result = await authRepositoryImpl.getCurrentUser();

        expect(result, Right(testUserModel.toEntity()));
        verify(mockRemoteDataSource.getCurrentUser()).called(1);
        verify(mockLocalDataSource.saveUser(testUserModel)).called(1);
      });

      test('should fallback to cached user when remote returns null', () async {
        when(mockRemoteDataSource.getCurrentUser()).thenAnswer((_) async => null);
        when(mockLocalDataSource.getCachedUser())
            .thenAnswer((_) async => testUserModel);

        final result = await authRepositoryImpl.getCurrentUser();

        expect(result, Right(testUserModel.toEntity()));
      });

      test('should return AuthFailure when no user is found', () async {
        when(mockRemoteDataSource.getCurrentUser()).thenAnswer((_) async => null);
        when(mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);

        final result = await authRepositoryImpl.getCurrentUser();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('resetPassword', () {
      test('should send password reset email', () async {
        when(mockRemoteDataSource.resetPassword(email: testEmail))
            .thenAnswer((_) async {});

        final result = await authRepositoryImpl.resetPassword(email: testEmail);

        expect(result, const Right(null));
        verify(mockRemoteDataSource.resetPassword(email: testEmail)).called(1);
      });

      test('should return AuthFailure when reset fails', () async {
        when(mockRemoteDataSource.resetPassword(email: anyNamed('email')))
            .thenThrow(
              app_exceptions.AuthException(
                message: 'Invalid email',
                code: 'invalid-email',
              ),
            );

        final result = await authRepositoryImpl.resetPassword(email: testEmail);

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('getCachedUser', () {
      test('should return cached user', () async {
        when(mockLocalDataSource.getCachedUser())
            .thenAnswer((_) async => testUserModel);

        final result = await authRepositoryImpl.getCachedUser();

        expect(result, Right(testUserModel.toEntity()));
      });

      test('should return null when no cached user exists', () async {
        when(mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);

        final result = await authRepositoryImpl.getCachedUser();

        expect(result, const Right(null));
      });

      test('should return CacheFailure on exception', () async {
        when(mockLocalDataSource.getCachedUser()).thenThrow(
          app_exceptions.DatabaseException(message: 'Cache error'),
        );

        final result = await authRepositoryImpl.getCachedUser();

        expect(result, isA<Left<Failure, dynamic>>());
      });
    });

    group('hasUserCached', () {
      test('should return true when user is cached', () async {
        when(mockLocalDataSource.hasUserCached()).thenAnswer((_) async => true);

        final result = await authRepositoryImpl.hasUserCached();

        expect(result, true);
      });

      test('should return false when user is not cached', () async {
        when(mockLocalDataSource.hasUserCached()).thenAnswer((_) async => false);

        final result = await authRepositoryImpl.hasUserCached();

        expect(result, false);
      });

      test('should return false on exception', () async {
        when(mockLocalDataSource.hasUserCached())
            .thenThrow(Exception('Error'));

        final result = await authRepositoryImpl.hasUserCached();

        expect(result, false);
      });
    });
  });
}
