import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
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
}
