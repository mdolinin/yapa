import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/filtered_items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/repository/items_repository.dart';

class MockItemsBlock extends MockBloc<ItemsEvent, ItemsState>
    implements ItemsBloc {}

class MockItemsRepository extends Mock implements ItemsRepository {}

void main() {
  group('FilteredItemsBloc', () {
    blocTest<FilteredItemsBloc, FilteredItemsEvent, FilteredItemsState>(
      'adds ItemsUpdated when ItemsBloc.state emits ItemsLoaded',
      build: () {
        final itemsBloc = MockItemsBlock();
        whenListen(
          itemsBloc,
          Stream<ItemsState>.fromIterable([
            ItemsLoaded([Item('Crackers', id: '0')]),
          ]),
        );
        return FilteredItemsBloc(itemsBloc: itemsBloc);
      },
      expect: [
        FilteredItemsStateLoading(),
        FilteredItemsStateLoaded(
          from(null, [Item('Crackers', id: '0')]),
        ),
      ],
    );
  });
}
