import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';
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

    blocTest<ItemsBloc, ItemsEvent, ItemsState>(
      'should add a item to the catalog list in response to an AddItem Event',
      build: () => itemsBloc,
      act: (ItemsBloc bloc) async =>
          bloc..add(LoadItems())..add(AddItem(Item('Crackers', id: '0'))),
      expect: <ItemsState>[
        ItemsLoading(),
        ItemsLoaded([]),
        ItemsLoaded([Item('Crackers', id: '0')]),
      ],
    );

    blocTest<ItemsBloc, ItemsEvent, ItemsState>(
      'should update a item in response to an UpdateItem Event',
      build: () => itemsBloc,
      act: (ItemsBloc bloc) async {
        final item = Item('Crackers', id: '0');
        bloc
          ..add(LoadItems())
          ..add(AddItem(item))
          ..add(UpdateItem(item.copyWith(name: 'Pretzels')));
      },
      expect: <ItemsState>[
        ItemsLoading(),
        ItemsLoaded([]),
        ItemsLoaded([Item('Crackers', id: '0')]),
        ItemsLoaded([Item('Pretzels', id: '0')]),
      ],
    );

    blocTest<ItemsBloc, ItemsEvent, ItemsState>(
      'should remove item from the list in response to a DeleteItem Event',
      build: () {
        when(itemsRepository.loadItems()).thenAnswer((_) => Future.value([]));
        return itemsBloc;
      },
      act: (ItemsBloc bloc) async {
        final item = Item('Crackers', id: '0');
        bloc..add(LoadItems())..add(AddItem(item))..add(DeleteItem(item));
      },
      expect: <ItemsState>[
        ItemsLoading(),
        ItemsLoaded([]),
        ItemsLoaded([Item('Crackers', id: '0')]),
        ItemsLoaded([]),
      ],
    );
  });
}
