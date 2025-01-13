import '../repositories/item_repository.dart';

class UpdateItemUseCase {
  final ItemRepository repository;

  UpdateItemUseCase(this.repository);

  Future<void> call(
      String itemId, String title, String description, bool completed) async {
    await repository.updateItem(itemId, title, description, completed);
  }
}
