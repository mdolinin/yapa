import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/filtered_items.dart';
import 'package:yapa/bloc/shopping_list/selected.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/repository/items_repository.dart';

class MockItemsBlock extends MockBloc<ItemsEvent, ItemsState>
    implements ItemsBloc {}

class MockSelectedBlock extends MockBloc<SelectedBloc, SelectedState>
    implements SelectedBloc {}

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
        final selectedBloc = MockSelectedBlock();
        whenListen(
          selectedBloc,
          Stream<SelectedState>.fromIterable([InitialSelectedState()]),
        );
        return FilteredItemsBloc(
            itemsBloc: itemsBloc, selectedBloc: selectedBloc);
      },
      expect: [
        FilteredItemsStateLoading(),
        FilteredItemsStateLoaded(
            from(null, false, [Item('Crackers', id: '0')]), false),
      ],
    );

    blocTest<FilteredItemsBloc, FilteredItemsEvent, FilteredItemsState>(
      'adds FilterUpdated when SelectedBloc.state emits InitialSelectedState',
      build: () {
        var itemsLoaded = ItemsLoaded([Item('Pretzels', id: '1')]);
        final itemsBloc = MockItemsBlock();
        when(itemsBloc.state).thenAnswer((_) => itemsLoaded);
        whenListen(
          itemsBloc,
          Stream<ItemsState>.fromIterable([
            itemsLoaded,
          ]),
        );
        final selectedBloc = MockSelectedBlock();
        whenListen(
          selectedBloc,
          Stream<SelectedState>.fromIterable([
            InitialSelectedState(selected: true),
          ]),
        );
        return FilteredItemsBloc(
            itemsBloc: itemsBloc, selectedBloc: selectedBloc);
      },
      expect: [
        FilteredItemsStateLoading(),
        FilteredItemsStateLoaded(
            from(null, false, [Item('Pretzels', id: '1')]), false),
        FilteredItemsStateLoaded(
            from(null, true, [Item('Pretzels', id: '1')]), true),
      ],
    );
  });
}
