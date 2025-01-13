import '../repositories/list_repository.dart';

class DeleteListUseCase {
  final ListRepository repository;

  DeleteListUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteList(id);
  }
}
