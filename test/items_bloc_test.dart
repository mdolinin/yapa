import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/repository/items_repository.dart';

class MockItemsRepository extends Mock implements ItemsRepository {}

void main() {
  group('ItemsBloc', () {
    ItemsRepository itemsRepository;
    ItemsBloc itemsBloc;

    setUp(() {
      itemsRepository = MockItemsRepository();
      when(itemsRepository.loadItems()).thenAnswer((_) => Future.value([]));
      itemsBloc = ItemsBloc(itemsRepository: itemsRepository);
    });

    blocTest<ItemsBloc, ItemsEvent, ItemsState>(
      'should emit ItemsNotLoaded if repository throws',
      build: () {
        when(itemsRepository.loadItems()).thenThrow(Exception('oops'));
        return itemsBloc;
      },
      act: (ItemsBloc bloc) async => bloc.add(LoadItems()),
      expect: <ItemsState>[
        ItemsLoading(),
        ItemsNotLoaded(),
      ],
    );
  });
}
