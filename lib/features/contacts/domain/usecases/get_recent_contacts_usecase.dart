import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class GetRecentContactsUseCase {
  final ContactRepository _repository;

  GetRecentContactsUseCase({required ContactRepository repository})
      : _repository = repository;

  Future<List<ContactEntity>> call() async {
    return _repository.getRecentContacts();
  }
}
