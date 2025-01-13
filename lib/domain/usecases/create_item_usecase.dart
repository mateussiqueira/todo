import '../repositories/item_repository.dart';

class CreateItemUseCase {
  final ItemRepository repository;

  CreateItemUseCase(this.repository);

  Future<void> call(String listId, String title, String description) async {
    await repository.createItem(listId, title, description);
  }
}
