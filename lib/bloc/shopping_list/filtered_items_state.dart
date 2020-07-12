import 'package:equatable/equatable.dart';
import 'package:yapa/models/tagged_categorized_items.dart';

abstract class FilteredItemsState extends Equatable {
  const FilteredItemsState();

  @override
  List<Object> get props => [];
}

class FilteredItemsStateLoading extends FilteredItemsState {}

class FilteredItemsStateLoaded extends FilteredItemsState {
  final String tag;
  final bool selected;
  final List<CategorizedItems> categorizedItems;

  FilteredItemsStateLoaded(this.tag, this.selected, this.categorizedItems);

  @override
  List<Object> get props => [tag, selected, categorizedItems];

  @override
  bool get stringify => true;
}

class FilteredItemsStateNotLoaded extends FilteredItemsState {}
