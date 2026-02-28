import 'package:equatable/equatable.dart';

/// Base class for all contacts events
abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object?> get props => [];
}

class LoadContactsEvent extends ContactsEvent {
  const LoadContactsEvent();
}

class FilterByCategoryEvent extends ContactsEvent {
  final String categoryId;

  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class SearchContactsEvent extends ContactsEvent {
  final String query;

  const SearchContactsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class TabChangedEvent extends ContactsEvent {
  final ContactsTab tab;

  const TabChangedEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ContactOpenedEvent extends ContactsEvent {
  final String contactId;

  const ContactOpenedEvent(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

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

class ResetFiltersEvent extends ContactsEvent {
  const ResetFiltersEvent();
}

enum ContactsTab {
  contacts,
  recent,
}
