import 'package:yapa/repository/item_entity.dart';

abstract class ItemsRepository {
  Future<List<ItemEntity>> loadItems();

  Future saveItems(List<ItemEntity> items);
}
