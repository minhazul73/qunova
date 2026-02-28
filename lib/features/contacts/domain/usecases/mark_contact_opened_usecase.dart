import '../repositories/contact_repository.dart';

class MarkContactOpenedUseCase {
  final ContactRepository _repository;

  MarkContactOpenedUseCase({required ContactRepository repository})
      : _repository = repository;

  Future<bool> call(String contactId) async {
    return _repository.markContactOpened(contactId);
  }
}
