import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static double scaleForWidth(double width) {
    if (width < 360) return 0.9;
    if (width > 600) return 1.1;
    return 1.0;
  }

  static TextTheme textTheme(double scale) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      ),
      labelLarge: TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12 * scale,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10 * scale,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    );
  }

  static TextStyle appBarTitle(double scale) => TextStyle(
        fontSize: 20 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.onPrimary,
      );

  static TextStyle tabLabel(double scale, {required bool isActive}) => TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w600,
        color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
      );

  static TextStyle contactName(double scale) => TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle contactSubtitle(double scale) => TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle phoneNumber(double scale) => TextStyle(
        fontSize: 14 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle searchHint(double scale) => TextStyle(
        fontSize: 16 * scale,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );
}
