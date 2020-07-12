import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

@immutable
abstract class ShoppingItemsTreeState extends Equatable {
  const ShoppingItemsTreeState();

  @override
  List<Object> get props => [];
}

class ShoppingItemsTreeLoading extends ShoppingItemsTreeState {}

class ShoppingItemsTreeLoaded extends ShoppingItemsTreeState {
  final Map<String, List<CategorizedItems>> taggedCategorizedItems;

  ShoppingItemsTreeLoaded(this.taggedCategorizedItems);

  @override
  List<Object> get props => [taggedCategorizedItems];

  @override
  bool get stringify => true;
}

class ShoppingItemsTreeNotLoaded extends ShoppingItemsTreeState {}
