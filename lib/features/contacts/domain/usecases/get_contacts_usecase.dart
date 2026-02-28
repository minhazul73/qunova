import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class GetContactsUseCase {
  final ContactRepository _repository;

  GetContactsUseCase({required ContactRepository repository})
      : _repository = repository;

  Future<({List<String> categories, List<ContactEntity> contacts})>
  call() async {
    final result = await _repository.getContacts();
    
    // Map category entities to category IDs for UI convenience
    final categoryIds =
        result.categories.map((c) => c.id).toList();
    
    return (categories: categoryIds, contacts: result.contacts);
  }
}
