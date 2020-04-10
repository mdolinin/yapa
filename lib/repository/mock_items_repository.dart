import 'dart:async';

import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/repository/items_repository.dart';

class MockItemsRepository implements ItemsRepository {
  final Duration delay;

  const MockItemsRepository([this.delay = const Duration(milliseconds: 1500)]);

  @override
  Future<List<ItemEntity>> loadItems() async {
    return Future.delayed(
        delay,
        () => [
              ItemEntity(
                '100% Wheat Bread',
                '1',
                '20 oz',
                false,
                'images/1.jpeg',
              ),
              ItemEntity(
                'Cookies Choc. Chips',
                '2',
                '13 oz',
                false,
                'images/2.jpeg',
              ),
              ItemEntity(
                'Crackers',
                '3',
                '13 oz',
                true,
                'images/3.jpeg',
              ),
              ItemEntity(
                'Pretzels',
                '4',
                '16 oz',
                false,
                'images/4.jpeg',
              ),
              ItemEntity(
                'Italian Loaf',
                '5',
                '14 oz',
                true,
                'images/5.jpeg',
              ),
            ]);
  }

  @override
  Future<bool> saveItems(List<ItemEntity> items) async {
    return Future.value(true);
  }
}
