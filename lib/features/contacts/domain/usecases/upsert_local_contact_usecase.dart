import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

class UpsertLocalContactUseCase {
  final ContactRepository _repository;

  UpsertLocalContactUseCase({required ContactRepository repository})
      : _repository = repository;

  Future<bool> call(ContactEntity contact) async {
    return _repository.saveContact(contact);
  }
}
