import 'dart:async';

import 'package:hive/hive.dart';
import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/repository/items_repository.dart';

const k_items_box_name = 'items';

class HiveItemsRepository implements ItemsRepository {
  final Box<ItemEntity> itemsBox;

  const HiveItemsRepository(this.itemsBox);

  @override
  Future<List<ItemEntity>> loadItems() async {
    return itemsBox.keys.map((key) => itemsBox.get(key)).toList();
  }

  @override
  Future<bool> saveItems(List<ItemEntity> items) async {
    Map<String, ItemEntity> itemsMap =
        Map.fromIterable(items, key: (e) => e.id, value: (e) => e);
    itemsBox
        .deleteAll(itemsBox.keys.where((key) => !itemsMap.keys.contains(key)));
    itemsBox.putAll(itemsMap);
    return Future.value(true);
  }
}
