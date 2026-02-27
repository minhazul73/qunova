import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

/// Use case to fetch recently opened contacts
///
/// Retrieves contacts that were recently opened by the user,
/// ordered by most recent first.
///
/// Example:
/// ```dart
/// final recentContacts = await getRecentContactsUseCase();
/// ```
class GetRecentContactsUseCase {
  final ContactRepository _repository;

  GetRecentContactsUseCase({required ContactRepository repository})
      : _repository = repository;

  /// Executes the use case
  ///
  /// Returns list of contacts ordered by most recent first.
  /// If no recent contacts exist, returns an empty list.
  ///
  /// Exceptions:
  /// - Network/TimeoutException: If API call fails (to reload full contact list)
  /// - ParseException: If JSON parsing fails
  Future<List<ContactEntity>> call() async {
    return await _repository.getRecentContacts();
  }
}
