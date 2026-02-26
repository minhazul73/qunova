import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_exception.dart';

/// HTTP client wrapper for API calls with error handling
class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Perform a GET request
  ///
  /// Returns the decoded JSON response body as a Map.
  /// Throws appropriate [ApiException] subclasses on failure.
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _client
          .get(
            Uri.parse(url),
            headers: headers,
          )
          .timeout(
            ApiConstants.requestTimeout,
            onTimeout: () {
              throw const TimeoutException();
            },
          );

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Perform a POST request
  ///
  /// Returns the decoded JSON response body as a Map.
  /// Throws appropriate [ApiException] subclasses on failure.
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(
            ApiConstants.requestTimeout,
            onTimeout: () {
              throw const TimeoutException();
            },
          );

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  /// Handle HTTP response and convert to appropriate exception if needed
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Success (2xx)
    if (statusCode >= 200 && statusCode < 300) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        } else {
          throw const ParseException('Response is not a JSON object');
        }
      } catch (e) {
        if (e is ApiException) rethrow;
        throw ParseException('Failed to decode JSON: ${e.toString()}');
      }
    }

    // Client errors (4xx)
    if (statusCode >= 400 && statusCode < 500) {
      throw ClientException(
        _extractErrorMessage(response.body) ?? 'Client error',
        statusCode,
      );
    }

    // Server errors (5xx)
    if (statusCode >= 500) {
      throw ServerException(
        _extractErrorMessage(response.body) ?? 'Server error',
        statusCode,
      );
    }

    throw UnknownException('Unexpected status code: $statusCode');
  }

  /// Try to extract error message from response body
  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] as String? ??
            decoded['error'] as String? ??
            decoded['msg'] as String?;
      }
    } catch (_) {
      // If parsing fails, return null
    }
    return null;
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
