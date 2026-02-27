import 'dart:convert';

import '../../../../core/logging/app_log.dart';
import '../../../../core/persistence/kv_store.dart';
import '../models/contact_model.dart';

/// Abstract contract for local contact data operations
abstract class ContactLocalService {
  /// Gets the list of recent contact IDs (ordered by most recent first)
  Future<List<String>> getRecentContactIds();

  /// Marks a contact as opened (adds to recent list)
  ///
  /// If the contact was already in the list, it's moved to the front.
  /// List is capped at max recent contacts.
  Future<bool> markContactOpened(String contactId);

  /// Clears all recent contacts
  Future<bool> clearRecentContacts();

  /// Gets all locally stored contacts
  Future<List<ContactModel>> getLocalContacts();

  /// Saves a new local contact or updates existing one
  ///
  /// If a contact with the same ID exists, it's updated.
  /// Otherwise, the contact is added to the list.
  Future<bool> saveLocalContact(ContactModel contact);

  /// Deletes a local contact by ID
  Future<bool> deleteLocalContact(String contactId);

  /// Clears all locally stored contacts
  Future<bool> clearLocalContacts();
}

/// Local data source for managing recent contacts and locally added contacts
class ContactLocalServiceImpl implements ContactLocalService {
  final KvStore _kvStore;

  // Storage keys
  static const String _recentContactIdsKey = 'recent_contact_ids';
  static const String _localContactsKey = 'local_contacts';
  static const int _maxRecentContacts = 20;

  ContactLocalServiceImpl({required KvStore kvStore}) : _kvStore = kvStore;

  // ========== Recent Contacts ==========

  @override
  Future<List<String>> getRecentContactIds() async {
    try {
      final ids = await _kvStore.getStringList(_recentContactIdsKey);
      AppLog.d(
        'ContactLocalService: Retrieved ${ids?.length ?? 0} '
        'recent contact IDs',
      );
      return ids ?? [];
    } catch (e) {
      AppLog.e('ContactLocalService: Error retrieving recent IDs: $e');
      return [];
    }
  }

  @override
  Future<bool> markContactOpened(String contactId) async {
    try {
      final currentIds = await getRecentContactIds();

      // Remove if already exists (to move to front)
      final updatedIds = currentIds.where((id) => id != contactId).toList();

      // Add to front
      updatedIds.insert(0, contactId);

      // Cap the list
      final cappedIds = updatedIds.take(_maxRecentContacts).toList();

      final success = await _kvStore.setStringList(
        _recentContactIdsKey,
        cappedIds,
      );
      AppLog.d(
        'ContactLocalService: Marked contact $contactId as opened '
        '(${cappedIds.length} recent contacts)',
      );
      return success;
    } catch (e) {
      AppLog.e('ContactLocalService: Error marking contact opened: $e');
      return false;
    }
  }

  @override
  Future<bool> clearRecentContacts() async {
    try {
      final success = await _kvStore.remove(_recentContactIdsKey);
      AppLog.d('ContactLocalService: Cleared recent contacts');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalService: Error clearing recent contacts: $e');
      return false;
    }
  }

  // ========== Local Contacts ==========

  @override
  Future<List<ContactModel>> getLocalContacts() async {
    try {
      final jsonString = await _kvStore.getString(_localContactsKey);
      if (jsonString == null || jsonString.isEmpty) {
        AppLog.d('ContactLocalService: No local contacts found');
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final contacts = ContactModel.fromJsonList(jsonList);
      AppLog.d(
        'ContactLocalService: Retrieved ${contacts.length} '
        'local contacts',
      );
      return contacts;
    } catch (e) {
      AppLog.e('ContactLocalService: Error retrieving local contacts: $e');
      return [];
    }
  }

  @override
  Future<bool> saveLocalContact(ContactModel contact) async {
    try {
      final currentContacts = await getLocalContacts();

      // Check if contact exists
      final existingIndex = currentContacts.indexWhere(
        (c) => c.id == contact.id,
      );

      if (existingIndex != -1) {
        // Update existing
        currentContacts[existingIndex] = contact;
        AppLog.d('ContactLocalService: Updated local contact ${contact.id}');
      } else {
        // Add new
        currentContacts.add(contact);
        AppLog.d(
          'ContactLocalService: Added new local contact ${contact.id}',
        );
      }

      // Convert to JSON and save
      final jsonList = currentContacts.map((c) => c.toJson).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await _kvStore.setString(_localContactsKey, jsonString);

      return success;
    } catch (e) {
      AppLog.e('ContactLocalService: Error saving local contact: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteLocalContact(String contactId) async {
    try {
      final currentContacts = await getLocalContacts();
      final updatedContacts = currentContacts
          .where((c) => c.id != contactId)
          .toList();

      if (currentContacts.length == updatedContacts.length) {
        // Contact not found
        AppLog.d(
          'ContactLocalService: Contact $contactId not found for deletion',
        );
        return false;
      }

      // Convert to JSON and save
      final jsonList = updatedContacts.map((c) => c.toJson).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await _kvStore.setString(_localContactsKey, jsonString);

      AppLog.d('ContactLocalService: Deleted local contact $contactId');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalService: Error deleting local contact: $e');
      return false;
    }
  }

  @override
  Future<bool> clearLocalContacts() async {
    try {
      final success = await _kvStore.remove(_localContactsKey);
      AppLog.d('ContactLocalService: Cleared all local contacts');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalService: Error clearing local contacts: $e');
      return false;
    }
  }
}
