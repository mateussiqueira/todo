import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_list_usecase.dart';
import 'list_provider.dart';

class CreateListNotifier extends StateNotifier<void> {
  final CreateListUseCase _createListUseCase;
  final StateNotifierProviderRef<CreateListNotifier, void> _ref;

  CreateListNotifier(this._createListUseCase, this._ref) : super(null);

  Future<void> createList(String name) async {
    await _createListUseCase(name);
    // Atualizar o estado do fetchListsProvider diretamente
    _ref.read(fetchListsProvider.notifier).fetchLists();
  }
}
