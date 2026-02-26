import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Lightweight logging wrapper using dart:developer
///
/// Only logs in debug mode to avoid performance impact in release builds.
class AppLog {
  AppLog._();

  /// Log debug message
  static void d(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'Debug',
        level: 500, // Debug level
      );
    }
  }

  /// Log info message
  static void i(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'Info',
        level: 800, // Info level
      );
    }
  }

  /// Log warning message
  static void w(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'Warning',
        level: 900, // Warning level
      );
    }
  }

  /// Log error message
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        message,
        name: tag ?? 'Error',
        level: 1000, // Error level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
