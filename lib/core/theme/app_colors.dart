import 'package:flutter/material.dart';

/// App color palette based on provided screenshots
class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFF00897B);
  static const Color primaryDark = Color(0xFF00796B);
  static const Color primaryLight = Color(0xFFE0F2F1);

  // Neutrals
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE0E0E0);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Chips
  static const Color chipSelectedBackground = primaryLight;
  static const Color chipSelectedBorder = primary;
  static const Color chipSelectedText = primary;
  static const Color chipUnselectedBackground = Color(0xFFF5F5F5);
  static const Color chipUnselectedBorder = Color(0xFFE0E0E0);
  static const Color chipUnselectedText = textSecondary;

  // Buttons
  static const Color fab = primary;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = textPrimary;

  // Status
  static const Color error = Color(0xFFD32F2F);
}
