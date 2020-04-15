import 'dart:async';

import 'package:hive/hive.dart';
import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/repository/items_repository.dart';

class HiveItemsRepository implements ItemsRepository {
  final Box<ItemEntity> itemsBox;

  const HiveItemsRepository(this.itemsBox);

  @override
  Future<List<ItemEntity>> loadItems() async {
    return itemsBox.keys.map((key) => itemsBox.get(key)).toList();
  }

  @override
  Future<bool> saveItems(List<ItemEntity> items) async {
    items.forEach((item) => itemsBox.put(item.id, item));
    return Future.value(true);
  }
}
