import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/az_contact_item.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../../domain/entities/contact_entity.dart';
import 'contact_list_item.dart';
import 'empty_state_widget.dart';

class ContactsTabList extends StatelessWidget {
  final List<ContactEntity> contacts;
  final String searchQuery;
  final VoidCallback onAddContact;

  const ContactsTabList({
    super.key,
    required this.contacts,
    required this.searchQuery,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return EmptyStateWidget(
        message: searchQuery.isNotEmpty
            ? 'No contacts found for "$searchQuery"'
            : 'Ee! No Contacts found.',
        onAddContact: onAddContact,
      );
    }

    final azItems = contacts.map(AzContactItem.fromEntity).toList();

    SuspensionUtil.sortListBySuspensionTag(azItems);
    azItems.sort((a, b) {
      final tagCompare = a.tag.compareTo(b.tag);
      if (tagCompare != 0) {
        return tagCompare;
      }
      return a.normalizedName.compareTo(b.normalizedName);
    });

    return MediaQuery.removeViewInsets(
      context: context,
      removeBottom: true,
      child: AzListView(
        data: azItems,
        itemCount: azItems.length,
        itemBuilder: (context, index) {
          final item = azItems[index];
          return ContactListItem(
            contact: item.contact,
            onTap: () {
              context
                  .read<ContactsBloc>()
                  .add(ContactOpenedEvent(item.contact.id));
              context.push(
                RouteNames.contactDetailPath.replaceFirst(':id', item.contact.id),
                extra: item.contact,
              );
            },
          );
        },
        indexBarData: const [
          'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
          'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#',
        ],
        susItemBuilder: (context, index) => const SizedBox.shrink(),
        indexBarOptions: const IndexBarOptions(
          needRebuild: true,
          hapticFeedback: true,
          indexHintAlignment: Alignment.centerRight,
          textStyle: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          selectTextStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1,
          ),
        ),
      ),
    );
  }
}
