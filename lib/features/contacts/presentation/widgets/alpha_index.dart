import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A-Z alphabetic index widget (visual-only)
///
/// Displays a vertical list of letters A-Z on the right side of the screen.
/// This is purely decorative and does not implement scroll-to-letter functionality.
class AlphaIndex extends StatelessWidget {
  const AlphaIndex({super.key});

  static const _alphabet = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8.0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          width: 24.0,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: _alphabet.map((letter) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
