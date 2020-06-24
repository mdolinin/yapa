import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/models/filtered_shopping_list.dart';
import 'package:yapa/models/item.dart';

import './filtered_items.dart';

typedef ItemFilter = bool Function(Item);

class FilteredItemsBloc extends Bloc<FilteredItemsEvent, FilteredItemsState> {
  final String tagNameToFilter;
  final ItemsBloc itemsBloc;
  StreamSubscription itemsSubscription;

  FilteredItemsBloc({this.tagNameToFilter, @required this.itemsBloc}) {
    itemsSubscription = itemsBloc.listen((state) {
      if (state is ItemsLoaded) {
        add(ItemsUpdated(state.items));
      }
    });
  }

  @override
  FilteredItemsState get initialState => FilteredItemsStateLoading();

  @override
  Stream<FilteredItemsState> mapEventToState(FilteredItemsEvent event) async* {
    if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<FilteredItemsState> _mapItemsUpdatedToState(
      ItemsUpdated event) async* {
    yield FilteredItemsStateLoaded(from(tagNameToFilter, event.items));
  }

  @override
  Future<void> close() {
    itemsSubscription.cancel();
    return super.close();
  }
}

FilteredShoppingList from(String tag, List<Item> items) {
  final List<Item> filteredByTag = items.where(_filterFrom(tag)).toList();
  final List<Item> sortedByName = filteredByTag
    ..sort((a, b) => a.name.compareTo(b.name));
  final Map<String, List<Item>> groupedByCategory =
      groupBy(sortedByName, (Item item) => item.category);
  final List<FilteredCategory> filteredCategories = groupedByCategory.entries
      .toList()
      .map((MapEntry<String, List<Item>> entry) =>
          FilteredCategory(entry.key, entry.value))
      .toList();
  return FilteredShoppingList(tag, filteredCategories);
}

ItemFilter _filterFrom(String tag) {
  ItemFilter defaultFilter = (item) => true;
  ItemFilter filterNoTag = (item) => item.tags.isEmpty;
  ItemFilter filterByTag = (item) => item.tags.contains(tag);
  ItemFilter filter;
  if (tag == null) {
    filter = defaultFilter;
  } else if (tag == '') {
    filter = filterNoTag;
  } else {
    filter = filterByTag;
  }
  return filter;
}
