import '../entities/list_entity.dart';

abstract class ListRepository {
  Future<List<ListEntity>> fetchLists();
  Future<void> createList(String name);
  Future<void> updateList(String id, String name);
  Future<void> deleteList(String id);
}
