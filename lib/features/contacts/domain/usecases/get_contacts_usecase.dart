import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

/// Use case to fetch all contacts
///
/// Fetches contacts from remote API and merges with locally stored contacts.
/// Categories are also returned for filtering UI.
///
/// Example:
/// ```dart
/// final result = await getContactsUseCase();
/// final (categories, contacts) = result;
/// ```
class GetContactsUseCase {
  final ContactRepository _repository;

  GetContactsUseCase({required ContactRepository repository})
      : _repository = repository;

  /// Executes the use case
  ///
  /// Returns a record containing:
  /// - categories: List of available contact categories
  /// - contacts: List of contacts (merged from remote + local sources)
  ///
  /// Exceptions:
  /// - Network/TimeoutException: If API call fails
  /// - ParseException: If JSON parsing fails
  Future<({List<String> categories, List<ContactEntity> contacts})>
  call() async {
    final result = await _repository.getContacts();
    
    // Map category entities to category IDs for UI convenience
    final categoryIds =
        result.categories.map((c) => c.id).toList();
    
    return (categories: categoryIds, contacts: result.contacts);
  }
}
