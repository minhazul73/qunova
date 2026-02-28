import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widgets/contact_list_item.dart';
import '../widgets/empty_state_widget.dart';

class RecentTab extends StatelessWidget {
  const RecentTab({
    super.key,
    required this.onAddContact,
  });

  final VoidCallback onAddContact;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      builder: (context, state) {
        if (state is! ContactsLoaded) {
          return const SizedBox.shrink();
        }

        final contacts = state.filteredRecentContacts;

        if (contacts.isEmpty) {
          return EmptyStateWidget(
            message: 'No recent contacts',
            onAddContact: onAddContact,
          );
        }

        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ContactListItem(
              contact: contact,
              onTap: () {
                context.read<ContactsBloc>().add(ContactOpenedEvent(contact.id));
                context.push(
                  RouteNames.contactDetailPath.replaceFirst(':id', contact.id),
                  extra: contact,
                );
              },
            );
          },
        );
      },
    );
  }
}
