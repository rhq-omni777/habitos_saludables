import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_local_datasource_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

// External Services Providers
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final firebaseAuthProvider = Provider((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

// DataSources Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final firebaseFirestore = ref.watch(firebaseFirestoreProvider);

  return AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  );
});

final authLocalDataSourceProvider =
    FutureProvider<AuthLocalDataSource>((ref) async {
  final sharedPrefs = await ref.watch(sharedPreferencesProvider.future);

  return AuthLocalDataSourceImpl(
    sharedPreferences: sharedPrefs,
  );
});

// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSourceAsync = ref.watch(authLocalDataSourceProvider);

  return localDataSourceAsync.when(
    data: (localDataSource) => AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    ),
    error: (error, stack) => throw error,
    loading: () => throw Exception('LocalDataSource loading'),
  );
});

// UseCases Providers
final registerUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository: repository);
});

final loginUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository: repository);
});

final logoutUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUsecase(repository: repository);
});

final getCurrentUserUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUsecase(repository: repository);
});

final resetPasswordUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUsecase(repository: repository);
});

final getCachedUserUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCachedUserUsecase(repository: repository);
});

final checkUserCachedUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckUserCachedUsecase(repository: repository);
});
