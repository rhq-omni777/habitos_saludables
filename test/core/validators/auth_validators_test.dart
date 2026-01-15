import 'package:flutter_test/flutter_test.dart';

import 'package:habitos_saludables/core/validators/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        final result = AuthValidators.validateEmail('test@example.com');
        expect(result, isNull);
      });

      test('should return error for empty email', () {
        final result = AuthValidators.validateEmail('');
        expect(result, isNotNull);
      });

      test('should return error for null email', () {
        final result = AuthValidators.validateEmail(null);
        expect(result, isNotNull);
      });

      test('should return error for invalid email format', () {
        final result = AuthValidators.validateEmail('invalid.email');
        expect(result, isNotNull);
      });

      test('should accept various valid email formats', () {
        expect(AuthValidators.validateEmail('user@example.co.uk'), isNull);
        expect(AuthValidators.validateEmail('first.last@example.com'), isNull);
        expect(AuthValidators.validateEmail('user+tag@example.com'), isNull);
      });
    });

    group('validatePassword', () {
      test('should return null for strong password', () {
        final result = AuthValidators.validatePassword('Test@1234');
        expect(result, isNull);
      });

      test('should return error for empty password', () {
        final result = AuthValidators.validatePassword('');
        expect(result, isNotNull);
      });

      test('should return error for null password', () {
        final result = AuthValidators.validatePassword(null);
        expect(result, isNotNull);
      });

      test('should return error for short password', () {
        final result = AuthValidators.validatePassword('Test@12');
        expect(result, isNotNull);
      });

      test('should return error for password without uppercase', () {
        final result = AuthValidators.validatePassword('test@1234');
        expect(result, isNotNull);
      });

      test('should return error for password without lowercase', () {
        final result = AuthValidators.validatePassword('TEST@1234');
        expect(result, isNotNull);
      });

      test('should return error for password without number', () {
        final result = AuthValidators.validatePassword('Test@abcd');
        expect(result, isNotNull);
      });

      test('should return error for password without special character', () {
        final result = AuthValidators.validatePassword('Test1234');
        expect(result, isNotNull);
      });
    });

    group('validatePasswordMatch', () {
      test('should return null for matching passwords', () {
        final result = AuthValidators.validatePasswordMatch(
          'Test@1234',
          'Test@1234',
        );
        expect(result, isNull);
      });

      test('should return error for non-matching passwords', () {
        final result = AuthValidators.validatePasswordMatch(
          'Test@1234',
          'Test@5678',
        );
        expect(result, isNotNull);
      });

      test('should return error for empty confirm password', () {
        final result = AuthValidators.validatePasswordMatch(
          'Test@1234',
          '',
        );
        expect(result, isNotNull);
      });

      test('should return error for null confirm password', () {
        final result = AuthValidators.validatePasswordMatch(
          'Test@1234',
          null,
        );
        expect(result, isNotNull);
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        final result = AuthValidators.validateName('John Doe');
        expect(result, isNull);
      });

      test('should return error for empty name', () {
        final result = AuthValidators.validateName('');
        expect(result, isNotNull);
      });

      test('should return error for null name', () {
        final result = AuthValidators.validateName(null);
        expect(result, isNotNull);
      });

      test('should return error for single character name', () {
        final result = AuthValidators.validateName('A');
        expect(result, isNotNull);
      });

      test('should return error for name longer than 50 characters', () {
        final result =
            AuthValidators.validateName('A' * 51);
        expect(result, isNotNull);
      });

      test('should return error for name with numbers', () {
        final result = AuthValidators.validateName('John123');
        expect(result, isNotNull);
      });

      test('should return error for name with special characters', () {
        final result = AuthValidators.validateName('John@Doe');
        expect(result, isNotNull);
      });

      test('should accept name with spaces', () {
        final result = AuthValidators.validateName('Juan Pablo García');
        expect(result, isNull);
      });
    });

    group('validateRegisterForm', () {
      test('should return no errors for valid form', () {
        final result = AuthValidators.validateRegisterForm(
          email: 'test@example.com',
          password: 'Test@1234',
          confirmPassword: 'Test@1234',
          name: 'Test User',
        );

        expect(result['email'], isNull);
        expect(result['password'], isNull);
        expect(result['confirmPassword'], isNull);
        expect(result['name'], isNull);
      });

      test('should return errors for invalid form', () {
        final result = AuthValidators.validateRegisterForm(
          email: 'invalid',
          password: 'weak',
          confirmPassword: 'weak2',
          name: 'A',
        );

        expect(result['email'], isNotNull);
        expect(result['password'], isNotNull);
        expect(result['confirmPassword'], isNotNull);
        expect(result['name'], isNotNull);
      });
    });

    group('validateLoginForm', () {
      test('should return no errors for valid form', () {
        final result = AuthValidators.validateLoginForm(
          email: 'test@example.com',
          password: 'Test@1234',
        );

        expect(result['email'], isNull);
        expect(result['password'], isNull);
      });

      test('should return errors for invalid form', () {
        final result = AuthValidators.validateLoginForm(
          email: 'invalid',
          password: '',
        );

        expect(result['email'], isNotNull);
        expect(result['password'], isNotNull);
      });
    });
  });
}
