import '../entities/category_entity.dart';
import '../entities/contact_entity.dart';

abstract class ContactRepository {
  Future<({List<CategoryEntity> categories, List<ContactEntity> contacts})>
  getContacts();

  /// Gets a list of recently opened contact IDs (ordered by most recent first)
  Future<List<String>> getRecentContactIds();

  /// Gets contacts that were recently opened (ordered by most recent first)
  ///
  /// First fetches recent IDs, then resolves them into full contact entities
  /// from the available contacts.
  Future<List<ContactEntity>> getRecentContacts();

  /// Marks a contact as opened (records it in recent history)
  ///
  /// Returns true if successful, false otherwise
  Future<bool> markContactOpened(String contactId);

  /// Saves a new contact or updates an existing one locally
  ///
  /// Since the API is GET-only, all new/updated contacts are stored locally
  /// and merged with remote contacts when fetching.
  ///
  /// Returns true if successful, false otherwise
  Future<bool> saveContact(ContactEntity contact);

  /// Deletes a locally stored contact
  ///
  /// Note: This only affects locally stored contacts. Remote contacts cannot
  /// be deleted through this interface.
  ///
  /// Returns true if successful, false otherwise
  Future<bool> deleteLocalContact(String contactId);

  /// Clears the recent contacts history
  Future<bool> clearRecentHistory();

  /// Clears all locally stored contacts
  Future<bool> clearLocalContacts();
}
