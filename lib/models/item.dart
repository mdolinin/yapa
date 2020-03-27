import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:yapa/repository/item_entity.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String volume;
  final bool selected;

  Item(
    this.name, {
    this.selected = false,
    String volume = '',
    String id,
  })  : this.volume = volume ?? '',
        this.id = id ?? Uuid().v4();

  Item copyWith({bool complete, String id, String volume, String name}) {
    return Item(
      name ?? this.name,
      selected: complete ?? this.selected,
      id: id ?? this.id,
      volume: volume ?? this.volume,
    );
  }

  @override
  List<Object> get props => [selected, id, volume, name];

  @override
  String toString() {
    return 'Item { selected: $selected, name: $name, volume: $volume, id: $id }';
  }

  ItemEntity toEntity() {
    return ItemEntity(name, id, volume, selected);
  }

  static Item fromEntity(ItemEntity entity) {
    return Item(
      entity.name,
      selected: entity.selected ?? false,
      volume: entity.volume,
      id: entity.id ?? Uuid().v4(),
    );
  }
}
