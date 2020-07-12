import 'package:equatable/equatable.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

abstract class FilteredItemsEvent extends Equatable {
  const FilteredItemsEvent();
}

class FilterUpdated extends FilteredItemsEvent {
  final bool selected;

  FilterUpdated(this.selected);

  @override
  List<Object> get props => [selected];

  @override
  bool get stringify => true;
}

class CategoriesOrItemsUpdated extends FilteredItemsEvent {
  final List<CategorizedItems> categorizedItems;

  const CategoriesOrItemsUpdated(this.categorizedItems);

  @override
  List<Object> get props => [categorizedItems];

  @override
  bool get stringify => true;
}
