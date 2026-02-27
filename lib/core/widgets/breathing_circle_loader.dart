import 'dart:ui';

import 'package:flutter/material.dart';

class BreathingCircleLoader extends StatelessWidget {
  final String imagePath;
  final double size;
  final double borderRadius;

  const BreathingCircleLoader({
    super.key,
    required this.imagePath,
    this.size = 60.0,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 6, sigmaX: 10),
      child: Card(
        elevation: 2,
        shape: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: size + borderRadius,
          height: size + borderRadius,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

