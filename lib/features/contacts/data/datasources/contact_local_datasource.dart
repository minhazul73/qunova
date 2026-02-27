import 'dart:convert';

import '../../../../core/logging/app_log.dart';
import '../../../../core/persistence/kv_store.dart';
import '../models/contact_model.dart';

/// Local data source for managing recent contacts and locally added contacts
class ContactLocalDataSource {
  final KvStore _kvStore;

  // Storage keys
  static const String _recentContactIdsKey = 'recent_contact_ids';
  static const String _localContactsKey = 'local_contacts';
  static const int _maxRecentContacts = 20;

  ContactLocalDataSource({required KvStore kvStore}) : _kvStore = kvStore;

  // ========== Recent Contacts ==========

  /// Gets the list of recent contact IDs (ordered by most recent first)
  Future<List<String>> getRecentContactIds() async {
    try {
      final ids = await _kvStore.getStringList(_recentContactIdsKey);
      AppLog.d(
        'ContactLocalDataSource: Retrieved ${ids?.length ?? 0} '
        'recent contact IDs',
      );
      return ids ?? [];
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error retrieving recent IDs: $e');
      return [];
    }
  }

  /// Marks a contact as opened (adds to recent list)
  ///
  /// If the contact was already in the list, it's moved to the front.
  /// List is capped at [_maxRecentContacts] items.
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
        'ContactLocalDataSource: Marked contact $contactId as opened '
        '(${cappedIds.length} recent contacts)',
      );
      return success;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error marking contact opened: $e');
      return false;
    }
  }

  /// Clears all recent contacts
  Future<bool> clearRecentContacts() async {
    try {
      final success = await _kvStore.remove(_recentContactIdsKey);
      AppLog.d('ContactLocalDataSource: Cleared recent contacts');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error clearing recent contacts: $e');
      return false;
    }
  }

  // ========== Local Contacts ==========

  /// Gets all locally stored contacts
  Future<List<ContactModel>> getLocalContacts() async {
    try {
      final jsonString = await _kvStore.getString(_localContactsKey);
      if (jsonString == null || jsonString.isEmpty) {
        AppLog.d('ContactLocalDataSource: No local contacts found');
        return [];
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final contacts = ContactModel.fromJsonList(jsonList);
      AppLog.d(
        'ContactLocalDataSource: Retrieved ${contacts.length} '
        'local contacts',
      );
      return contacts;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error retrieving local contacts: $e');
      return [];
    }
  }

  /// Saves a new local contact or updates existing one
  ///
  /// If a contact with the same ID exists, it's updated.
  /// Otherwise, the contact is added to the list.
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
        AppLog.d('ContactLocalDataSource: Updated local contact ${contact.id}');
      } else {
        // Add new
        currentContacts.add(contact);
        AppLog.d(
          'ContactLocalDataSource: Added new local contact ${contact.id}',
        );
      }

      // Convert to JSON and save
      final jsonList = currentContacts.map((c) => c.toJson).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await _kvStore.setString(_localContactsKey, jsonString);

      return success;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error saving local contact: $e');
      return false;
    }
  }

  /// Deletes a local contact by ID
  Future<bool> deleteLocalContact(String contactId) async {
    try {
      final currentContacts = await getLocalContacts();
      final updatedContacts = currentContacts
          .where((c) => c.id != contactId)
          .toList();

      if (currentContacts.length == updatedContacts.length) {
        // Contact not found
        AppLog.d(
          'ContactLocalDataSource: Contact $contactId not found for deletion',
        );
        return false;
      }

      // Convert to JSON and save
      final jsonList = updatedContacts.map((c) => c.toJson).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await _kvStore.setString(_localContactsKey, jsonString);

      AppLog.d('ContactLocalDataSource: Deleted local contact $contactId');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error deleting local contact: $e');
      return false;
    }
  }

  /// Clears all locally stored contacts
  Future<bool> clearLocalContacts() async {
    try {
      final success = await _kvStore.remove(_localContactsKey);
      AppLog.d('ContactLocalDataSource: Cleared all local contacts');
      return success;
    } catch (e) {
      AppLog.e('ContactLocalDataSource: Error clearing local contacts: $e');
      return false;
    }
  }
}
