import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_datasource.dart';
import '../../data/repositories/item_repository_impl.dart';
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

// Defina o provider para UpdateItemUseCase
final updateItemUseCaseProvider = Provider<UpdateItemUseCase>((ref) {
  final repository = ref.watch(itemRepositoryProvider);
  return UpdateItemUseCase(repository);
});

// Defina o StateNotifierProvider para UpdateItemNotifier
final updateItemNotifierProvider =
    StateNotifierProvider<UpdateItemNotifier, AsyncValue<void>>((ref) {
  final updateItemUseCase = ref.watch(updateItemUseCaseProvider);
  return UpdateItemNotifier(updateItemUseCase);
});

class UpdateItemNotifier extends StateNotifier<AsyncValue<void>> {
  final UpdateItemUseCase _updateItemUseCase;

  UpdateItemNotifier(this._updateItemUseCase)
      : super(const AsyncValue.data(null));

  Future<void> updateItem(
      String itemId, String title, String description, bool completed) async {
    try {
      state = const AsyncValue.loading();
      await _updateItemUseCase(itemId, title, description, completed);
      state = const AsyncValue.data(
          null); // Indica que a operação foi concluída com sucesso
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
