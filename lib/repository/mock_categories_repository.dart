import 'dart:async';

import 'package:yapa/repository/category_repository.dart';

import 'category_entity.dart';

class MockCategoriesRepository extends CategoriesRepository {
  final Duration delay = const Duration(milliseconds: 500);

  @override
  Future<List<CategoryEntity>> loadCategories() async {
    return Future.delayed(delay, () => []);
  }

  @override
  Future<bool> saveCategories(List<CategoryEntity> categories) async {
    return Future.value(true);
  }
}
