import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widgets/category_chip.dart';
import '../widgets/contacts_tab_list.dart';

/// Contacts tab view displaying all contacts with category filtering
class AllContactsTab extends StatelessWidget {
  const AllContactsTab({
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

        return Column(
          children: [
            // Category chips
            _buildCategoryChips(context, state),

            // Contact list
            Expanded(
              child: _buildContactList(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChips(BuildContext context, ContactsLoaded state) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final isSelected = category.id == state.selectedCategoryId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: CategoryChip(
              categoryId: category.id,
              categoryName: category.name,
              isSelected: isSelected,
              onTap: () {
                context
                    .read<ContactsBloc>()
                    .add(FilterByCategoryEvent(category.id));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactList(ContactsLoaded state) {
    final contacts = state.filteredAllContacts;

    return ContactsTabList(
      contacts: contacts,
      searchQuery: state.searchQuery,
      onAddContact: onAddContact,
    );
  }
}
