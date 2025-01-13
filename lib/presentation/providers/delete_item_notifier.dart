import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/delete_item_usecase.dart';
import 'item_provider.dart';

class DeleteItemNotifier extends StateNotifier<AsyncValue<void>> {
  final DeleteItemUseCase _deleteItemUseCase;
  final String _listId;

  DeleteItemNotifier(this._deleteItemUseCase, this._listId)
      : super(const AsyncValue.data(null));

  Future<void> deleteItem(String itemId) async {
    try {
      state = const AsyncValue.loading();
      await _deleteItemUseCase(itemId);
      state = const AsyncValue.data(
          null); // Indica que a operação foi concluída com sucesso
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Defina o provider para DeleteItemNotifier
final deleteItemNotifierProvider =
    StateNotifierProvider.family<DeleteItemNotifier, AsyncValue<void>, String>(
        (ref, listId) {
  final deleteItemUseCase = ref.watch(deleteItemUseCaseProvider);
  return DeleteItemNotifier(deleteItemUseCase, listId);
});
