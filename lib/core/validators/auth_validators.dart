/// Validadores para autenticación
abstract class AuthValidators {
  /// Valida que el email sea válido
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'El email es requerido';
    }

    const emailPattern =
        r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';
    final regex = RegExp(emailPattern);

    if (!regex.hasMatch(email)) {
      return 'Por favor ingresa un email válido';
    }

    return null;
  }

  /// Valida que la contraseña cumpla con los requisitos mínimos
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'La contraseña debe contener al menos un número';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'La contraseña debe contener al menos un carácter especial';
    }

    return null;
  }

  /// Valida que la contraseña de confirmación coincida
  static String? validatePasswordMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Por favor confirma tu contraseña';
    }

    if (password != confirmPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida que el nombre no esté vacío
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'El nombre es requerido';
    }

    if (name.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (name.length > 50) {
      return 'El nombre no puede exceder 50 caracteres';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'El nombre solo puede contener letras y espacios';
    }

    return null;
  }

  /// Valida todos los campos de registro
  static Map<String, String?> validateRegisterForm({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
      'confirmPassword': validatePasswordMatch(password, confirmPassword),
      'name': validateName(name),
    };
  }

  /// Valida todos los campos de login
  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': password.isEmpty ? 'La contraseña es requerida' : null,
    };
  }
}
