import '../repositories/item_repository.dart';

class DeleteItemUseCase {
  final ItemRepository repository;

  DeleteItemUseCase(this.repository);

  Future<void> call(String itemId) async {
    await repository.deleteItem(itemId);
  }
}
