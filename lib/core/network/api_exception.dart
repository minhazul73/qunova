abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timeout']);

  @override
  String toString() => 'TimeoutException: $message';
}

class ServerException extends ApiException {
  const ServerException([super.message = 'Server error', super.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class ClientException extends ApiException {
  const ClientException([super.message = 'Client error', super.statusCode]);

  @override
  String toString() => 'ClientException: $message (Status: $statusCode)';
}

class ParseException extends ApiException {
  const ParseException([super.message = 'Failed to parse response']);

  @override
  String toString() => 'ParseException: $message';
}

class UnknownException extends ApiException {
  const UnknownException([super.message = 'An unknown error occurred']);

  @override
  String toString() => 'UnknownException: $message';
}
