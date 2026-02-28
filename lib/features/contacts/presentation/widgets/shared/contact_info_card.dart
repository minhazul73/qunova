import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/contact_entity.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({
    super.key,
    required this.contact,
    required this.categoryName,
    required this.addedLabel,
    required this.onCopyPhone,
    required this.onCopyId,
  });

  final ContactEntity contact;
  final String Function(String categoryId) categoryName;
  final String Function(DateTime date) addedLabel;
  final VoidCallback onCopyPhone;
  final VoidCallback onCopyId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 24.0,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      'Contact Information',
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0),
              if (contact.phone != null && contact.phone!.isNotEmpty)
                _ContactInfoTile(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: contact.phone!,
                  onTap: onCopyPhone,
                ),
              if (contact.subtitle != null && contact.subtitle!.isNotEmpty)
                _ContactInfoTile(
                  icon: Icons.description,
                  label: 'Details',
                  value: contact.subtitle!,
                ),
              if (contact.categoryId != null)
                _ContactInfoTile(
                  icon: Icons.label,
                  label: 'Category',
                  value: categoryName(contact.categoryId!),
                ),
              if (contact.createdAt != null)
                _ContactInfoTile(
                  icon: Icons.calendar_today,
                  label: 'Added',
                  value: addedLabel(contact.createdAt!),
                ),
              _ContactInfoTile(
                icon: Icons.tag,
                label: 'Contact ID',
                value: contact.id,
                onTap: onCopyId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.content_copy,
                color: AppColors.textHint,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }
}
