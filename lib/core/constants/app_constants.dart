class AppConstants {
  // App Info
  static const String appName = 'Hábitos Saludables';
  static const String appVersion = '1.0.0';
  
  // Firebase Config
  static const String firebaseProjectId = 'habitos-saludables';
  
  // API Endpoints
  static const String baseUrl = 'https://api.habitossaludables.com';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Database
  static const String habitCollection = 'habits';
  static const String userCollection = 'users';
  static const String trackingCollection = 'tracking';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String darkModeKey = 'dark_mode';
}
