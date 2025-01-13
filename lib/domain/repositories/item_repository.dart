import '../entities/item_entity.dart';

abstract class ItemRepository {
  Future<List<ItemEntity>> fetchItems(String listId);
  Future<void> createItem(String listId, String title, String description);
  Future<void> updateItem(
      String itemId, String title, String description, bool completed);
  Future<void> deleteItem(String itemId);
}
