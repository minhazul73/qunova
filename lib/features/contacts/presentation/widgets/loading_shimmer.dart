import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Loading shimmer widget for contact list items
///
/// Displays a skeleton loading state that matches the layout of ContactListItem.
/// Uses built-in Flutter animations without external packages.
class LoadingShimmer extends StatefulWidget {
  final int itemCount;

  const LoadingShimmer({
    super.key,
    this.itemCount = 8,
  });

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return _ShimmerItem(
              gradientPosition: _animation.value,
            );
          },
        );
      },
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final double gradientPosition;

  const _ShimmerItem({
    required this.gradientPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar shimmer
              _buildShimmerBox(40.0, 40.0, isCircle: true),
              const SizedBox(width: 16.0),
              // Text shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(200.0, 16.0),
                    const SizedBox(height: 6.0),
                    _buildShimmerBox(150.0, 14.0),
                  ],
                ),
              ),
            ],
          ),
          // Divider
          Container(
            margin: const EdgeInsets.only(left: 56.0, top: 12.0),
            height: 1.0,
            color: AppColors.divider.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(
    double boxWidth,
    double height, {
    bool isCircle = false,
  }) {
    return Container(
      width: boxWidth,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [
            (gradientPosition - 0.3).clamp(0.0, 1.0),
            (gradientPosition).clamp(0.0, 1.0),
            (gradientPosition + 0.3).clamp(0.0, 1.0),
          ],
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF5F5F5),
            Color(0xFFE0E0E0),
          ],
        ),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(4.0),
      ),
    );
  }
}
