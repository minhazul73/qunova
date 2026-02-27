import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';

/// Use case for adding a new contact
class AddContactUseCase {
  final ContactRepository repository;

  AddContactUseCase({required this.repository});

  /// Adds a new contact and returns success status
  Future<bool> call({
    required String name,
    required String phone,
    String? designation,
    String? company,
    String? relation,
  }) async {
    final contact = ContactEntity(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      isEmpty: false,
      name: name,
      phone: phone,
      categoryId: 'work', // Default category for new contacts
      avatarUrl: '', // Default empty avatar
      subtitle: designation != null ? '$company • $designation' : company ?? '',
      status: 'active',
      createdAt: DateTime.now(),
    );

    return await repository.saveContact(contact);
  }
}
