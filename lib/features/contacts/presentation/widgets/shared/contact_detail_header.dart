import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/contact_entity.dart';

class ContactDetailHeader extends StatelessWidget {
  const ContactDetailHeader({
    super.key,
    required this.contact,
    required this.onBack,
  });

  final ContactEntity contact;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack,
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60.0),
              _ContactLargeAvatar(contact: contact),
              const SizedBox(height: 16.0),
              Text(
                contact.name ?? 'Unknown Contact',
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),
              if (contact.status != null && contact.status!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    contact.status!,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactLargeAvatar extends StatelessWidget {
  const _ContactLargeAvatar({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 4.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: contact.avatarUrl != null && contact.avatarUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: contact.avatarUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.primaryLight,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => _buildInitialsCircle(110),
              )
            : _buildInitialsCircle(110),
      ),
    );
  }

  Widget _buildInitialsCircle(double size) {
    final initials = _getInitials(contact.name ?? 'U');
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) {
      return 'U';
    }
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }
}
