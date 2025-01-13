import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskify/presentation/providers/list_provider.dart';

import '../../domain/entities/list_entity.dart';
import '../../domain/usecases/create_list_usecase.dart';
import '../../domain/usecases/fetch_lists_usecase.dart';

class ListNotifier extends StateNotifier<AsyncValue<List<ListEntity>>> {
  final FetchListsUseCase _fetchListsUseCase;
  final CreateListUseCase _createListUseCase;

  ListNotifier(this._fetchListsUseCase, this._createListUseCase)
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
}

final listProvider =
    StateNotifierProvider<ListNotifier, AsyncValue<List<ListEntity>>>((ref) {
  final fetchListsUseCase = ref.watch(fetchListsUseCaseProvider);
  final createListUseCase = ref.watch(createListUseCaseProvider);
  return ListNotifier(fetchListsUseCase, createListUseCase);
});
