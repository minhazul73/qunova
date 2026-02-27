import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Category filter chip with avatar and label
///
/// Displays a vertical layout with circular avatar on top and label below.
/// Supports selected/unselected states with smooth animations.
class CategoryChip extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String? avatarUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.avatarUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimationDuration,
        curve: Curves.easeOut,
        width: 76.0,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar Circle
            AnimatedContainer(
              duration: AppConstants.shortAnimationDuration,
              curve: Curves.easeOut,
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.chipSelectedBackground
                    : AppColors.chipUnselectedBackground,
                border: Border.all(
                  color: isSelected
                      ? AppColors.chipSelectedBorder
                      : AppColors.chipUnselectedBorder,
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: _buildAvatarContent(),
              ),
            ),
            const SizedBox(height: 6.0),
            // Label
            Text(
              categoryName,
              style: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppColors.chipSelectedText
                    : AppColors.chipUnselectedText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: isSelected
          ? AppColors.chipSelectedBackground
          : AppColors.chipUnselectedBackground,
      child: Icon(
        _getCategoryIcon(),
        color: isSelected
            ? AppColors.chipSelectedText
            : AppColors.chipUnselectedText,
        size: 24.0,
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (categoryId.toLowerCase()) {
      case 'all':
        return Icons.people_outline;
      case 'family':
        return Icons.home_outlined;
      case 'friends':
        return Icons.favorite_outline;
      case 'work':
        return Icons.work_outline;
      case 'clients':
        return Icons.business_center_outlined;
      case 'vip':
        return Icons.stars_outlined;
      case 'blocked':
        return Icons.block_outlined;
      default:
        return Icons.person_outline;
    }
  }
}
