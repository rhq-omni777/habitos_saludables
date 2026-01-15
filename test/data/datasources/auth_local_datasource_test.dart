import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habitos_saludables/data/datasources/auth_local_datasource_impl.dart';
import 'package:habitos_saludables/data/models/user_model.dart';
import 'package:habitos_saludables/core/errors/exceptions.dart';

// Mock SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AuthLocalDataSourceImpl authLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    authLocalDataSourceImpl = AuthLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('AuthLocalDataSourceImpl', () {
    final testToken = 'test_token_12345';

    final testUserModel = UserModel(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    group('saveUserToken', () {
      test('should save token to SharedPreferences', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        await authLocalDataSourceImpl.saveUserToken(testToken);

        verify(mockSharedPreferences.setString('user_token', testToken))
            .called(1);
      });

      test('should throw DatabaseException on failure', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenThrow(Exception('Storage error'));

        expect(
          () => authLocalDataSourceImpl.saveUserToken(testToken),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('getUserToken', () {
      test('should return token from SharedPreferences', () async {
        when(mockSharedPreferences.getString('user_token'))
            .thenReturn(testToken);

        final result = await authLocalDataSourceImpl.getUserToken();

        expect(result, testToken);
        verify(mockSharedPreferences.getString('user_token')).called(1);
      });

      test('should return null when token not found', () async {
        when(mockSharedPreferences.getString('user_token')).thenReturn(null);

        final result = await authLocalDataSourceImpl.getUserToken();

        expect(result, isNull);
      });

      test('should return null on exception', () async {
        when(mockSharedPreferences.getString('user_token'))
            .thenThrow(Exception('Error'));

        final result = await authLocalDataSourceImpl.getUserToken();

        expect(result, isNull);
      });
    });

    group('clearUserToken', () {
      test('should remove token from SharedPreferences', () async {
        when(mockSharedPreferences.remove('user_token'))
            .thenAnswer((_) async => true);

        await authLocalDataSourceImpl.clearUserToken();

        verify(mockSharedPreferences.remove('user_token')).called(1);
      });

      test('should throw DatabaseException on failure', () async {
        when(mockSharedPreferences.remove('user_token'))
            .thenThrow(Exception('Storage error'));

        expect(
          () => authLocalDataSourceImpl.clearUserToken(),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('saveUser', () {
      test('should save user to SharedPreferences as JSON', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        await authLocalDataSourceImpl.saveUser(testUserModel);

        verify(mockSharedPreferences.setString(
          'cached_user',
          jsonEncode(testUserModel.toJson()),
        )).called(1);
      });

      test('should throw DatabaseException on failure', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenThrow(Exception('Storage error'));

        expect(
          () => authLocalDataSourceImpl.saveUser(testUserModel),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('getCachedUser', () {
      test('should return UserModel from cached JSON', () async {
        final userJson = jsonEncode(testUserModel.toJson());
        when(mockSharedPreferences.getString('cached_user'))
            .thenReturn(userJson);

        final result = await authLocalDataSourceImpl.getCachedUser();

        expect(result, isA<UserModel>());
        expect(result?.id, testUserModel.id);
        expect(result?.email, testUserModel.email);
      });

      test('should return null when no cached user', () async {
        when(mockSharedPreferences.getString('cached_user')).thenReturn(null);

        final result = await authLocalDataSourceImpl.getCachedUser();

        expect(result, isNull);
      });

      test('should return null on deserialization error', () async {
        when(mockSharedPreferences.getString('cached_user'))
            .thenReturn(jsonEncode({'invalid': 'data'}));

        final result = await authLocalDataSourceImpl.getCachedUser();

        expect(result, isNull);
      });
    });

    group('clearCachedUser', () {
      test('should remove cached user from SharedPreferences', () async {
        when(mockSharedPreferences.remove('cached_user'))
            .thenAnswer((_) async => true);

        await authLocalDataSourceImpl.clearCachedUser();

        verify(mockSharedPreferences.remove('cached_user')).called(1);
      });

      test('should throw DatabaseException on failure', () async {
        when(mockSharedPreferences.remove('cached_user'))
            .thenThrow(Exception('Storage error'));

        expect(
          () => authLocalDataSourceImpl.clearCachedUser(),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('hasUserCached', () {
      test('should return true when user is cached', () async {
        when(mockSharedPreferences.containsKey('cached_user')).thenReturn(true);

        final result = await authLocalDataSourceImpl.hasUserCached();

        expect(result, true);
      });

      test('should return false when user is not cached', () async {
        when(mockSharedPreferences.containsKey('cached_user'))
            .thenReturn(false);

        final result = await authLocalDataSourceImpl.hasUserCached();

        expect(result, false);
      });

      test('should return false on exception', () async {
        when(mockSharedPreferences.containsKey('cached_user'))
            .thenThrow(Exception('Error'));

        final result = await authLocalDataSourceImpl.hasUserCached();

        expect(result, false);
      });
    });

    group('clearAllAuthData', () {
      test('should clear both token and cached user', () async {
        when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);

        await authLocalDataSourceImpl.clearAllAuthData();

        verify(mockSharedPreferences.remove('user_token')).called(1);
        verify(mockSharedPreferences.remove('cached_user')).called(1);
      });

      test('should throw DatabaseException on failure', () async {
        when(mockSharedPreferences.remove(any))
            .thenThrow(Exception('Storage error'));

        expect(
          () => authLocalDataSourceImpl.clearAllAuthData(),
          throwsA(isA<DatabaseException>()),
        );
      });
    });
  });
}
