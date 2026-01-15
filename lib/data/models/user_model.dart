import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Modelo de usuario para la capa de datos
/// Extiende UserEntity e implementa serialización con JSON y Firestore
class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String email,
    required String name,
    String? photoUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    email: email,
    name: name,
    photoUrl: photoUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  /// Crea una instancia desde un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  /// Crea una instancia desde un documento de Firestore
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (!doc.exists) {
      throw Exception('Documento no existe');
    }

    final data = doc.data()!;
    return UserModel(
      id: doc.id,
      email: data['email'] as String,
      name: data['name'] as String,
      photoUrl: data['photoUrl'] as String?,
      createdAt: _parseFirestoreTimestamp(data['createdAt']),
      updatedAt: _parseFirestoreTimestamp(data['updatedAt']),
    );
  }

  /// Crea una instancia desde una entidad
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photoUrl: entity.photoUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convierte a mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convierte a entidad
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photoUrl: photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Helper para parsear DateTime desde JSON
  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  /// Helper para parsear Timestamp de Firestore
  static DateTime _parseFirestoreTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    return DateTime.now();
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, createdAt, updatedAt];
}
