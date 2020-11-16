import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/item.dart';
import 'package:yapa/repository/item_entity.dart';
import 'package:yapa/repository/items_repository.dart';

import 'items.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemsRepository itemsRepository;

  ItemsBloc({@required this.itemsRepository});

  @override
  ItemsState get initialState => ItemsLoading();

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is LoadItems) {
      yield* _mapLoadItemsToState();
    } else if (event is AddItem) {
      yield* _mapAddItemToState(event);
    } else if (event is UpdateItem) {
      yield* _mapUpdateItemToState(event);
    } else if (event is DeleteItem) {
      yield* _mapDeleteItemToState(event);
    }
  }

  Stream<ItemsState> _mapLoadItemsToState() async* {
    try {
      final items = await this.itemsRepository.loadItems();
      yield ItemsLoaded(
        items
            .map((item) =>
                Item.fromEntity(item, similarItemsFromEntity(item, items)))
            .toList(),
      );
    } catch (_) {
      yield ItemsNotLoaded();
    }
  }

  List<Item> similarItemsFromEntity(ItemEntity item, List<ItemEntity> all) {
    final similarItemIds = item.similarItemIds ?? [];
    List<Item> similarItems = [];
    similarItemIds.forEach((si) {
      final similarItem =
          all.firstWhere((element) => element.id == si, orElse: () => null);
      if (similarItem != null) {
        similarItems.add(Item.fromEntity(similarItem, []));
      }
    });
    return similarItems;
  }

  Stream<ItemsState> _mapAddItemToState(AddItem event) async* {
    if (state is ItemsLoaded) {
      Item addedItem = event.item;
      List<Item> similarItemsWithRelations = buildSimilarItemsFrom(addedItem);
      final List<Item> updatedItems = List.from((state as ItemsLoaded).items)
        ..add(addedItem.copyWith(similarItems: similarItemsWithRelations))
        ..addAll(similarItemsWithRelations);
      yield ItemsLoaded(updatedItems);
      _saveItems(updatedItems);
    }
  }

  List<Item> buildSimilarItemsFrom(Item item) {
    List<Item> similarItemsOriginalPlusParent = List.from(item.similarItems)
      ..add(item.copyWith(similarItems: []));
    List<Item> similarItemsWithLinks = item.similarItems
        .map((sio) => item.copyWith(
            id: sio.id,
            tags: sio.tags,
            quantityInBaseUnits: sio.quantityInBaseUnits,
            priceOfBaseUnit: sio.priceOfBaseUnit,
            similarItems: List.from(similarItemsOriginalPlusParent)
              ..remove(sio)))
        .toList();
    return similarItemsWithLinks;
  }

  Stream<ItemsState> _mapUpdateItemToState(UpdateItem event) async* {
    if (state is ItemsLoaded) {
      Map<String, Item> items = Map.fromIterable((state as ItemsLoaded).items,
          key: (e) => e.id, value: (e) => e);
      Item updatedItem = event.updatedItem;
      List<Item> similarItemsWithRelations = buildSimilarItemsFrom(updatedItem);
      items.update(
          updatedItem.id,
          (value) =>
              updatedItem.copyWith(similarItems: similarItemsWithRelations));
      similarItemsWithRelations.forEach((si) {
        items.update(si.id, (value) => si, ifAbsent: () => si);
      });
      yield ItemsLoaded(items.values.toList());
      _saveItems(items.values.toList());
    }
  }

  Stream<ItemsState> _mapDeleteItemToState(DeleteItem event) async* {
    if (state is ItemsLoaded) {
      final List<Item> updatedItems = (state as ItemsLoaded)
          .items
          .map((item) =>
              item..similarItems.removeWhere((s) => s.id == event.item.id))
          .where((item) => item.id != event.item.id)
          .toList();
      yield ItemsLoaded(updatedItems);
      _saveItems(updatedItems);
    }
  }

  Future _saveItems(List<Item> items) {
    return itemsRepository.saveItems(
      items
          .map((item) =>
              item.toEntity(item.similarItems.map((e) => e.id).toList()))
          .toList(),
    );
  }
}
