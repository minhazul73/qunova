import '../repositories/contact_repository.dart';

/// Use case to record when a contact is opened
///
/// Marks a contact as recently opened, adding/updating it in the recent history.
/// This enables the "Recent" tab to show the user's recently viewed contacts.
///
/// Example:
/// ```dart
/// final success = await markContactOpenedUseCase('contact_id_123');
/// ```
class MarkContactOpenedUseCase {
  final ContactRepository _repository;

  MarkContactOpenedUseCase({required ContactRepository repository})
      : _repository = repository;

  /// Executes the use case
  ///
  /// Parameters:
  /// - contactId: The ID of the contact that was opened
  ///
  /// Returns:
  /// - true: If the contact was successfully marked as opened
  /// - false: If the operation failed
  Future<bool> call(String contactId) async {
    return await _repository.markContactOpened(contactId);
  }
}
