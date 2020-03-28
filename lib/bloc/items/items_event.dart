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
