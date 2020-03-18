import 'package:equatable/equatable.dart';
import 'package:yapa/models/item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;

  const ItemsLoaded([this.items = const []]);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsLoaded { items: $items }';
}

class ItemsNotLoaded extends ItemsState {}
