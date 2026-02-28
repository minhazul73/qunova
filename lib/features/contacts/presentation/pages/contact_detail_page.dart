import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/contact_entity.dart';
import '../widgets/shared/contact_detail_header.dart';
import '../widgets/shared/contact_info_card.dart';
import '../widgets/shared/contact_primary_actions.dart';
import '../widgets/shared/contact_secondary_actions_card.dart';

/// Contact detail page displaying comprehensive contact information.
class ContactDetailPage extends StatelessWidget {
  static const String name = 'contact-detail';

  const ContactDetailPage({
    super.key,
    required this.contact,
  });

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          ContactDetailHeader(
            contact: contact,
            onBack: () => Navigator.of(context).pop(),
          ),
          ContactPrimaryActions(
            onCall: () => _handleCallAction(context),
            onMessage: () => _handleMessageAction(context),
            onEmail: () => _handleEmailAction(context),
          ),
          ContactInfoCard(
            contact: contact,
            categoryName: _getCategoryName,
            addedLabel: _formatDate,
            onCopyPhone: () => _copyToClipboard(
              context,
              contact.phone!,
              'Phone number',
            ),
            onCopyId: () => _copyToClipboard(
              context,
              contact.id,
              'Contact ID',
            ),
          ),
          ContactSecondaryActionsCard(
            onEdit: () => _handleEditContact(context),
            onShare: () => _handleShareContact(context),
            onDelete: () => _handleDeleteContact(context),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32.0),
          ),
        ],
      ),
    );
  }

  String _getCategoryName(String categoryId) {
    return categoryId;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    }
    if (difference.inDays == 1) {
      return 'Yesterday';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    return DateFormat('MMM d, yyyy').format(date);
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    context.showSnackBar(
      '$label copied to clipboard',
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
  }

  void _handleCallAction(BuildContext context) {
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      context.showSnackBar(
        'Calling ${contact.phone}...',
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      );
      return;
    }

    context.showSnackBar(
      'No phone number available',
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleMessageAction(BuildContext context) {
    if (contact.phone != null && contact.phone!.isNotEmpty) {
      context.showSnackBar(
        'Opening messages to ${contact.phone}...',
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      );
      return;
    }

    context.showSnackBar(
      'No phone number available',
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleEmailAction(BuildContext context) {
    context.showSnackBar(
      'Opening email...',
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleEditContact(BuildContext context) {
    context.showSnackBar(
      'Edit contact feature coming soon...',
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleShareContact(BuildContext context) {
    context.showSnackBar(
      'Sharing ${contact.name}...',
      backgroundColor: AppColors.primary,
      behavior: SnackBarBehavior.floating,
    );
  }

  void _handleDeleteContact(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete ${contact.name ?? "this contact"}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              context.showSnackBar(
                'Contact deleted',
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
