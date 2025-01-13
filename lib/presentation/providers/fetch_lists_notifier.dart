import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/supabase_datasource.dart';

class FetchListsNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final SupabaseDatasource _datasource;

  FetchListsNotifier(this._datasource) : super(const AsyncValue.loading());

  Future<void> fetchLists() async {
    try {
      final lists = await _datasource.getLists();
      state = AsyncValue.data(lists);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
