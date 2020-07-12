import 'package:equatable/equatable.dart';
import 'package:yapa/models/item.dart';

class CategorizedItems extends Equatable {
  final String category;
  final List<Item> items;

  CategorizedItems(this.category, this.items);

  @override
  List<Object> get props => [category, items];

  @override
  bool get stringify => true;
}
