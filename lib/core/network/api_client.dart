import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

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

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

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

    if (statusCode >= 400 && statusCode < 500) {
      throw ClientException(
        _extractErrorMessage(response.body) ?? 'Client error',
        statusCode,
      );
    }

    if (statusCode >= 500) {
      throw ServerException(
        _extractErrorMessage(response.body) ?? 'Server error',
        statusCode,
      );
    }

    throw UnknownException('Unexpected status code: $statusCode');
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] as String? ??
            decoded['error'] as String? ??
            decoded['msg'] as String?;
      }
    } catch (_) {}
    return null;
  }

  void dispose() {
    _client.close();
  }
}
