/// API endpoint constants for the Antripe Contact App
class ApiConstants {
  ApiConstants._();

  /// Base URL for the Antripe API
  static const String baseUrl = 'https://api.antripe.com/v1';

  /// Contacts endpoint
  static const String contactsEndpoint = '/contact/api.json';

  /// Full contacts URL
  static String get contactsUrl => '$baseUrl$contactsEndpoint';

  /// API request timeout duration
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Connection timeout duration
  static const Duration connectionTimeout = Duration(seconds: 15);
}
