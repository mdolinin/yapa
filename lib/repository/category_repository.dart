import 'package:yapa/models/category.dart';
import 'package:yapa/repository/category_entity.dart';

const Set<String> category_names = {
  '',
  'Bread and Cookies',
  'Vegetables and Herbs',
  'Fruits and Berries',
  'Nuts, Seeds, Chocolate, Dried Fruits, Snacks',
  'Grains, Legumes, Pasta, other Dry Goods',
  'Condiments, Oils, Spices, Herbs, Baking',
  'Meat, Fish, Poultry',
  'Dairy',
  'Frozen Food',
  'Beverages',
  'Canned Food',
  'Household, Health, other Misc.',
};

abstract class CategoriesRepository {
  Future<List<CategoryEntity>> loadCategories();

  Future saveCategories(List<CategoryEntity> categories);

  Future<void> loadDefaultCategories() async {
    var categories = await loadCategories();
    category_names
        .where((name) => !categories.any((entity) => entity.name == name))
        .forEach((n) => categories.add(Category(n).toEntity()));
    saveCategories(categories);
  }

  CategoryEntity findBy(String name);
}
