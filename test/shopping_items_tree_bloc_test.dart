import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

class MockItemsBloc extends MockBloc<ItemsEvent, ItemsState>
    implements ItemsBloc {}

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
        return ShoppingItemsTreeBloc(itemsBloc: itemsBloc);
      },
      expect: [
        ShoppingItemsTreeLoading(),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems('', [Item('Crackers', id: '0')]),
            CategorizedItems('Bread and Cookies', []),
            CategorizedItems('Vegetables and Herbs', []),
            CategorizedItems('Fruits and Berries', []),
            CategorizedItems(
                'Nuts, Seeds, Chocolate, Dried Fruits, Snacks', []),
            CategorizedItems('Grains, Legumes, Pasta, other Dry Goods', []),
            CategorizedItems('Condiments, Oils, Spices, Herbs, Baking', []),
            CategorizedItems('Meat, Fish, Poultry', []),
            CategorizedItems('Dairy', []),
            CategorizedItems('Frozen Food', []),
            CategorizedItems('Beverages', []),
            CategorizedItems('Canned Food', []),
            CategorizedItems('Household, Health, other Misc.', [])
          ],
          '': [
            CategorizedItems('', [Item('Crackers', id: '0')]),
            CategorizedItems('Bread and Cookies', []),
            CategorizedItems('Vegetables and Herbs', []),
            CategorizedItems('Fruits and Berries', []),
            CategorizedItems(
                'Nuts, Seeds, Chocolate, Dried Fruits, Snacks', []),
            CategorizedItems('Grains, Legumes, Pasta, other Dry Goods', []),
            CategorizedItems('Condiments, Oils, Spices, Herbs, Baking', []),
            CategorizedItems('Meat, Fish, Poultry', []),
            CategorizedItems('Dairy', []),
            CategorizedItems('Frozen Food', []),
            CategorizedItems('Beverages', []),
            CategorizedItems('Canned Food', []),
            CategorizedItems('Household, Health, other Misc.', [])
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
        return ShoppingItemsTreeBloc(itemsBloc: itemsBloc);
      },
      act: (ShoppingItemsTreeBloc bloc) async {
        bloc
          ..add(ItemsUpdated(
              [Item('Crackers', id: '0', category: "Bread and Cookies")]))
          ..add(CategorizedItemsUpdated(
            "",
            [
              CategorizedItems("Appetizers", []),
              CategorizedItems("Puddings", [])
            ],
          ));
      },
      expect: [
        ShoppingItemsTreeLoading(),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems('', []),
            CategorizedItems('Bread and Cookies',
                [Item('Crackers', id: '0', category: "Bread and Cookies")]),
            CategorizedItems('Vegetables and Herbs', []),
            CategorizedItems('Fruits and Berries', []),
            CategorizedItems(
                'Nuts, Seeds, Chocolate, Dried Fruits, Snacks', []),
            CategorizedItems('Grains, Legumes, Pasta, other Dry Goods', []),
            CategorizedItems('Condiments, Oils, Spices, Herbs, Baking', []),
            CategorizedItems('Meat, Fish, Poultry', []),
            CategorizedItems('Dairy', []),
            CategorizedItems('Frozen Food', []),
            CategorizedItems('Beverages', []),
            CategorizedItems('Canned Food', []),
            CategorizedItems('Household, Health, other Misc.', [])
          ],
          '': [
            CategorizedItems('', []),
            CategorizedItems('Bread and Cookies',
                [Item('Crackers', id: '0', category: "Bread and Cookies")]),
            CategorizedItems('Vegetables and Herbs', []),
            CategorizedItems('Fruits and Berries', []),
            CategorizedItems(
                'Nuts, Seeds, Chocolate, Dried Fruits, Snacks', []),
            CategorizedItems('Grains, Legumes, Pasta, other Dry Goods', []),
            CategorizedItems('Condiments, Oils, Spices, Herbs, Baking', []),
            CategorizedItems('Meat, Fish, Poultry', []),
            CategorizedItems('Dairy', []),
            CategorizedItems('Frozen Food', []),
            CategorizedItems('Beverages', []),
            CategorizedItems('Canned Food', []),
            CategorizedItems('Household, Health, other Misc.', [])
          ]
        }),
        ShoppingItemsTreeLoaded({
          null: [
            CategorizedItems('', []),
            CategorizedItems('Bread and Cookies',
                [Item('Crackers', id: '0', category: "Bread and Cookies")]),
            CategorizedItems('Vegetables and Herbs', []),
            CategorizedItems('Fruits and Berries', []),
            CategorizedItems(
                'Nuts, Seeds, Chocolate, Dried Fruits, Snacks', []),
            CategorizedItems('Grains, Legumes, Pasta, other Dry Goods', []),
            CategorizedItems('Condiments, Oils, Spices, Herbs, Baking', []),
            CategorizedItems('Meat, Fish, Poultry', []),
            CategorizedItems('Dairy', []),
            CategorizedItems('Frozen Food', []),
            CategorizedItems('Beverages', []),
            CategorizedItems('Canned Food', []),
            CategorizedItems('Household, Health, other Misc.', [])
          ],
          '': [
            CategorizedItems("Appetizers", []),
            CategorizedItems("Puddings", [])
          ]
        }),
      ],
    );
  });
}
