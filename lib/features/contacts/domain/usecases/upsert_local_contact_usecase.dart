import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

/// Use case to save a new contact or update an existing one locally
///
/// Since the provided API is read-only (GET), new contacts are stored locally
/// and merged with remote contacts when fetching.
///
/// Example:
/// ```dart
/// final newContact = ContactEntity(
///   id: 'new_id',
///   isEmpty: false,
///   name: 'John Doe',
///   phone: '01234567890',
///   categoryId: 'friends',
/// );
/// final success = await upsertLocalContactUseCase(newContact);
/// ```
class UpsertLocalContactUseCase {
  final ContactRepository _repository;

  UpsertLocalContactUseCase({required ContactRepository repository})
      : _repository = repository;

  /// Executes the use case
  ///
  /// Parameters:
  /// - contact: The contact entity to save or update
  ///
  /// Returns:
  /// - true: If the contact was successfully saved/updated
  /// - false: If the operation failed
  ///
  /// Note:
  /// - If a local contact with the same ID exists, it will be updated
  /// - If it's new, it will be added to local storage
  /// - For new contacts, generate a unique ID (e.g., 'local_' + timestamp)
  Future<bool> call(ContactEntity contact) async {
    return _repository.saveContact(contact);
  }
}
