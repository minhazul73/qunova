import 'package:flutter/material.dart';

/// String extensions for common operations
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Check if string is a valid phone number (basic validation)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    return phoneRegex.hasMatch(this) && replaceAll(RegExp(r'\D'), '').length >= 10;
  }

  /// Check if string is empty or contains only whitespace
  bool get isBlank {
    return trim().isEmpty;
  }
}

/// BuildContext extensions for easier navigation and theming
extension BuildContextExtensions on BuildContext {
  /// Get MediaQuery data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Show SnackBar with message
  void showSnackBar(
    String message, {
    Duration? duration,
    Color? backgroundColor,
    SnackBarBehavior? behavior,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        backgroundColor: backgroundColor,
        behavior: behavior,
      ),
    );
  }
}
