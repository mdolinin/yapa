import 'dart:async';

import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/repository/items_repository.dart';

class MockItemsRepository implements ItemsRepository {
  final Duration delay;

  const MockItemsRepository([this.delay = const Duration(milliseconds: 3000)]);

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
              ),
              ItemEntity(
                'Cookies Choc. Chips',
                '2',
                '13 oz',
                false,
              ),
              ItemEntity(
                'Crackers',
                '3',
                '13 oz',
                true,
              ),
              ItemEntity(
                'Pretzels',
                '4',
                '16 oz',
                false,
              ),
              ItemEntity(
                'Italian Loaf',
                '5',
                '14 oz',
                true,
              ),
            ]);
  }

  @override
  Future<bool> saveItems(List<ItemEntity> items) async {
    return Future.value(true);
  }
}
