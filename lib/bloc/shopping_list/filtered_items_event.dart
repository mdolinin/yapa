import 'package:equatable/equatable.dart';
import 'package:yapa/models/filtered_shopping_list.dart';
import 'package:yapa/models/item.dart';

abstract class FilteredItemsEvent extends Equatable {
  const FilteredItemsEvent();
}

class ItemsUpdated extends FilteredItemsEvent {
  final List<Item> items;

  const ItemsUpdated(this.items);

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;
}

class FilterUpdated extends FilteredItemsEvent {
  final bool selected;

  FilterUpdated(this.selected);

  @override
  List<Object> get props => [selected];

  @override
  bool get stringify => true;
}

class FilteredCategoriesUpdated extends FilteredItemsEvent {
  final List<FilteredCategory> categories;

  const FilteredCategoriesUpdated(this.categories);

  @override
  List<Object> get props => [categories];

  @override
  bool get stringify => true;
}
