import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/logging/app_log.dart';
import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/get_recent_contacts_usecase.dart';
import '../../domain/usecases/mark_contact_opened_usecase.dart';
import 'contacts_event.dart';
import 'contacts_state.dart';

/// BLoC for managing contacts state and business logic
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetRecentContactsUseCase _getRecentContactsUseCase;
  final MarkContactOpenedUseCase _markContactOpenedUseCase;
  final AddContactUseCase _addContactUseCase;
  final ContactRepository _repository;

  /// Debouncer for search input (300ms delay)
  late final Debouncer _searchDebouncer;

  ContactsBloc({
    required GetRecentContactsUseCase getRecentContactsUseCase,
    required MarkContactOpenedUseCase markContactOpenedUseCase,
    required AddContactUseCase addContactUseCase,
    required ContactRepository repository,
  })  : _getRecentContactsUseCase = getRecentContactsUseCase,
        _markContactOpenedUseCase = markContactOpenedUseCase,
        _addContactUseCase = addContactUseCase,
        _repository = repository,
        super(const ContactsInitial()) {
    _initDebouncer();
    _registerEventHandlers();
  }

  /// Initializes the search debouncer
  void _initDebouncer() {
    // Debouncer initialized but not used in simple implementation
    // Can be enabled for performance optimization in search-heavy scenarios
    _searchDebouncer = Debouncer(
      duration: const Duration(milliseconds: 300),
    );
  }

  /// Registers all event handlers
  void _registerEventHandlers() {
    on<LoadContactsEvent>(_onLoadContacts);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<SearchContactsEvent>(_onSearchContacts);
    on<TabChangedEvent>(_onTabChanged);
    on<ContactOpenedEvent>(_onContactOpened);
    on<AddContactSubmittedEvent>(_onAddContactSubmitted);
    on<ResetFiltersEvent>(_onResetFilters);
  }

  /// Handles loading contacts from use case
  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      emit(const ContactsLoading());
      AppLog.d('ContactsBloc: Loading contacts');

      // Fetch contacts and recent contacts in parallel
      final contactsData = await _repository.getContacts();
      final recentContacts = await _getRecentContactsUseCase.call();

      AppLog.d(
        'ContactsBloc: Loaded ${contactsData.contacts.length} contacts '
        'and ${recentContacts.length} recent contacts',
      );

      emit(
        ContactsLoaded(
          allContacts: contactsData.contacts,
          recentContacts: recentContacts,
          displayedContacts: contactsData.contacts,
          categories: contactsData.categories,
          selectedCategoryId: 'all',
          searchQuery: '',
          activeTab: ContactsTab.contacts,
        ),
      );
    } catch (e) {
      AppLog.e('ContactsBloc: Error loading contacts: $e');
      emit(ContactsError('Failed to load contacts: $e'));
    }
  }

  /// Handles category filter selection
  Future<void> _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    try {
      AppLog.d('ContactsBloc: Filtering by category: ${event.categoryId}');

      // Start with all contacts
      var filtered = <ContactEntity>[...currentState.allContacts];

      // Apply category filter (except "all")
      if (event.categoryId != 'all') {
        filtered = filtered
            .where((final c) => c.categoryId == event.categoryId)
            .toList();
      }

      // Apply search filter if active
      if (currentState.searchQuery.isNotEmpty) {
        final lowerQuery = currentState.searchQuery.toLowerCase();
        filtered = filtered
            .where((final contact) {
              final nameMatch = (contact.name ?? '')
                  .toLowerCase()
                  .contains(lowerQuery);
              final phoneMatch =
                  (contact.phone ?? '').contains(currentState.searchQuery);
              return nameMatch || phoneMatch;
            })
            .toList();
      }

      final updatedState = currentState.copyWith(
        selectedCategoryId: event.categoryId,
        displayedContacts: filtered,
      );
      emit(updatedState);
    } catch (e) {
      AppLog.e('ContactsBloc: Error filtering by category: $e');
      emit(ContactsError('Failed to filter contacts: $e'));
    }
  }

  /// Handles search input with debouncing
  Future<void> _onSearchContacts(
    SearchContactsEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    try {
      AppLog.d('ContactsBloc: Search query: "${event.query}"');

      // Start with all contacts
      var filtered = <ContactEntity>[...currentState.allContacts];

      // Apply category filter (except "all")
      if (currentState.selectedCategoryId != 'all') {
        filtered = filtered
            .where(
              (final c) => c.categoryId == currentState.selectedCategoryId,
            )
            .toList();
      }

      // Apply search filter
      if (event.query.isNotEmpty) {
        final lowerQuery = event.query.toLowerCase();
        filtered = filtered
            .where((final contact) {
              final nameMatch = (contact.name ?? '')
                  .toLowerCase()
                  .contains(lowerQuery);
              final phoneMatch = (contact.phone ?? '').contains(event.query);
              return nameMatch || phoneMatch;
            })
            .toList();
      }

      // Update state with search results
      final updatedState = currentState.copyWith(
        searchQuery: event.query,
        isSearchActive: event.query.isNotEmpty,
        displayedContacts: filtered,
      );
      emit(updatedState);
    } catch (e) {
      AppLog.e('ContactsBloc: Error handling search: $e');
      emit(ContactsError('Search failed: $e'));
    }
  }

  /// Handles tab change (Contact / Recent)
  Future<void> _onTabChanged(
    TabChangedEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    try {
      AppLog.d('ContactsBloc: Tab changed to ${event.tab.name}');

      // Determine what to display based on tab
      final displayedContacts = event.tab == ContactsTab.recent
          ? currentState.recentContacts
          : currentState.allContacts;

      // Clear search and filters when switching tabs
      final updatedState = currentState.copyWith(
        activeTab: event.tab,
        displayedContacts: displayedContacts,
        searchQuery: '',
        selectedCategoryId: 'all',
        isSearchActive: false,
      );
      emit(updatedState);
    } catch (e) {
      AppLog.e('ContactsBloc: Error changing tab: $e');
      emit(ContactsError('Failed to change tab: $e'));
    }
  }

  /// Handles marking a contact as opened (for recent history)
  Future<void> _onContactOpened(
    ContactOpenedEvent event,
    Emitter<ContactsState> emit,
  ) async {
    try {
      AppLog.d('ContactsBloc: Recording contact opened: ${event.contactId}');

      final bool success = await _markContactOpenedUseCase.call(event.contactId);

      if (success) {
        AppLog.d('ContactsBloc: Contact opened recorded successfully');

        // Optionally reload recent contacts
        if (state is ContactsLoaded) {
          final updatedRecents =
              await _getRecentContactsUseCase.call();
          final currentState = state as ContactsLoaded;

          emit(currentState.copyWith(recentContacts: updatedRecents));
        }
      } else {
        AppLog.w('ContactsBloc: Failed to record contact opened');
      }
    } catch (e) {
      AppLog.e('ContactsBloc: Error recording contact opened: $e');
      // Don't emit error state for this non-critical operation
    }
  }

  /// Handles adding a new contact
  Future<void> _onAddContactSubmitted(
    AddContactSubmittedEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    try {
      AppLog.d('ContactsBloc: Submitting new contact: ${event.name}');

      final bool success = await _addContactUseCase.call(
        name: event.name,
        phone: event.phone,
        designation: event.designation,
        company: event.company,
        relation: event.relation,
      );

      if (success) {
        AppLog.d('ContactsBloc: Contact added successfully');

        // Reload contacts to include the new one
        add(const LoadContactsEvent());
      } else {
        AppLog.w('ContactsBloc: Failed to add contact');
        emit(const ContactsError('Failed to add contact'));
      }
    } catch (e) {
      AppLog.e('ContactsBloc: Error adding contact: $e');
      emit(ContactsError('Failed to add contact: $e'));
    }
  }

  /// Resets all filters and search
  Future<void> _onResetFilters(
    ResetFiltersEvent event,
    Emitter<ContactsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ContactsLoaded) return;

    try {
      AppLog.d('ContactsBloc: Resetting all filters and search');

      final updatedState = currentState.copyWith(
        displayedContacts: currentState.allContacts,
        selectedCategoryId: 'all',
        searchQuery: '',
        isSearchActive: false,
      );
      emit(updatedState);
    } catch (e) {
      AppLog.e('ContactsBloc: Error resetting filters: $e');
      emit(ContactsError('Failed to reset filters: $e'));
    }
  }

  @override
  Future<void> close() {
    _searchDebouncer.dispose();
    return super.close();
  }
}
