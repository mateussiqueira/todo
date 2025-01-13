import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/data/datasources/supabase_datasource.dart';

class ItemNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final SupabaseDatasource _datasource;
  final String listId;

  ItemNotifier(this._datasource, this.listId)
      : super(const AsyncValue.loading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      state = const AsyncValue.loading();
      final items = await _datasource.getItems(listId);
      state = AsyncValue.data(items);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addItem(String title, String description) async {
    try {
      state = const AsyncValue.loading();
      await _datasource.addItem(listId, title, description);
      await fetchItems(); // Atualiza a lista após adicionar um novo item
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final itemProvider = StateNotifierProvider.family<ItemNotifier,
    AsyncValue<List<Map<String, dynamic>>>, String>((ref, listId) {
  final datasource = SupabaseDatasource();
  return ItemNotifier(datasource, listId);
});
