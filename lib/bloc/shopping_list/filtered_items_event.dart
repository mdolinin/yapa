import 'package:equatable/equatable.dart';
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
