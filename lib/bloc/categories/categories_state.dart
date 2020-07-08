import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/category.dart';

@immutable
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoaded([this.categories = const []]);

  @override
  List<Object> get props => [categories];

  @override
  String toString() => 'CategoriesLoaded { categories: $categories }';
}

class CategoriesNotLoaded extends CategoriesState {}
