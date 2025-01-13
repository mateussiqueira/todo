import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_item_usecase.dart';
import 'item_provider.dart';

class CreateItemNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateItemUseCase _createItemUseCase;
  final String _listId;

  CreateItemNotifier(this._createItemUseCase, this._listId)
      : super(const AsyncValue.data(null));

  Future<void> createItem(String title, String description) async {
    try {
      state = const AsyncValue.loading();
      await _createItemUseCase(_listId, title, description);
      state = const AsyncValue.data(
          null); // Indica que a operação foi concluída com sucesso
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Defina o provider para CreateItemNotifier
final createItemNotifierProvider =
    StateNotifierProvider.family<CreateItemNotifier, AsyncValue<void>, String>(
        (ref, listId) {
  final createItemUseCase = ref.watch(createItemUseCaseProvider);
  return CreateItemNotifier(createItemUseCase, listId);
});
