import 'package:yapa/models/category.dart';
import 'package:yapa/repository/category_entity.dart';

final Set<Category> defaultCategories = {
  noCategory,
  Category('Bread and Cookies', id: '1'),
  Category('Vegetables and Herbs', id: '2'),
  Category('Fruits and Berries', id: '3'),
  Category('Nuts, Seeds, Chocolate, Dried Fruits, Snacks', id: '4'),
  Category('Grains, Legumes, Pasta, other Dry Goods', id: '5'),
  Category('Condiments, Oils, Spices, Herbs, Baking', id: '6'),
  Category('Meat, Fish, Poultry', id: '7'),
  Category('Dairy', id: '8'),
  Category('Frozen Food', id: '9'),
  Category('Beverages', id: '10'),
  Category('Canned Food', id: '11'),
  Category('Household, Health, other Misc.', id: '12'),
};

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> loadCategories();

  Future saveCategories(List<CategoryEntity> categories);

  Future<void> loadDefaultCategories() async {
    var categories = await loadCategories();
    defaultCategories
        .where((c) => !categories.any((entity) => entity.id == c.id))
        .forEach((c) => categories.add(c.toEntity()));
    saveCategories(categories);
  }

  CategoryEntity findBy(String name);
}
