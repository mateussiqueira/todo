import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskify/domain/entities/list_entity.dart';
import 'package:taskify/domain/usecases/create_list_usecase.dart';
import 'package:taskify/domain/usecases/delete_list_usecase.dart';
import 'package:taskify/domain/usecases/fetch_lists_usecase.dart';
import 'package:taskify/domain/usecases/update_list_usecase.dart';
import 'package:taskify/presentation/providers/list_provider.dart';

import 'list_notifier_test.mocks.dart';

@GenerateMocks([
  FetchListsUseCase,
  CreateListUseCase,
  UpdateListUseCase,
  DeleteListUseCase
])
void main() {
  late ListNotifier notifier;
  late MockFetchListsUseCase mockFetchListsUseCase;
  late MockCreateListUseCase mockCreateListUseCase;
  late MockUpdateListUseCase mockUpdateListUseCase;
  late MockDeleteListUseCase mockDeleteListUseCase;
  late ProviderContainer container;

  setUp(() {
    mockFetchListsUseCase = MockFetchListsUseCase();
    mockCreateListUseCase = MockCreateListUseCase();
    mockUpdateListUseCase = MockUpdateListUseCase();
    mockDeleteListUseCase = MockDeleteListUseCase();
    notifier = ListNotifier(
      mockFetchListsUseCase,
      mockCreateListUseCase,
      mockUpdateListUseCase,
      mockDeleteListUseCase,
    );
    container = ProviderContainer(
      overrides: [
        listProvider.overrideWithProvider(
            StateNotifierProvider<ListNotifier, AsyncValue<List<ListEntity>>>(
                (ref) => notifier)),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  final testList = ListEntity(
    id: '1',
    name: 'Test List',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('initial state should be loading', () {
    expect(notifier.state, const AsyncValue.loading());
  });

  test('fetchLists should emit data when successful', () async {
    when(mockFetchListsUseCase()).thenAnswer((_) async => [testList]);

    await notifier.fetchLists();

    verify(mockFetchListsUseCase()).called(1);
    expect(notifier.state, AsyncValue.data([testList]));
  });

  test('fetchLists should emit error when failed', () async {
    when(mockFetchListsUseCase()).thenThrow(Exception('Failed to fetch lists'));

    await notifier.fetchLists();

    verify(mockFetchListsUseCase()).called(1);
    expect(notifier.state, isA<AsyncValue<List<ListEntity>>>());
    expect(notifier.state.hasError, true);
  });

  test('addList should call createListUseCase and fetchLists', () async {
    when(mockCreateListUseCase(any)).thenAnswer((_) async => Future.value());
    when(mockFetchListsUseCase()).thenAnswer((_) async => [testList]);

    await notifier.addList('New List');

    verify(mockCreateListUseCase('New List')).called(1);
    verify(mockFetchListsUseCase()).called(
        2); // fetchLists is called twice: once in the constructor and once in addList
    expect(notifier.state, AsyncValue.data([testList]));
  });

  test('updateList should call updateListUseCase and fetchLists', () async {
    when(mockUpdateListUseCase(any, any))
        .thenAnswer((_) async => Future.value());
    when(mockFetchListsUseCase()).thenAnswer((_) async => [testList]);

    await notifier.updateList('1', 'Updated List');

    verify(mockUpdateListUseCase('1', 'Updated List')).called(1);
    verify(mockFetchListsUseCase()).called(
        2); // fetchLists is called twice: once in the constructor and once in updateList
    expect(notifier.state, AsyncValue.data([testList]));
  });

  test('deleteList should call deleteListUseCase and fetchLists', () async {
    when(mockDeleteListUseCase(any)).thenAnswer((_) async => Future.value());
    when(mockFetchListsUseCase()).thenAnswer((_) async => [testList]);

    await notifier.deleteList('1');

    verify(mockDeleteListUseCase('1')).called(1);
    verify(mockFetchListsUseCase()).called(
        2); // fetchLists is called twice: once in the constructor and once in deleteList
    expect(notifier.state, AsyncValue.data([testList]));
  });
}
