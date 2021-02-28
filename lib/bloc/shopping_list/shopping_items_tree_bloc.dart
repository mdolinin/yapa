import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/bloc/categories/categories.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';
import 'package:yapa/repository/category_repository.dart';

import './shopping_items_tree.dart';

class ShoppingItemsTreeBloc
    extends Bloc<ShoppingItemsTreeEvent, ShoppingItemsTreeState> {
  final List<String> defaultCategoriesOrder = category_names.toList();

  final ItemsBloc itemsBloc;
  final CategoriesBloc categoriesBloc;
  StreamSubscription itemsSubscription;
  StreamSubscription categoriesSubscription;

  ShoppingItemsTreeBloc(
      {@required this.itemsBloc, @required this.categoriesBloc}) {
    itemsSubscription = itemsBloc.listen((state) {
      if (state is ItemsLoaded) {
        add(ItemsUpdated(state.items));
      }
    });
    categoriesSubscription = categoriesBloc.listen((state) {
      if (state is CategoriesLoaded) {
        add(CategoriesUpdated(state.categories));
      }
    });
  }

  @override
  ShoppingItemsTreeState get initialState => ShoppingItemsTreeLoading();

  @override
  Stream<ShoppingItemsTreeState> mapEventToState(
      ShoppingItemsTreeEvent event) async* {
    if (event is CategorizedItemsUpdated) {
      yield* _mapCategorizedItemsUpdatedToState(event);
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    } else if (event is CategoriesUpdated) {
      yield* _mapCategoriesUpdatedToState(event);
    }
  }

  Stream<ShoppingItemsTreeState> _mapItemsUpdatedToState(
      ItemsUpdated event) async* {
    Map<String, List<CategorizedItems>> taggedCategorizedItems;
    if (state is ShoppingItemsTreeLoaded) {
      // Clean up old state from items
      Map<String, List<CategorizedItems>> oldState =
          (state as ShoppingItemsTreeLoaded).taggedCategorizedItems;
      Map<String, List<CategorizedItems>> newState = {};
      oldState.forEach((key, oldList) {
        List<CategorizedItems> newCategorizedItems = [];
        for (CategorizedItems oldItems in oldList) {
          newCategorizedItems.add(CategorizedItems(oldItems.category, []));
        }
        newState[key] = newCategorizedItems;
      });
      taggedCategorizedItems = newState;
    } else {
      taggedCategorizedItems =
          buildDefaultShoppingItemsTreeFrom(defaultCategoriesOrder.toSet());
    }

    final items = event.items;
    for (Item item in items) {
      //Add to main list with tag null
      categorizeItem(taggedCategorizedItems[null], item);
      //Select no tag and add to secondary list with tag ""
      if (item.tags.isEmpty) {
        categorizeItem(taggedCategorizedItems[""], item);
      }
      List<String> tags = item.tags;
      for (String tag in tags) {
        if (taggedCategorizedItems[tag] == null) {
          // new tag
          taggedCategorizedItems[tag] = defaultCategoriesOrder
              .map((name) => CategorizedItems(name, []))
              .toList();
        }
        final categorizedItemsList = taggedCategorizedItems[tag];
        categorizeItem(categorizedItemsList, item);
      }
    }
    yield ShoppingItemsTreeLoaded(taggedCategorizedItems);
  }

  Stream<ShoppingItemsTreeState> _mapCategoriesUpdatedToState(
      CategoriesUpdated event) async* {
    final List<Category> categories = event.categories;
    final Set<String> categoriesNames = categories.map((e) => e.name).toSet();
    Map<String, List<CategorizedItems>> taggedCategorizedItems;
    if (state is ShoppingItemsTreeLoaded) {
      Map<String, List<CategorizedItems>> oldState =
          (state as ShoppingItemsTreeLoaded).taggedCategorizedItems;
      Map<String, List<CategorizedItems>> newState = {};
      oldState.forEach((key, oldList) {
        List<CategorizedItems> newCategorizedItems = [];
        for (String newCategoryName in categoriesNames) {
          bool existingCategory = false;
          for (CategorizedItems oldItems in oldList) {
            if (oldItems.category == newCategoryName) {
              newCategorizedItems
                  .add(CategorizedItems(oldItems.category, oldItems.items));
              existingCategory = true;
              break;
            }
          }
          if (!existingCategory) {
            newCategorizedItems.add(CategorizedItems(newCategoryName, []));
          }
        }
        newState[key] = newCategorizedItems;
      });
      taggedCategorizedItems = newState;
    } else {
      taggedCategorizedItems =
          buildDefaultShoppingItemsTreeFrom(categoriesNames);
    }
    yield ShoppingItemsTreeLoaded(taggedCategorizedItems);
  }

  Map<String, List<CategorizedItems>> buildDefaultShoppingItemsTreeFrom(
      Set<String> categoriesOrder) {
    final Map<String, List<CategorizedItems>> defaultTaggedCategorizedItems =
        {};
    defaultTaggedCategorizedItems[null] =
        categoriesOrder.map((name) => CategorizedItems(name, [])).toList();
    defaultTaggedCategorizedItems[''] =
        categoriesOrder.map((name) => CategorizedItems(name, [])).toList();
    return defaultTaggedCategorizedItems;
  }

  void categorizeItem(List<CategorizedItems> categorizedItemsList, Item item) {
    bool existingCategory = false;
    for (CategorizedItems categorizedItems in categorizedItemsList) {
      if (item.category == categorizedItems.category) {
        categorizedItems.items.add(item);
        existingCategory = true;
        break;
      }
    }
    if (!existingCategory) {
      categorizedItemsList.add(CategorizedItems(item.category, [item]));
    }
  }

  Stream<ShoppingItemsTreeState> _mapCategorizedItemsUpdatedToState(
      CategorizedItemsUpdated event) async* {
    if (state is ShoppingItemsTreeLoaded) {
      final taggedCategorizedItems =
          new Map<String, List<CategorizedItems>>.from(
              (state as ShoppingItemsTreeLoaded).taggedCategorizedItems);
      taggedCategorizedItems[event.tag] = event.items;
      yield ShoppingItemsTreeLoaded(taggedCategorizedItems);
    }
  }

  @override
  Future<void> close() {
    itemsSubscription.cancel();
    categoriesSubscription.cancel();
    return super.close();
  }
}
