import '../entities/list_entity.dart';
import '../repositories/list_repository.dart';

class FetchListsUseCase {
  final ListRepository repository;

  FetchListsUseCase(this.repository);

  Future<List<ListEntity>> call() async {
    return await repository.fetchLists();
  }
}
