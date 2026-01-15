import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:habitos_saludables/data/datasources/auth_remote_datasource_impl.dart';
import 'package:habitos_saludables/data/models/user_model.dart';
import 'package:habitos_saludables/core/errors/exceptions.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late AuthRemoteDataSourceImpl authRemoteDataSourceImpl;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockUser = MockUser();
    mockUserCredential = MockUserCredential();

    authRemoteDataSourceImpl = AuthRemoteDataSourceImpl(
      firebaseAuth: mockFirebaseAuth,
      firebaseFirestore: mockFirebaseFirestore,
    );
  });

  group('AuthRemoteDataSourceImpl', () {
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
      test('should successfully register user', () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);

        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(testUid);
        when(mockUser.updateDisplayName(any)).thenAnswer((_) async {});
        when(mockUser.displayName).thenReturn(testName);

        final mockCollectionRef = MockCollectionReference();
        final mockDocRef = MockDocumentReference();

        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
        when(mockDocRef.set(any)).thenAnswer((_) async {});

        final result = await authRemoteDataSourceImpl.register(
          email: testEmail,
          password: testPassword,
          name: testName,
        );

        expect(result.id, testUid);
        expect(result.email, testEmail);
      });

      test('should throw AuthException on weak password', () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(
          FirebaseAuthException(code: 'weak-password', message: 'Weak password'),
        );

        expect(
          () => authRemoteDataSourceImpl.register(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException on email already in use', () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(
          FirebaseAuthException(code: 'email-already-in-use', message: 'Email already in use'),
        );

        expect(
          () => authRemoteDataSourceImpl.register(
            email: testEmail,
            password: testPassword,
            name: testName,
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('login', () {
      test('should successfully login user', () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);

        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(testUid);

        final mockCollectionRef = MockCollectionReference();
        final mockDocRef = MockDocumentReference();
        final mockDocSnapshot = MockDocumentSnapshot();

        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(testUserModel.toJson());

        final result = await authRemoteDataSourceImpl.login(
          email: testEmail,
          password: testPassword,
        );

        expect(result.id, testUid);
        expect(result.email, testEmail);
      });

      test('should throw AuthException on wrong password', () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(
          FirebaseAuthException(code: 'wrong-password', message: 'Wrong password'),
        );

        expect(
          () => authRemoteDataSourceImpl.login(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException on user not found', () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(
          FirebaseAuthException(code: 'user-not-found', message: 'User not found'),
        );

        expect(
          () => authRemoteDataSourceImpl.login(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('logout', () {
      test('should successfully logout user', () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await authRemoteDataSourceImpl.logout();

        verify(mockFirebaseAuth.signOut()).called(1);
      });

      test('should throw AuthException on logout error', () async {
        when(mockFirebaseAuth.signOut())
            .thenThrow(FirebaseAuthException(code: 'error', message: 'Logout error'));

        expect(
          () => authRemoteDataSourceImpl.logout(),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('getCurrentUser', () {
      test('should return current user', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(testUid);

        final mockCollectionRef = MockCollectionReference();
        final mockDocRef = MockDocumentReference();
        final mockDocSnapshot = MockDocumentSnapshot();

        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(true);
        when(mockDocSnapshot.data()).thenReturn(testUserModel.toJson());

        final result = await authRemoteDataSourceImpl.getCurrentUser();

        expect(result, isNotNull);
        expect(result?.id, testUid);
      });

      test('should throw AuthException when no user is logged in', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        expect(
          () => authRemoteDataSourceImpl.getCurrentUser(),
          throwsA(isA<AuthException>()),
        );
      });

      test('should throw AuthException when user document does not exist', () async {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn(testUid);

        final mockCollectionRef = MockCollectionReference();
        final mockDocRef = MockDocumentReference();
        final mockDocSnapshot = MockDocumentSnapshot();

        when(mockFirebaseFirestore.collection('users'))
            .thenReturn(mockCollectionRef);
        when(mockCollectionRef.doc(testUid)).thenReturn(mockDocRef);
        when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
        when(mockDocSnapshot.exists).thenReturn(false);

        expect(
          () => authRemoteDataSourceImpl.getCurrentUser(),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('resetPassword', () {
      test('should successfully send password reset email', () async {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
            .thenAnswer((_) async {});

        await authRemoteDataSourceImpl.resetPassword(email: testEmail);

        verify(mockFirebaseAuth.sendPasswordResetEmail(email: testEmail))
            .called(1);
      });

      test('should throw AuthException on invalid email', () async {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')))
            .thenThrow(
              FirebaseAuthException(code: 'invalid-email', message: 'Invalid email'),
            );

        expect(
          () => authRemoteDataSourceImpl.resetPassword(email: testEmail),
          throwsA(isA<AuthException>()),
        );
      });
    });
  });
}
