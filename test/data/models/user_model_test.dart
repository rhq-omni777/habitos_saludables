import 'package:flutter_test/flutter_test.dart';
import 'package:habitos_saludables/data/models/user_model.dart';
import 'package:habitos_saludables/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    final testDate = DateTime(2026, 1, 15);
    
    final testUserModel = UserModel(
      id: 'test-id-123',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: 'https://example.com/photo.jpg',
      createdAt: testDate,
      updatedAt: testDate,
    );

    final testJson = {
      'id': 'test-id-123',
      'email': 'test@example.com',
      'name': 'Test User',
      'photoUrl': 'https://example.com/photo.jpg',
      'createdAt': testDate.toIso8601String(),
      'updatedAt': testDate.toIso8601String(),
    };

    test('debe crear UserModel correctamente', () {
      expect(testUserModel.id, 'test-id-123');
      expect(testUserModel.email, 'test@example.com');
      expect(testUserModel.name, 'Test User');
      expect(testUserModel.photoUrl, 'https://example.com/photo.jpg');
    });

    test('debe serializar a JSON correctamente', () {
      final json = testUserModel.toJson();
      
      expect(json['id'], 'test-id-123');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['photoUrl'], 'https://example.com/photo.jpg');
    });

    test('debe deserializar desde JSON correctamente', () {
      final userModel = UserModel.fromJson(testJson);
      
      expect(userModel.id, testUserModel.id);
      expect(userModel.email, testUserModel.email);
      expect(userModel.name, testUserModel.name);
      expect(userModel.photoUrl, testUserModel.photoUrl);
    });

    test('debe convertir a UserEntity correctamente', () {
      final entity = testUserModel.toEntity();
      
      expect(entity, isA<UserEntity>());
      expect(entity.id, testUserModel.id);
      expect(entity.email, testUserModel.email);
      expect(entity.name, testUserModel.name);
    });

    test('debe crear copia con copyWith', () {
      final updatedUser = testUserModel.copyWith(
        name: 'Updated Name',
        email: 'updated@example.com',
      );
      
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.email, 'updated@example.com');
      expect(updatedUser.id, testUserModel.id); // no cambia
    });

    test('empty debe ser un usuario vacío', () {
      expect(UserModel.empty.id, '');
      expect(UserModel.empty.email, '');
      expect(UserModel.empty.name, '');
      expect(UserModel.empty.photoUrl, null);
    });
  });

  group('UserEntity', () {
    final testDate = DateTime(2026, 1, 15);
    
    final testUser = UserEntity(
      id: 'test-id',
      email: 'test@example.com',
      name: 'Test User',
      photoUrl: null,
      createdAt: testDate,
      updatedAt: testDate,
    );

    test('debe verificar isEmpty correctamente', () {
      expect(UserEntity.empty.isEmpty, true);
      expect(testUser.isEmpty, false);
    });

    test('debe verificar isNotEmpty correctamente', () {
      expect(UserEntity.empty.isNotEmpty, false);
      expect(testUser.isNotEmpty, true);
    });

    test('copyWith debe crear nueva instancia con cambios', () {
      final updated = testUser.copyWith(name: 'New Name');
      
      expect(updated.name, 'New Name');
      expect(updated.id, testUser.id);
      expect(updated.email, testUser.email);
    });
  });
}
