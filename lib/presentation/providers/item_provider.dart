import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_datasource.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/entities/item_entity.dart';
import '../../domain/usecases/create_item_usecase.dart';
import '../../domain/usecases/delete_item_usecase.dart';
import '../../domain/usecases/fetch_items_usecase.dart';
import '../../domain/usecases/update_item_usecase.dart';

// Defina o provider para o SupabaseDatasource
final supabaseDatasourceProvider = Provider<SupabaseDatasource>((ref) {
  return SupabaseDatasource();
});

// Defina o provider para o ItemRepository
final itemRepositoryProvider = Provider<ItemRepositoryImpl>((ref) {
  final datasource = ref.watch(supabaseDatasourceProvider);
  return ItemRepositoryImpl(datasource);
});

// Defina o provider para FetchItemsUseCase
final fetchItemsUseCaseProvider = Provider<FetchItemsUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return FetchItemsUseCase(repository);
});

// Defina o provider para CreateItemUseCase
final createItemUseCaseProvider = Provider<CreateItemUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return CreateItemUseCase(repository);
});

// Defina o provider para UpdateItemUseCase
final updateItemUseCaseProvider = Provider<UpdateItemUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return UpdateItemUseCase(repository);
});

// Defina o provider para DeleteItemUseCase
final deleteItemUseCaseProvider = Provider<DeleteItemUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return DeleteItemUseCase(repository);
});

// Defina o StateNotifierProvider para ItemNotifier
final itemProvider = StateNotifierProvider.family<ItemNotifier,
    AsyncValue<List<ItemEntity>>, String>((ref, listId) {
  final fetchItemsUseCase = ref.watch(fetchItemsUseCaseProvider);
  final createItemUseCase = ref.watch(createItemUseCaseProvider);
  final updateItemUseCase = ref.watch(updateItemUseCaseProvider);
  final deleteItemUseCase = ref.watch(deleteItemUseCaseProvider);
  return ItemNotifier(fetchItemsUseCase, createItemUseCase, updateItemUseCase,
      deleteItemUseCase, listId);
});

class ItemNotifier extends StateNotifier<AsyncValue<List<ItemEntity>>> {
  final FetchItemsUseCase _fetchItemsUseCase;
  final CreateItemUseCase _createItemUseCase;
  final UpdateItemUseCase _updateItemUseCase;
  final DeleteItemUseCase _deleteItemUseCase;
  final String listId;

  ItemNotifier(this._fetchItemsUseCase, this._createItemUseCase,
      this._updateItemUseCase, this._deleteItemUseCase, this.listId)
      : super(const AsyncValue.loading()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      state = const AsyncValue.loading();
      final items = await _fetchItemsUseCase(listId);
      state = AsyncValue.data(items);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addItem(String title, String description) async {
    try {
      state = const AsyncValue.loading();
      await _createItemUseCase(listId, title, description);
      await fetchItems(); // Atualiza a lista após adicionar um novo item
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateItem(
      String itemId, String title, String description, bool completed) async {
    try {
      state = const AsyncValue.loading();
      await _updateItemUseCase(itemId, title, description, completed);
      await fetchItems(); // Atualiza a lista após editar um item
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteItem(String itemId) async {
    try {
      state = const AsyncValue.loading();
      await _deleteItemUseCase(itemId);
      await fetchItems(); // Atualiza a lista após remover um item
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
