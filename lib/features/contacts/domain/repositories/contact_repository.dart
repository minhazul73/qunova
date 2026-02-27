import '../entities/category_entity.dart';
import '../entities/contact_entity.dart';

/// Repository contract for contact data operations
///
/// Defines the interface for accessing contact data from various sources.
/// Implementation can combine remote and local data sources.
abstract class ContactRepository {
  /// Fetches all contacts from remote API and merges with local contacts
  ///
  /// Returns a tuple containing:
  /// - List of categories
  /// - List of contacts (remote + local, filtered to exclude empty ones)
  ///
  /// May throw exceptions on network or parsing errors
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
