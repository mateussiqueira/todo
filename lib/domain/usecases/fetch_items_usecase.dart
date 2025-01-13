import '../entities/item_entity.dart';
import '../repositories/item_repository.dart';

class FetchItemsUseCase {
  final ItemRepository repository;

  FetchItemsUseCase(this.repository);

  Future<List<ItemEntity>> call(String listId) async {
    return await repository.fetchItems(listId);
  }
}
