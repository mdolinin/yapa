import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/item.dart';

@immutable
abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadItems extends ItemsEvent {}

class AddItem extends ItemsEvent {
  final Item item;

  const AddItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'AddItem { item: $item }';
}

class UpdateItem extends ItemsEvent {
  final Item updatedItem;

  const UpdateItem(this.updatedItem);

  @override
  List<Object> get props => [updatedItem];

  @override
  String toString() => 'ItemUpdated { item: $updatedItem }';
}

class DeleteItem extends ItemsEvent {
  final Item item;

  const DeleteItem(this.item);

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem { item: $item }';
}
