import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/item.dart';

@immutable
abstract class ItemsState extends Equatable {
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsLoading extends ItemsState {}

class ItemsLoaded extends ItemsState {
  final List<Item> items;
  final int itemsInCart;
  final double cartTotalPrice;
  final int itemsInList;
  final double listTotalPrice;

  ItemsLoaded(List<Item> items)
      : this.items = items ?? const [],
        this.itemsInCart = (items ?? []).where((Item i) => i.selected).length,
        this.cartTotalPrice = allSelectedPriceFor(items ?? const []),
        this.itemsInList = (items ?? []).length,
        this.listTotalPrice = totalPriceFor(items ?? const []);

  static double allSelectedPriceFor(List<Item> items) => items
      .where((i) => i.selected)
      .map((i) => i.priceOfBaseUnit * i.quantityInBaseUnits)
      .fold(0.0, (value, element) => value + element);

  static double totalPriceFor(List<Item> items) => items
      .map((i) => i.priceOfBaseUnit * i.quantityInBaseUnits)
      .fold(0.0, (value, element) => value + element);

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsLoaded { items: $items }';
}

class ItemsNotLoaded extends ItemsState {}
