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
  final List<String> categoriesOrder;

  FilteredItemsStateLoaded(
      this.filteredShoppingList, this.selected, this.categoriesOrder);

  @override
  List<Object> get props => [filteredShoppingList, selected, categoriesOrder];

  @override
  bool get stringify => true;
}

class FilteredItemsStateNotLoaded extends FilteredItemsState {}
