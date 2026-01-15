extension StringExtensions on String {
  /// Check if email is valid
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if password is strong
  bool get isStrongPassword {
    return length >= 8 &&
        contains(RegExp(r'[A-Z]')) &&
        contains(RegExp(r'[a-z]')) &&
        contains(RegExp(r'[0-9]'));
  }

  /// Check if string is empty or null
  bool get isEmpty => trim().isEmpty;

  /// Check if string is not empty
  bool get isNotEmpty => trim().isNotEmpty;

  /// Capitalize first letter
  String get capitalized => isNotEmpty
      ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
      : '';

  /// Check if string contains only letters and spaces
  bool get isAlphabetic {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this);
  }
}
