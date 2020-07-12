import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/bloc/shopping_list/selected.dart';
import 'package:yapa/bloc/shopping_list/selected_bloc.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_bloc.dart';
import 'package:yapa/bloc/shopping_list/shopping_items_tree_state.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

import './filtered_items.dart';

typedef ItemFilter = bool Function(Item);

class FilteredItemsBloc extends Bloc<FilteredItemsEvent, FilteredItemsState> {
  final String tagNameToFilter;
  final ShoppingItemsTreeBloc shoppingItemsTreeBloc;
  final SelectedBloc selectedBloc;
  StreamSubscription shoppingItemsTreeSubscription;
  StreamSubscription selectedSubscription;

  FilteredItemsBloc(
      {this.tagNameToFilter,
      @required this.shoppingItemsTreeBloc,
      @required this.selectedBloc}) {
    shoppingItemsTreeSubscription = shoppingItemsTreeBloc.listen((state) {
      if (state is ShoppingItemsTreeLoaded) {
        add(CategoriesOrItemsUpdated(
            state.taggedCategorizedItems[tagNameToFilter]));
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
    if (event is CategoriesOrItemsUpdated) {
      yield* _mapCategorizedItemsUpdatedToState(event);
    } else if (event is FilterUpdated) {
      yield* _mapUpdateFilterToState(event);
    }
  }

  Stream<FilteredItemsState> _mapUpdateFilterToState(
      FilterUpdated event) async* {
    if (shoppingItemsTreeBloc.state is ShoppingItemsTreeLoaded) {
      final selected = event.selected;
      final stateLoaded =
          (shoppingItemsTreeBloc.state as ShoppingItemsTreeLoaded);
      final List<CategorizedItems> taggedCategorizedItems =
          stateLoaded.taggedCategorizedItems[tagNameToFilter] ?? [];
      final List<CategorizedItems> categorizedItemsList =
          filterSelected(taggedCategorizedItems, selected);
      yield FilteredItemsStateLoaded(
          tagNameToFilter, selected, categorizedItemsList);
    }
  }

  Stream<FilteredItemsState> _mapCategorizedItemsUpdatedToState(
      CategoriesOrItemsUpdated event) async* {
    final selected = state is FilteredItemsStateLoaded
        ? (state as FilteredItemsStateLoaded).selected
        : false;
    final List<CategorizedItems> taggedCategorizedItems =
        event.categorizedItems ?? [];
    final List<CategorizedItems> categorizedItemsList =
        filterSelected(taggedCategorizedItems, selected);
    yield FilteredItemsStateLoaded(
        tagNameToFilter, selected, categorizedItemsList);
  }

  List<CategorizedItems> filterSelected(
      List<CategorizedItems> categorizedItemsList, bool selected) {
    final List<CategorizedItems> newCategorizedItemsList = [];
    for (CategorizedItems categorizedItems in categorizedItemsList) {
      final categorized = CategorizedItems(categorizedItems.category, []);
      for (Item item in categorizedItems.items) {
        if (item.selected == selected) {
          categorized.items.add(item);
        }
      }
      newCategorizedItemsList.add(categorized);
    }
    return newCategorizedItemsList;
  }

  @override
  Future<void> close() {
    shoppingItemsTreeSubscription.cancel();
    selectedSubscription.cancel();
    return super.close();
  }
}
