import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? description;
  final VoidCallback? onAddContact;
  final bool showAddButton;

  const EmptyStateWidget({
    super.key,
    this.message = 'Ee! No Contacts found.',
    this.description,
    this.onAddContact,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty icon
            Icon(
              Icons.person_search_outlined,
              size: 80.0,
              color: AppColors.textHint.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24.0),
            // Message
            Text(
              message,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            // Description (optional)
            if (description != null) ...[
              const SizedBox(height: 8.0),
              Text(
                description!,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            // Add Contact Button
            if (showAddButton && onAddContact != null) ...[
              const SizedBox(height: 32.0),
              SizedBox(
                width: 200.0,
                height: 48.0,
                child: ElevatedButton.icon(
                  onPressed: onAddContact,
                  icon: const Icon(Icons.add, size: 20.0),
                  label: const Text('Add New Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    textStyle: textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
