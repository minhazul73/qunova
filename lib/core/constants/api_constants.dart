class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.antripe.com/v1';
  static const String contactsEndpoint = '/contact/api.json';
  static String get contactsUrl => '$baseUrl$contactsEndpoint';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 15);
}
