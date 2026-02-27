import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/category_chip.dart';
import '../widgets/contact_list_item.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/contacts_tab_list.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/search_bar_widget.dart';

/// Main contacts page with tabs, search, filtering, and contact list
///
/// Displays contacts with category filtering, search functionality,
/// and tabbed view for all contacts and recent contacts.
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  static const String name = 'contacts';

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load contacts when page initializes
    context.read<ContactsBloc>().add(const LoadContactsEvent());
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final tab = _tabController.index == 0
          ? ContactsTab.contacts
          : ContactsTab.recent;
      context.read<ContactsBloc>().add(TabChangedEvent(tab));

      // Hide search when switching tabs
      if (_isSearchActive) {
        setState(() => _isSearchActive = false);
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        // Clear search when hiding search bar
        context.read<ContactsBloc>().add(const SearchContactsEvent(''));
      }
    });
  }


  void _showAddContactSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return AddContactSheet(
          onSave: ({
            required String name,
            required String phone,
            String? designation,
            String? company,
            String? relation,
          }) {
            context.read<ContactsBloc>().add(
              AddContactSubmittedEvent(
                name: name,
                phone: phone,
                designation: designation,
                company: company,
                relation: relation,
              ),
            );
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) {
          // Handle side effects like showing snackbars
          if (state is ContactsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ContactsLoading) {
            return const LoadingShimmer();
          }

          if (state is ContactsError) {
            return ErrorStateWidget(
              message: state.message,
              onRetry: () {
                context.read<ContactsBloc>().add(const LoadContactsEvent());
              },
            );
          }

          if (state is ContactsLoaded) {
            return _buildLoadedState(state);
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactSheet,
        backgroundColor: AppColors.fab,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 2,
      title: _isSearchActive
          ? TextField(
              onChanged: (query) {
                context.read<ContactsBloc>().add(SearchContactsEvent(query));
              },
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(color: AppColors.onPrimary),
            )
          : const Text(
              'Antripe',
              style: TextStyle(
                color: AppColors.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearchActive ? Icons.close : Icons.search,
            color: AppColors.onPrimary,
          ),
          onPressed: _toggleSearch,
        ),
        if (!_isSearchActive)
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.onPrimary,
            ),
            onPressed: () {
              // Menu action - placeholder for now
            },
          ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.onPrimary,
        indicatorWeight: 2,
        isScrollable: false,
        labelColor: AppColors.tabActive,
        unselectedLabelColor: AppColors.tabInactive,
        tabs: const [
          Tab(text: 'Contact'),
          Tab(text: 'Recent'),
        ],
      ),
    );
  }

  Widget _buildLoadedState(ContactsLoaded state) {
    return Column(
      children: [
        // Category chips (only show on Contact tab)
        if (state.activeTab == ContactsTab.contacts)
          _buildCategoryChips(state),

        // Contact list
        Expanded(
          child: _buildContactList(state),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(ContactsLoaded state) {
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
    final contacts = state.displayedContacts;

    if (state.activeTab == ContactsTab.contacts) {
      return ContactsTabList(
        contacts: contacts,
        searchQuery: state.searchQuery,
        onAddContact: _showAddContactSheet,
      );
    }

    // Recent tab: simple list
    if (contacts.isEmpty) {
      return EmptyStateWidget(
        message: 'No recent contacts',
        onAddContact: _showAddContactSheet,
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
          },
        );
      },
    );
  }
}
