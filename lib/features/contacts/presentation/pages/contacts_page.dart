import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_fab.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';
import '../tabs/contacts_tab.dart';
import '../tabs/recent_tab.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/loading_shimmer.dart';

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
    }
  }

  void _handleSearchChanged(String query) {
    context.read<ContactsBloc>().add(SearchContactsEvent(query));
  }

  void _handleSearchCleared() {
    context.read<ContactsBloc>().add(const SearchContactsEvent(''));
  }

  void _handleMenuTap() {
    // Menu action - placeholder
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocConsumer<ContactsBloc, ContactsState>(
        listener: (context, state) {
          // Handle side effects like showing snackbars
          if (state is ContactsError) {
            context.showSnackBar(
              state.message,
              backgroundColor: AppColors.error,
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
      floatingActionButton: CustomFab(
        onPressed: _showAddContactSheet,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      tabController: _tabController,
      tabLabels: const ['Contact', 'Recent'],
      onSearchChanged: _handleSearchChanged,
      onSearchCleared: _handleSearchCleared,
      onMenuTap: _handleMenuTap,
      searchHint: 'Search contacts...',
    );
  }

  Widget _buildLoadedState(ContactsLoaded state) {
    return TabBarView(
      controller: _tabController,
      children: [
        AllContactsTab(
          onAddContact: _showAddContactSheet,
        ),
        RecentTab(
          onAddContact: _showAddContactSheet,
        ),
      ],
    );
  }
}
