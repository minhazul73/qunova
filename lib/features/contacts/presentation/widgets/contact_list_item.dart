import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/contact_entity.dart';

/// Contact list item widget displaying avatar, name, subtitle, and phone
///
/// Shows a horizontal layout with circular avatar on the left,
/// contact information in the middle, and a divider at the bottom.
class ContactListItem extends StatelessWidget {
  final ContactEntity contact;
  final VoidCallback? onTap;

  const ContactListItem({
    super.key,
    required this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    _buildAvatar(),
                    const SizedBox(width: 16.0),
                    // Contact Information
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            contact.name ?? 'Unknown',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          // Phone Number
                          if (contact.phone != null &&
                              contact.phone!.isNotEmpty)
                            Text(
                              contact.phone!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          // Phone (if no subtitle)
                          if ((contact.subtitle == null ||
                                  contact.subtitle!.isEmpty) &&
                              contact.phone != null &&
                              contact.phone!.isNotEmpty)
                            Text(
                              contact.phone!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Divider
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 24.0, right: 32.0),
          height: 1.0,
          color: AppColors.divider,
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.chipUnselectedBackground,
      ),
      child: ClipOval(
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: contact.avatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    // Use first letter of name as placeholder
    final initial = (contact.name?.isNotEmpty == true)
        ? contact.name![0].toUpperCase()
        : '?';

    return Container(
      color: _getAvatarColor(),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    // Generate color based on contact ID for consistency
    final colors = [
      const Color(0xFF42A5F5), // Blue
      const Color(0xFFEC407A), // Pink
      const Color(0xFF66BB6A), // Green
      const Color(0xFFAB47BC), // Purple
      const Color(0xFFFF7043), // Orange
      const Color(0xFF26C6DA), // Cyan
      const Color(0xFFEF5350), // Red
      const Color(0xFF9CCC65), // Light Green
    ];

    final hash = contact.id.hashCode.abs();
    return colors[hash % colors.length];
  }
}
