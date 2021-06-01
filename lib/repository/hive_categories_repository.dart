import 'dart:async';

import 'package:hive/hive.dart';
import 'package:yapa/repository/category_entity.dart';
import 'package:yapa/repository/category_repository.dart';

const k_categories_box_name = 'categories';

class HiveCategoriesRepository extends CategoriesRepository {
  final Box<CategoryEntity> categoriesBox;

  HiveCategoriesRepository(this.categoriesBox);

  @override
  Future<List<CategoryEntity>> loadCategories() async {
    return categoriesBox.keys.map((key) => categoriesBox.get(key)).toList();
  }

  @override
  Future<bool> saveCategories(List<CategoryEntity> categories) async {
    Map<String, CategoryEntity> categoriesMap =
        Map.fromIterable(categories, key: (e) => e.id, value: (e) => e);
    categoriesBox.deleteAll(
        categoriesBox.keys.where((key) => !categoriesMap.keys.contains(key)));
    categoriesBox.putAll(categoriesMap);
    return Future.value(true);
  }

  @override
  CategoryEntity findBy(String name) {
    return categoriesBox.keys
        .map((key) => categoriesBox.get(key))
        .firstWhere((element) => element.name == name);
  }
}
