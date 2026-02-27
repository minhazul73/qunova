import '../../../../core/logging/app_log.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../services/contact_local_service.dart';
import '../services/contact_remote_service.dart';
import '../models/contact_model.dart';

/// Implementation of ContactRepository that combines remote and local data
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteService _remoteService;
  final ContactLocalService _localService;

  ContactRepositoryImpl({
    required ContactRemoteService remoteService,
    required ContactLocalService localService,
  }) : _remoteService = remoteService,
       _localService = localService;

  @override
  Future<({List<CategoryEntity> categories, List<ContactEntity> contacts})>
  getContacts() async {
    try {
      AppLog.d('ContactRepositoryImpl: Fetching contacts');

      // Fetch remote contacts
      final remote = await _remoteService.fetchContacts();

      // Fetch local contacts
      final localContacts = await _localService.getLocalContacts();

      // Merge contacts (local contacts override remote if same ID)
      final Map<String, ContactEntity> contactMap = {};

      // Add remote contacts first
      for (final contact in remote.contacts) {
        contactMap[contact.id] = contact;
      }

      // Override with local contacts
      for (final contact in localContacts) {
        contactMap[contact.id] = contact;
      }

      final mergedContacts = contactMap.values.toList();

      AppLog.d(
        'ContactRepositoryImpl: Merged ${mergedContacts.length} contacts '
        '(${remote.contacts.length} remote + ${localContacts.length} local)',
      );

      return (categories: remote.categories, contacts: mergedContacts);
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error fetching contacts: $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getRecentContactIds() async {
    try {
      return await _localService.getRecentContactIds();
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error getting recent contact IDs: $e');
      return [];
    }
  }

  @override
  Future<List<ContactEntity>> getRecentContacts() async {
    try {
      AppLog.d('ContactRepositoryImpl: Fetching recent contacts');

      // Get recent IDs
      final recentIds = await getRecentContactIds();

      if (recentIds.isEmpty) {
        AppLog.d('ContactRepositoryImpl: No recent contacts');
        return [];
      }

      // Get all contacts to resolve IDs
      final allContactsData = await getContacts();
      final allContactsMap = {
        for (var contact in allContactsData.contacts) contact.id: contact,
      };

      // Resolve IDs to contacts (preserving order)
      final recentContacts = <ContactEntity>[];
      for (final id in recentIds) {
        final contact = allContactsMap[id];
        if (contact != null) {
          recentContacts.add(contact);
        }
      }

      AppLog.d(
        'ContactRepositoryImpl: Resolved ${recentContacts.length} '
        'recent contacts from ${recentIds.length} IDs',
      );

      return recentContacts;
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error getting recent contacts: $e');
      return [];
    }
  }

  @override
  Future<bool> markContactOpened(String contactId) async {
    try {
      return await _localService.markContactOpened(contactId);
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error marking contact opened: $e');
      return false;
    }
  }

  @override
  Future<bool> saveContact(ContactEntity contact) async {
    try {
      AppLog.d('ContactRepositoryImpl: Saving contact ${contact.id}');

      // Convert entity to model for storage
      final model = ContactModel(
        id: contact.id,
        isEmpty: contact.isEmpty,
        name: contact.name,
        phone: contact.phone,
        categoryId: contact.categoryId,
        avatarUrl: contact.avatarUrl,
        subtitle: contact.subtitle,
        status: contact.status,
        createdAt: contact.createdAt,
      );

      return await _localService.saveLocalContact(model);
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error saving contact: $e');
      return false;
    }
  }

  @override
  Future<bool> deleteLocalContact(String contactId) async {
    try {
      return await _localService.deleteLocalContact(contactId);
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error deleting local contact: $e');
      return false;
    }
  }

  @override
  Future<bool> clearRecentHistory() async {
    try {
      return await _localService.clearRecentContacts();
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error clearing recent history: $e');
      return false;
    }
  }

  @override
  Future<bool> clearLocalContacts() async {
    try {
      return await _localService.clearLocalContacts();
    } catch (e) {
      AppLog.e('ContactRepositoryImpl: Error clearing local contacts: $e');
      return false;
    }
  }
}
