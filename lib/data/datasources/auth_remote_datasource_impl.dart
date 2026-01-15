import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide FirebaseException;
import 'package:logger/logger.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart' as app_exceptions;
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Implementación del datasource remoto usando Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final Logger _logger;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _logger.i('Registrando usuario: $email');

      // Crear usuario en Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw app_exceptions.AuthException(
          message: 'No se pudo crear la cuenta',
          code: 'USER_NOT_CREATED',
        );
      }

      // Actualizar nombre en Firebase Auth
      await user.updateDisplayName(name);

      // Crear documento del usuario en Firestore
      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        photoUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebaseFirestore
          .collection(AppConstants.userCollection)
          .doc(user.uid)
          .set(userModel.toFirestore());

      _logger.i('Usuario registrado exitosamente: ${user.uid}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en registro: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      _logger.e('Error inesperado en registro: $e');
      throw app_exceptions.AuthException(message: 'Error al registrar: $e');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Iniciando sesión: $email');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw app_exceptions.AuthException(
          message: 'No se pudo iniciar sesión',
          code: 'LOGIN_FAILED',
        );
      }

      // Obtener datos del usuario desde Firestore
      final userDoc = await _firebaseFirestore
          .collection(AppConstants.userCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw app_exceptions.AuthException(
          message: 'Datos del usuario no encontrados',
          code: 'USER_DATA_NOT_FOUND',
        );
      }

      final userModel = UserModel.fromFirestore(userDoc);
      _logger.i('Sesión iniciada exitosamente: ${user.uid}');
      return userModel;
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en login: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      _logger.e('Error inesperado en login: $e');
      throw app_exceptions.AuthException(message: 'Error al iniciar sesión: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.i('Cerrando sesión');
      await _firebaseAuth.signOut();
      _logger.i('Sesión cerrada exitosamente');
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      throw app_exceptions.AuthException(message: 'Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        _logger.w('No hay usuario autenticado');
        return null;
      }

      _logger.i('Obteniendo usuario actual: ${user.uid}');

      final userDoc = await _firebaseFirestore
          .collection(AppConstants.userCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        _logger.w('Usuario no encontrado en Firestore');
        return null;
      }

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      _logger.e('Error al obtener usuario actual: $e');
      return null;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      _logger.i('Enviando instrucciones de reset para: $email');
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _logger.i('Instrucciones de reset enviadas');
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en reset: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      _logger.e('Error inesperado en reset: $e');
      throw app_exceptions.AuthException(message: 'Error al resetear contraseña: $e');
    }
  }

  /// Convierte FirebaseAuthException en AppException
  app_exceptions.AppException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return app_exceptions.AuthException(
          message: 'Usuario no encontrado',
          code: e.code,
        );
      case 'wrong-password':
        return app_exceptions.AuthException(
          message: 'Contraseña incorrecta',
          code: e.code,
        );
      case 'email-already-in-use':
        return app_exceptions.AuthException(
          message: 'El email ya está registrado',
          code: e.code,
        );
      case 'weak-password':
        return app_exceptions.AuthException(
          message: 'Contraseña muy débil',
          code: e.code,
        );
      case 'invalid-email':
        return app_exceptions.AuthException(
          message: 'Email inválido',
          code: e.code,
        );
      case 'user-disabled':
        return app_exceptions.AuthException(
          message: 'Usuario deshabilitado',
          code: e.code,
        );
      case 'operation-not-allowed':
        return app_exceptions.AuthException(
          message: 'Operación no permitida',
          code: e.code,
        );
      default:
        return app_exceptions.AuthException(
          message: e.message ?? 'Error de Firebase',
          code: e.code,
        );
    }
  }
}
