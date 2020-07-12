import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/shopping_list/filtered_items.dart';
import 'package:yapa/bloc/shopping_list/selected.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

class MockShoppingItemsTreeBloc
    extends MockBloc<ShoppingItemsTreeEvent, ShoppingItemsTreeState>
    implements ShoppingItemsTreeBloc {}

class MockSelectedBlock extends MockBloc<SelectedBloc, SelectedState>
    implements SelectedBloc {}

void main() {
  group('FilteredItemsBloc', () {
    blocTest<FilteredItemsBloc, FilteredItemsEvent, FilteredItemsState>(
      'adds CategoriesOrItemsUpdated when ShoppingItemsTreeBloc.state emits ShoppingItemsTreeLoaded',
      build: () {
        final shoppingItemsTreeBloc = MockShoppingItemsTreeBloc();
        whenListen(
          shoppingItemsTreeBloc,
          Stream<ShoppingItemsTreeLoaded>.fromIterable([
            ShoppingItemsTreeLoaded({
              "": [
                CategorizedItems("", [Item('Crackers', id: '0')])
              ]
            }),
          ]),
        );
        final selectedBloc = MockSelectedBlock();
        whenListen(
          selectedBloc,
          Stream<SelectedState>.fromIterable([InitialSelectedState()]),
        );
        return FilteredItemsBloc(
            tagNameToFilter: "",
            shoppingItemsTreeBloc: shoppingItemsTreeBloc,
            selectedBloc: selectedBloc);
      },
      expect: [
        FilteredItemsStateLoading(),
        FilteredItemsStateLoaded("", false, [
          CategorizedItems("", [Item('Crackers', id: '0')])
        ]),
      ],
    );

    blocTest<FilteredItemsBloc, FilteredItemsEvent, FilteredItemsState>(
      'adds FilterUpdated when SelectedBloc.state emits InitialSelectedState',
      build: () {
        var itemsLoaded = ShoppingItemsTreeLoaded({
          "": [
            CategorizedItems("", [Item('Pretzels', id: '1')])
          ]
        });
        final shoppingItemsTreeBloc = MockShoppingItemsTreeBloc();
        when(shoppingItemsTreeBloc.state).thenAnswer((_) => itemsLoaded);
        whenListen(
          shoppingItemsTreeBloc,
          Stream<ShoppingItemsTreeState>.fromIterable([
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
            tagNameToFilter: "",
            shoppingItemsTreeBloc: shoppingItemsTreeBloc,
            selectedBloc: selectedBloc);
      },
      expect: [
        FilteredItemsStateLoading(),
        FilteredItemsStateLoaded("", false, [
          CategorizedItems("", [Item('Pretzels', id: '1')])
        ]),
        FilteredItemsStateLoaded("", true, [CategorizedItems("", [])]),
      ],
    );
  });
}
