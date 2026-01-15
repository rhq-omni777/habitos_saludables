import 'package:equatable/equatable.dart';

/// Entidad de usuario en el dominio de la aplicación.
/// Representa un usuario autenticado con sus datos básicos.
class UserEntity extends Equatable {
  /// ID único del usuario (generado por Firebase)
  final String id;

  /// Email del usuario
  final String email;

  /// Nombre completo del usuario
  final String name;

  /// URL de la foto de perfil (opcional)
  final String? photoUrl;

  /// Fecha de creación de la cuenta
  final DateTime createdAt;

  /// Fecha de última actualización
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crea una copia del usuario con campos actualizados
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

  /// Usuario vacío para representar estados no autenticados
  static final empty = UserEntity(
    id: '',
    email: '',
    name: '',
    photoUrl: null,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
  );

  /// Verifica si el usuario está vacío (no autenticado)
  bool get isEmpty => this == UserEntity.empty;

  /// Verifica si el usuario no está vacío (autenticado)
  bool get isNotEmpty => this != UserEntity.empty;

  @override
  List<Object?> get props => [id, email, name, photoUrl, createdAt, updatedAt];

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
