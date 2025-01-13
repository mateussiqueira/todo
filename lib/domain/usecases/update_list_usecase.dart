import '../repositories/list_repository.dart';

class UpdateListUseCase {
  final ListRepository repository;

  UpdateListUseCase(this.repository);

  Future<void> call(String id, String name) async {
    await repository.updateList(id, name);
  }
}
