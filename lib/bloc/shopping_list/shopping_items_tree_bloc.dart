import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';
import 'package:yapa/repository/category_repository.dart';

import './shopping_items_tree.dart';

class ShoppingItemsTreeBloc
    extends Bloc<ShoppingItemsTreeEvent, ShoppingItemsTreeState> {
  final List<String> defaultCategoriesOrder = category_names.toList();

  final ItemsBloc itemsBloc;
  StreamSubscription itemsSubscription;

  ShoppingItemsTreeBloc({@required this.itemsBloc}) {
    itemsSubscription = itemsBloc.listen((state) {
      if (state is ItemsLoaded) {
        add(ItemsUpdated(state.items));
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
      taggedCategorizedItems = buildDefaultShoppingItemsTree();
    }

    final items = event.items;
    Set<String> similarIds = Set();
    for (Item item in items) {
      similarIds.addAll(item.similarItems.map((e) => e.id).toSet());
      if (!similarIds.contains(item.id)) {
        //Add to main list with tag null
        categorizeItem(taggedCategorizedItems[null], item);
        //Select no tag and add to secondary list with tag ""
        if (item.tags.isEmpty) {
          categorizeItem(taggedCategorizedItems[""], item);
        }
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

  Map<String, List<CategorizedItems>> buildDefaultShoppingItemsTree() {
    final Map<String, List<CategorizedItems>> defaultTaggedCategorizedItems =
        {};
    defaultTaggedCategorizedItems[null] = defaultCategoriesOrder
        .map((name) => CategorizedItems(name, []))
        .toList();
    defaultTaggedCategorizedItems[''] = defaultCategoriesOrder
        .map((name) => CategorizedItems(name, []))
        .toList();
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
    return super.close();
  }
}
