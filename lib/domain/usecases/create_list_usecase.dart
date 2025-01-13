import '../repositories/list_repository.dart';

class CreateListUseCase {
  final ListRepository repository;

  CreateListUseCase(this.repository);

  Future<void> call(String name) async {
    await repository.createList(name);
  }
}
