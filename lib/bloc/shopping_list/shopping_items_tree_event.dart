import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

@immutable
abstract class ShoppingItemsTreeEvent extends Equatable {
  const ShoppingItemsTreeEvent();
}

class ItemsUpdated extends ShoppingItemsTreeEvent {
  final List<Item> items;

  const ItemsUpdated(this.items);

  @override
  List<Object> get props => [items];

  @override
  bool get stringify => true;
}

class CategorizedItemsUpdated extends ShoppingItemsTreeEvent {
  final String tag;
  final List<CategorizedItems> items;

  const CategorizedItemsUpdated(this.tag, this.items);

  @override
  List<Object> get props => [tag, items];

  @override
  bool get stringify => true;
}
