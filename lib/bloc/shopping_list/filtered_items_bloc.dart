import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:yapa/bloc/items/items.dart';
import 'package:yapa/bloc/shopping_list/selected.dart';
import 'package:yapa/bloc/shopping_list/selected_bloc.dart';
import 'package:yapa/models/filtered_shopping_list.dart';
import 'package:yapa/models/item.dart';

import './filtered_items.dart';

typedef ItemFilter = bool Function(Item);

class FilteredItemsBloc extends Bloc<FilteredItemsEvent, FilteredItemsState> {
  final String tagNameToFilter;
  final ItemsBloc itemsBloc;
  final SelectedBloc selectedBloc;
  StreamSubscription itemsSubscription;
  StreamSubscription selectedSubscription;

  FilteredItemsBloc(
      {this.tagNameToFilter,
      @required this.itemsBloc,
      @required this.selectedBloc}) {
    itemsSubscription = itemsBloc.listen((state) {
      if (state is ItemsLoaded) {
        add(ItemsUpdated(state.items));
      }
    });
    selectedSubscription = selectedBloc.listen((state) {
      if (state is InitialSelectedState) {
        add(FilterUpdated(state.selected));
      }
    });
  }

  @override
  FilteredItemsState get initialState => FilteredItemsStateLoading();

  @override
  Stream<FilteredItemsState> mapEventToState(FilteredItemsEvent event) async* {
    if (event is FilterUpdated) {
      yield* _maUpdateFilterToState(event);
    } else if (event is ItemsUpdated) {
      yield* _mapItemsUpdatedToState(event);
    }
  }

  Stream<FilteredItemsState> _maUpdateFilterToState(
      FilterUpdated event) async* {
    if (itemsBloc.state is ItemsLoaded) {
      var items = (itemsBloc.state as ItemsLoaded).items;
      yield FilteredItemsStateLoaded(
          from(tagNameToFilter, event.selected, items), event.selected);
    }
  }

  Stream<FilteredItemsState> _mapItemsUpdatedToState(
      ItemsUpdated event) async* {
    final selected = state is FilteredItemsStateLoaded
        ? (state as FilteredItemsStateLoaded).selected
        : false;
    yield FilteredItemsStateLoaded(
        from(tagNameToFilter, selected, event.items), selected);
  }

  @override
  Future<void> close() {
    itemsSubscription.cancel();
    selectedSubscription.cancel();
    return super.close();
  }
}

FilteredShoppingList from(String tag, bool selected, List<Item> items) {
  final List<Item> filteredByTag = items
      .where(_filterFrom(tag))
      .where((e) => e.selected == selected)
      .toList();
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
