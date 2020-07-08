import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/category.dart';
import 'package:yapa/repository/category_repository.dart';

import 'categories.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository categoriesRepository;

  CategoriesBloc({@required this.categoriesRepository});

  @override
  CategoriesState get initialState => CategoriesLoading();

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is LoadCategories) {
      yield* _mapLoadCategoriesToState();
    } else if (event is AddCategory) {
      yield* _mapAddCategoryToState(event);
    } else if (event is UpdateCategory) {
      yield* _mapUpdateCategoryToState(event);
    } else if (event is DeleteCategory) {
      yield* _mapDeleteCategoryToState(event);
    }
  }

  Stream<CategoriesState> _mapLoadCategoriesToState() async* {
    try {
      final categories = await this.categoriesRepository.loadCategories();
      yield CategoriesLoaded(categories.map(Category.fromEntity).toList());
    } catch (_) {
      yield CategoriesNotLoaded();
    }
  }

  Stream<CategoriesState> _mapAddCategoryToState(AddCategory event) async* {
    if (state is CategoriesLoaded) {
      final List<Category> updatedCategories =
          List.from((state as CategoriesLoaded).categories)
            ..add(event.category);
      yield CategoriesLoaded(updatedCategories);
      _saveCategories(updatedCategories);
    }
  }

  Stream<CategoriesState> _mapUpdateCategoryToState(
      UpdateCategory event) async* {
    if (state is CategoriesLoaded) {
      final List<Category> updatedCategories = (state as CategoriesLoaded)
          .categories
          .map((category) => category.id == event.updatedCategory.id
              ? event.updatedCategory
              : category)
          .toList();
      yield CategoriesLoaded(updatedCategories);
      _saveCategories(updatedCategories);
    }
  }

  Stream<CategoriesState> _mapDeleteCategoryToState(
      DeleteCategory event) async* {
    if (state is CategoriesLoaded) {
      final List<Category> updatedCategories = (state as CategoriesLoaded)
          .categories
          .where((category) => category.id != event.category.id)
          .toList();
      yield CategoriesLoaded(updatedCategories);
      _saveCategories(updatedCategories);
    }
  }

  Future _saveCategories(List<Category> categories) {
    return categoriesRepository.saveCategories(
        categories.map((category) => category.toEntity()).toList());
  }
}
