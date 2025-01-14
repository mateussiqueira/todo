import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskify/data/datasources/supabase_datasource.dart';
import 'package:taskify/data/repositories/list_repository_impl.dart';
import 'package:taskify/domain/entities/list_entity.dart';

import 'list_repository_impl_test.mocks.dart';

@GenerateMocks([SupabaseDatasource])
void main() {
  late ListRepositoryImpl repository;
  late MockSupabaseDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockSupabaseDatasource();
    repository = ListRepositoryImpl(mockDatasource);
  });

  final listEntity = ListEntity(
    id: '1',
    name: 'Test List',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  test('should fetch lists from datasource', () async {
    when(mockDatasource.getLists()).thenAnswer((_) async => [
          {
            'id': '1',
            'name': 'Test List',
            'created_at': listEntity.createdAt.toIso8601String(),
            'updated_at': listEntity.updatedAt.toIso8601String(),
          }
        ]);

    final result = await repository.fetchLists();

    expect(result, [listEntity]);
    verify(mockDatasource.getLists());
    verifyNoMoreInteractions(mockDatasource);
  });

  test('should create list in datasource', () async {
    when(mockDatasource.addList(any)).thenAnswer((_) async => {});

    await repository.createList('Test List');

    verify(mockDatasource.addList('Test List'));
    verifyNoMoreInteractions(mockDatasource);
  });

  test('should update list in datasource', () async {
    when(mockDatasource.updateList(any, any)).thenAnswer((_) async => {});

    await repository.updateList('1', 'Updated List');

    verify(mockDatasource.updateList('1', 'Updated List'));
    verifyNoMoreInteractions(mockDatasource);
  });

  test('should delete list in datasource', () async {
    when(mockDatasource.deleteList(any)).thenAnswer((_) async => {});

    await repository.deleteList('1');

    verify(mockDatasource.deleteList('1'));
    verifyNoMoreInteractions(mockDatasource);
  });
}
