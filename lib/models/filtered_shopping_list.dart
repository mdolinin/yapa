import 'package:equatable/equatable.dart';
import 'package:yapa/models/item.dart';

class FilteredShoppingList extends Equatable {
  final String tag;
  final List<FilteredCategory> categories;

  FilteredShoppingList(this.tag, this.categories);

  @override
  List<Object> get props => [tag, categories];

  @override
  bool get stringify => true;
}

class FilteredCategory extends Equatable {
  final String name;
  final List<Item> items;

  FilteredCategory(this.name, this.items);

  @override
  List<Object> get props => [name, items];

  @override
  bool get stringify => true;
}
