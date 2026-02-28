import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ContactPrimaryActions extends StatelessWidget {
  const ContactPrimaryActions({
    super.key,
    required this.onCall,
    required this.onMessage,
    required this.onEmail,
  });

  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ContactActionButton(
              icon: Icons.call,
              label: 'Call',
              color: AppColors.primary,
              onTap: onCall,
            ),
            _ContactActionButton(
              icon: Icons.message,
              label: 'Message',
              color: AppColors.primary,
              onTap: onMessage,
            ),
            _ContactActionButton(
              icon: Icons.email,
              label: 'Email',
              color: AppColors.primary,
              onTap: onEmail,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactActionButton extends StatelessWidget {
  const _ContactActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Material(
          color: color.withValues(alpha: 0.1),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Container(
              width: 64.0,
              height: 64.0,
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                icon,
                color: color,
                size: 28.0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
