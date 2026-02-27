import 'package:equatable/equatable.dart';

/// Base class for all contacts events
abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads all contacts from use case
class LoadContactsEvent extends ContactsEvent {
  const LoadContactsEvent();
}

/// Filters contacts by category ID
class FilterByCategoryEvent extends ContactsEvent {
  final String categoryId;

  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Searches contacts by query (name or phone)
class SearchContactsEvent extends ContactsEvent {
  final String query;

  const SearchContactsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Changes active tab (Contact / Recent)
class TabChangedEvent extends ContactsEvent {
  final ContactsTab tab;

  const TabChangedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

/// Records a contact as recently opened
class ContactOpenedEvent extends ContactsEvent {
  final String contactId;

  const ContactOpenedEvent(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

/// Submits a new contact from the add contact sheet
class AddContactSubmittedEvent extends ContactsEvent {
  final String name;
  final String phone;
  final String? designation;
  final String? company;
  final String? relation;

  const AddContactSubmittedEvent({
    required this.name,
    required this.phone,
    this.designation,
    this.company,
    this.relation,
  });

  @override
  List<Object?> get props => [name, phone, designation, company, relation];
}

/// Clears all filters and search
class ResetFiltersEvent extends ContactsEvent {
  const ResetFiltersEvent();
}

/// Enum for active tab
enum ContactsTab {
  contacts,
  recent,
}
