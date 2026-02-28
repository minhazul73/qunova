import 'package:equatable/equatable.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/contact_entity.dart';
import 'contacts_event.dart';

/// Base class for all contacts states
abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

class ContactsLoaded extends ContactsState {
  /// All contacts combined (remote + local)
  final List<ContactEntity> allContacts;

  /// Recently opened contacts
  final List<ContactEntity> recentContacts;

  /// Filtered contacts for the Contacts tab (with category and search applied)
  final List<ContactEntity> filteredAllContacts;

  /// Filtered recent contacts for the Recent tab (with search applied)
  final List<ContactEntity> filteredRecentContacts;

  /// All available categories
  final List<CategoryEntity> categories;

  /// Currently selected category ID
  final String selectedCategoryId;

  /// Current search query
  final String searchQuery;

  /// Active tab (contacts or recent)
  final ContactsTab activeTab;

  /// whether search field is active
  final bool isSearchActive;

  const ContactsLoaded({
    required this.allContacts,
    required this.recentContacts,
    required this.filteredAllContacts,
    required this.filteredRecentContacts,
    required this.categories,
    required this.selectedCategoryId,
    required this.searchQuery,
    required this.activeTab,
    this.isSearchActive = false,
  });

  @override
  List<Object?> get props => [
    allContacts,
    recentContacts,
    filteredAllContacts,
    filteredRecentContacts,
    categories,
    selectedCategoryId,
    searchQuery,
    activeTab,
    isSearchActive,
  ];

  /// Creates a copy with potentially updated fields
  ContactsLoaded copyWith({
    List<ContactEntity>? allContacts,
    List<ContactEntity>? recentContacts,
    List<ContactEntity>? filteredAllContacts,
    List<ContactEntity>? filteredRecentContacts,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    String? searchQuery,
    ContactsTab? activeTab,
    bool? isSearchActive,
  }) {
    return ContactsLoaded(
      allContacts: allContacts ?? this.allContacts,
      recentContacts: recentContacts ?? this.recentContacts,
      filteredAllContacts: filteredAllContacts ?? this.filteredAllContacts,
      filteredRecentContacts: filteredRecentContacts ?? this.filteredRecentContacts,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      activeTab: activeTab ?? this.activeTab,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }
}

/// Error state when something goes wrong
class ContactsError extends ContactsState {
  final String message;

  const ContactsError(this.message);

  @override
  List<Object?> get props => [message];
}
