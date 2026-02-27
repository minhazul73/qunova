import 'package:flutter/material.dart';

class AnimatedCircle extends StatelessWidget {
  final double duration;
  final Curve curve;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double size;
  final Color color;

  const AnimatedCircle({
    super.key,
    required this.duration,
    this.curve = Curves.linearToEaseOut,
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: duration.toInt()),
      curve: curve,
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration.toInt()),
        curve: curve,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
