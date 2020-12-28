import 'dart:async';

import 'package:yapa/models/quantity_type.dart';
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
                QuantityType.oz,
                false,
                'images/1.jpeg',
                ['Aldi', 'Wallmart', 'Bravo'],
                'Bread and Cookies',
                0.1,
                1,
                [],
              ),
              ItemEntity(
                'Cookies Choc. Chips',
                '2',
                QuantityType.roll,
                false,
                'images/2.jpeg',
                ['Wallmart', 'Bravo'],
                'Bread and Cookies',
                0.1,
                1,
                [],
              ),
              ItemEntity(
                'Crackers',
                '3',
                QuantityType.box,
                true,
                'images/3.jpeg',
                ['Aldi', 'Bravo'],
                'Bread and Cookies',
                0.1,
                1,
                [],
              ),
              ItemEntity(
                'Pretzels',
                '4',
                QuantityType.pack,
                false,
                'images/4.jpeg',
                ['Dollar Tree', 'Bravo'],
                'Bread and Cookies',
                0.1,
                1,
                [],
              ),
              ItemEntity(
                'Italian Loaf',
                '5',
                QuantityType.each,
                true,
                'images/5.jpeg',
                ['Aldi', 'Wallmart', 'Dollar Tree'],
                'Bread and Cookies',
                0.1,
                1,
                [],
              ),
            ]);
  }

  @override
  Future<bool> saveItems(List<ItemEntity> items) async {
    return Future.value(true);
  }
}
