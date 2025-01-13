import '../../domain/entities/list_entity.dart';
import '../../domain/repositories/list_repository.dart';
import '../datasources/supabase_datasource.dart';

class ListRepositoryImpl implements ListRepository {
  final SupabaseDatasource datasource;

  ListRepositoryImpl(this.datasource);

  @override
  Future<List<ListEntity>> fetchLists() async {
    final data = await datasource.getLists();
    return data
        .map((e) => ListEntity(
              id: e['id'],
              name: e['name'],
              createdAt: DateTime.parse(e['created_at']),
              updatedAt: DateTime.parse(e['updated_at']),
            ))
        .toList();
  }

  @override
  Future<void> createList(String name) async {
    await datasource.addList(name);
  }

  @override
  Future<void> updateList(String id, String name) async {
    await datasource.updateList(id, name);
  }

  @override
  Future<void> deleteList(String id) async {
    await datasource.deleteList(id);
  }
}
