import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ContactSecondaryActionsCard extends StatelessWidget {
  const ContactSecondaryActionsCard({
    super.key,
    required this.onEdit,
    required this.onShare,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Edit Contact',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onEdit,
              ),
              const Divider(height: 1.0),
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: AppColors.primary,
                ),
                title: Text(
                  'Share Contact',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onShare,
              ),
              const Divider(height: 1.0),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                ),
                title: Text(
                  'Delete Contact',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
