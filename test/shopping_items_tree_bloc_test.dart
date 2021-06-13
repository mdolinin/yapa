import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';
import 'package:yapa/repository/category_repository.dart';

class MockItemsBloc extends MockBloc<ItemsEvent, ItemsState>
    implements ItemsBloc {}

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  group('FilteredItemsBloc', () {
    blocTest<ShoppingItemsTreeBloc, ShoppingItemsTreeEvent,
        ShoppingItemsTreeState>(
      'adds ItemsUpdated when ItemsBlock.state emits ItemsLoaded',
      build: () {
        final itemsBloc = MockItemsBloc();
        whenListen(
          itemsBloc,
          Stream<ItemsState>.fromIterable([
            ItemsLoaded([Item('Crackers', id: '0')]),
          ]),
        );
        final categoriesBloc = MockCategoriesBloc();
        whenListen(categoriesBloc, Stream<CategoriesState>.empty());
        return ShoppingItemsTreeBloc(
            itemsBloc: itemsBloc, categoriesBloc: categoriesBloc);
      },
      expect: [
        ShoppingItemsTreeLoading(),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems(
                defaultCategories.elementAt(0), [Item('Crackers', id: '0')]),
            CategorizedItems(defaultCategories.elementAt(1), []),
            CategorizedItems(defaultCategories.elementAt(2), []),
            CategorizedItems(defaultCategories.elementAt(3), []),
            CategorizedItems(defaultCategories.elementAt(4), []),
            CategorizedItems(defaultCategories.elementAt(5), []),
            CategorizedItems(defaultCategories.elementAt(6), []),
            CategorizedItems(defaultCategories.elementAt(7), []),
            CategorizedItems(defaultCategories.elementAt(8), []),
            CategorizedItems(defaultCategories.elementAt(9), []),
            CategorizedItems(defaultCategories.elementAt(10), []),
            CategorizedItems(defaultCategories.elementAt(11), []),
            CategorizedItems(defaultCategories.elementAt(12), [])
          ],
          '': [
            CategorizedItems(
                defaultCategories.elementAt(0), [Item('Crackers', id: '0')]),
            CategorizedItems(defaultCategories.elementAt(1), []),
            CategorizedItems(defaultCategories.elementAt(2), []),
            CategorizedItems(defaultCategories.elementAt(3), []),
            CategorizedItems(defaultCategories.elementAt(4), []),
            CategorizedItems(defaultCategories.elementAt(5), []),
            CategorizedItems(defaultCategories.elementAt(6), []),
            CategorizedItems(defaultCategories.elementAt(7), []),
            CategorizedItems(defaultCategories.elementAt(8), []),
            CategorizedItems(defaultCategories.elementAt(9), []),
            CategorizedItems(defaultCategories.elementAt(10), []),
            CategorizedItems(defaultCategories.elementAt(11), []),
            CategorizedItems(defaultCategories.elementAt(12), [])
          ]
        }),
      ],
    );

    blocTest<ShoppingItemsTreeBloc, ShoppingItemsTreeEvent,
        ShoppingItemsTreeState>(
      'should update a list of filtered categories in response to CategorizedItemsUpdated Event',
      build: () {
        final itemsBloc = MockItemsBloc();
        whenListen(
          itemsBloc,
          Stream<ItemsState>.fromIterable([]),
        );
        final categoriesBloc = MockCategoriesBloc();
        whenListen(categoriesBloc, Stream<CategoriesState>.empty());
        return ShoppingItemsTreeBloc(
            itemsBloc: itemsBloc, categoriesBloc: categoriesBloc);
      },
      act: (ShoppingItemsTreeBloc bloc) async {
        bloc
          ..add(ItemsUpdated([
            Item('Crackers', id: '0', category: defaultCategories.elementAt(1))
          ]))
          ..add(CategorizedItemsUpdated(
            "",
            [
              CategorizedItems(Category("Appetizers", id: "13"), []),
              CategorizedItems(Category("Puddings", id: "14"), [])
            ],
          ));
      },
      expect: [
        ShoppingItemsTreeLoading(),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems(defaultCategories.elementAt(0), []),
            CategorizedItems(defaultCategories.elementAt(1), [
              Item('Crackers',
                  id: '0', category: defaultCategories.elementAt(1))
            ]),
            CategorizedItems(defaultCategories.elementAt(2), []),
            CategorizedItems(defaultCategories.elementAt(3), []),
            CategorizedItems(defaultCategories.elementAt(4), []),
            CategorizedItems(defaultCategories.elementAt(5), []),
            CategorizedItems(defaultCategories.elementAt(6), []),
            CategorizedItems(defaultCategories.elementAt(7), []),
            CategorizedItems(defaultCategories.elementAt(8), []),
            CategorizedItems(defaultCategories.elementAt(9), []),
            CategorizedItems(defaultCategories.elementAt(10), []),
            CategorizedItems(defaultCategories.elementAt(11), []),
            CategorizedItems(defaultCategories.elementAt(12), [])
          ],
          '': [
            CategorizedItems(defaultCategories.elementAt(0), []),
            CategorizedItems(defaultCategories.elementAt(1), [
              Item('Crackers',
                  id: '0', category: defaultCategories.elementAt(1))
            ]),
            CategorizedItems(defaultCategories.elementAt(2), []),
            CategorizedItems(defaultCategories.elementAt(3), []),
            CategorizedItems(defaultCategories.elementAt(4), []),
            CategorizedItems(defaultCategories.elementAt(5), []),
            CategorizedItems(defaultCategories.elementAt(6), []),
            CategorizedItems(defaultCategories.elementAt(7), []),
            CategorizedItems(defaultCategories.elementAt(8), []),
            CategorizedItems(defaultCategories.elementAt(9), []),
            CategorizedItems(defaultCategories.elementAt(10), []),
            CategorizedItems(defaultCategories.elementAt(11), []),
            CategorizedItems(defaultCategories.elementAt(12), [])
          ]
        }),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems(defaultCategories.elementAt(0), []),
            CategorizedItems(defaultCategories.elementAt(1), [
              Item('Crackers',
                  id: '0', category: defaultCategories.elementAt(1))
            ]),
            CategorizedItems(defaultCategories.elementAt(2), []),
            CategorizedItems(defaultCategories.elementAt(3), []),
            CategorizedItems(defaultCategories.elementAt(4), []),
            CategorizedItems(defaultCategories.elementAt(5), []),
            CategorizedItems(defaultCategories.elementAt(6), []),
            CategorizedItems(defaultCategories.elementAt(7), []),
            CategorizedItems(defaultCategories.elementAt(8), []),
            CategorizedItems(defaultCategories.elementAt(9), []),
            CategorizedItems(defaultCategories.elementAt(10), []),
            CategorizedItems(defaultCategories.elementAt(11), []),
            CategorizedItems(defaultCategories.elementAt(12), [])
          ],
          '': [
            CategorizedItems(Category("Appetizers", id: "13"), []),
            CategorizedItems(Category("Puddings", id: "14"), [])
          ]
        }),
      ],
    );
  });
}
