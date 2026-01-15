import 'package:equatable/equatable.dart';

/// Entidad de usuario - Capa de dominio
/// Representa la información del usuario de forma independiente de datos Firebase
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Usuario vacío para estado no autenticado
  static final empty = UserEntity(
    id: '',
    email: '',
    name: '',
    photoUrl: null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  /// Copia la entidad con cambios opcionales
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Verifica si la entidad está vacía
  bool get isEmpty => this == UserEntity.empty;

  /// Verifica si la entidad no está vacía
  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props =>
      [id, email, name, photoUrl, createdAt, updatedAt];

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
}
