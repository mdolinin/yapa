import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yapa/models/item.dart';
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
        items.map(Item.fromEntity).toList(),
      );
    } catch (_) {
      yield ItemsNotLoaded();
    }
  }

  Stream<ItemsState> _mapAddItemToState(AddItem event) async* {
    if (state is ItemsLoaded) {
      final List<Item> updatedItems = List.from((state as ItemsLoaded).items)
        ..add(event.item);
      yield ItemsLoaded(updatedItems);
      _saveItems(updatedItems);
    }
  }

  Stream<ItemsState> _mapUpdateItemToState(UpdateItem event) async* {
    if (state is ItemsLoaded) {
      final List<Item> updatedItems = (state as ItemsLoaded).items.map((item) {
        return item.id == event.updatedItem.id ? event.updatedItem : item;
      }).toList();
      yield ItemsLoaded(updatedItems);
      _saveItems(updatedItems);
    }
  }

  Stream<ItemsState> _mapDeleteItemToState(DeleteItem event) async* {
    if (state is ItemsLoaded) {
      final List<Item> updatedItems = (state as ItemsLoaded)
          .items
          .where((item) => item.id != event.item.id)
          .toList();
      yield ItemsLoaded(updatedItems);
      _saveItems(updatedItems);
    }
  }

  Future _saveItems(List<Item> items) {
    return itemsRepository.saveItems(
      items.map((item) => item.toEntity()).toList(),
    );
  }
}
