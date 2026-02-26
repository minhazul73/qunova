/// Custom exception classes for API errors
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception for network connectivity issues
class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for request timeout
class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timeout']);

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception for server errors (5xx)
class ServerException extends ApiException {
  const ServerException([super.message = 'Server error', super.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception for client errors (4xx)
class ClientException extends ApiException {
  const ClientException([super.message = 'Client error', super.statusCode]);

  @override
  String toString() => 'ClientException: $message (Status: $statusCode)';
}

/// Exception for JSON parsing errors
class ParseException extends ApiException {
  const ParseException([super.message = 'Failed to parse response']);

  @override
  String toString() => 'ParseException: $message';
}

/// Exception for unknown/unexpected errors
class UnknownException extends ApiException {
  const UnknownException([super.message = 'An unknown error occurred']);

  @override
  String toString() => 'UnknownException: $message';
}
