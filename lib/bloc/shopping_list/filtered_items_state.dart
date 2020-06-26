import 'package:equatable/equatable.dart';
import 'package:yapa/models/filtered_shopping_list.dart';

abstract class FilteredItemsState extends Equatable {
  const FilteredItemsState();

  @override
  List<Object> get props => [];
}

class FilteredItemsStateLoading extends FilteredItemsState {}

class FilteredItemsStateLoaded extends FilteredItemsState {
  final FilteredShoppingList filteredShoppingList;
  final bool selected;

  FilteredItemsStateLoaded(this.filteredShoppingList, this.selected);

  @override
  List<Object> get props => [filteredShoppingList, selected];

  @override
  bool get stringify => true;
}

class FilteredItemsStateNotLoaded extends FilteredItemsState {}
