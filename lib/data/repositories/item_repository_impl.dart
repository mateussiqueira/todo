import '../../domain/entities/item_entity.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/supabase_datasource.dart';

class ItemRepositoryImpl implements ItemRepository {
  final SupabaseDatasource datasource;

  ItemRepositoryImpl(this.datasource);

  @override
  Future<List<ItemEntity>> fetchItems(String listId) async {
    final data = await datasource.getItems(listId);
    return data
        .map((e) => ItemEntity(
              id: e['id'],
              listId: listId,
              title: e['title'],
              description: e['description'],
              completed: e['completed'],
              createdAt: DateTime.parse(e['created_at']),
              updatedAt: DateTime.parse(e['updated_at']),
            ))
        .toList();
  }

  @override
  Future<void> createItem(
      String listId, String title, String description) async {
    await datasource.addItem(listId, title, description);
  }

  @override
  Future<void> updateItem(
      String itemId, String title, String description, bool completed) async {
    await datasource.updateItem(itemId, title, description, completed);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    await datasource.deleteItem(itemId);
  }
}
