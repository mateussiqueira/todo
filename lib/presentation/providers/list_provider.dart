import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_datasource.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../data/repositories/list_repository_impl.dart';
import '../../domain/entities/list_entity.dart';
import '../../domain/usecases/create_item_usecase.dart';
import '../../domain/usecases/create_list_usecase.dart';
import '../../domain/usecases/delete_list_usecase.dart';
import '../../domain/usecases/fetch_lists_usecase.dart';
import '../../domain/usecases/update_list_usecase.dart';
import 'create_item_notifier.dart';
import 'create_list_notifier.dart';
import 'fetch_lists_notifier.dart';

// Defina o provider para o SupabaseDatasource
final supabaseDatasourceProvider = Provider<SupabaseDatasource>((ref) {
  return SupabaseDatasource();
});

// Defina o provider para o ListRepository
final listRepositoryProvider = Provider<ListRepositoryImpl>((ref) {
  final datasource = ref.watch(supabaseDatasourceProvider);
  return ListRepositoryImpl(datasource);
});

// Defina o provider para FetchListsUseCase
final fetchListsUseCaseProvider = Provider<FetchListsUseCase>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return FetchListsUseCase(repository);
});

// Defina o provider para CreateListUseCase
final createListUseCaseProvider = Provider<CreateListUseCase>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return CreateListUseCase(repository);
});

// Defina o provider para UpdateListUseCase
final updateListUseCaseProvider = Provider<UpdateListUseCase>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return UpdateListUseCase(repository);
});

// Defina o provider para DeleteListUseCase
final deleteListUseCaseProvider = Provider<DeleteListUseCase>((ref) {
  final repository = ref.watch(listRepositoryProvider);
  return DeleteListUseCase(repository);
});

// Defina o StateNotifierProvider para ListNotifier
final listProvider =
    StateNotifierProvider<ListNotifier, AsyncValue<List<ListEntity>>>((ref) {
  final fetchListsUseCase = ref.watch(fetchListsUseCaseProvider);
  final createListUseCase = ref.watch(createListUseCaseProvider);
  final updateListUseCase = ref.watch(updateListUseCaseProvider);
  final deleteListUseCase = ref.watch(deleteListUseCaseProvider);
  return ListNotifier(fetchListsUseCase, createListUseCase, updateListUseCase,
      deleteListUseCase);
});

class ListNotifier extends StateNotifier<AsyncValue<List<ListEntity>>> {
  final FetchListsUseCase _fetchListsUseCase;
  final CreateListUseCase _createListUseCase;
  final UpdateListUseCase _updateListUseCase;
  final DeleteListUseCase _deleteListUseCase;

  ListNotifier(this._fetchListsUseCase, this._createListUseCase,
      this._updateListUseCase, this._deleteListUseCase)
      : super(const AsyncValue.loading()) {
    fetchLists();
  }

  Future<void> fetchLists() async {
    try {
      state = const AsyncValue.loading();
      final lists = await _fetchListsUseCase();
      state = AsyncValue.data(lists);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> addList(String name) async {
    try {
      state = const AsyncValue.loading();
      await _createListUseCase(name);
      await fetchLists(); // Atualiza a lista após adicionar uma nova
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateList(String id, String name) async {
    try {
      state = const AsyncValue.loading();
      await _updateListUseCase(id, name);
      await fetchLists(); // Atualiza a lista após editar uma lista
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteList(String id) async {
    try {
      state = const AsyncValue.loading();
      await _deleteListUseCase(id);
      await fetchLists(); // Atualiza a lista após remover uma lista
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final fetchListsProvider = StateNotifierProvider<FetchListsNotifier,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final supabaseDatasource = ref.watch(supabaseDatasourceProvider);
  return FetchListsNotifier(supabaseDatasource);
});

final createListProvider =
    StateNotifierProvider<CreateListNotifier, void>((ref) {
  final createListUseCase = ref.watch(createListUseCaseProvider);
  return CreateListNotifier(createListUseCase, ref);
});

final createItemProvider =
    StateNotifierProvider.family<CreateItemNotifier, AsyncValue<void>, String>(
        (ref, listId) {
  final usecase = ref.watch(createItemUseCaseProvider);
  return CreateItemNotifier(usecase, listId);
});

// Defina o provider para o ItemRepository
final itemRepositoryProvider = Provider<ItemRepositoryImpl>((ref) {
  final datasource = ref.watch(supabaseDatasourceProvider);
  return ItemRepositoryImpl(datasource);
});

// Refatore o provider para CreateItemUseCase
final createItemUseCaseProvider = Provider<CreateItemUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return CreateItemUseCase(repository);
});
