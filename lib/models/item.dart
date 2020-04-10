import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:yapa/repository/item_entity.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String volume;
  final bool selected;
  final String pathToImage;

  Item(
    this.name, {
    this.selected = false,
    String volume = '',
    String pathToImage = '',
    String id,
  })  : this.volume = volume ?? '',
        this.pathToImage = pathToImage ?? '',
        this.id = id ?? Uuid().v4();

  Item copyWith(
      {bool selected,
      String id,
      String volume,
      String name,
      String pathToImage}) {
    return Item(
      name ?? this.name,
      selected: selected ?? this.selected,
      id: id ?? this.id,
      volume: volume ?? this.volume,
      pathToImage: pathToImage ?? this.pathToImage,
    );
  }

  @override
  List<Object> get props => [selected, id, volume, name, pathToImage];

  @override
  String toString() {
    return 'Item { selected: $selected, name: $name, volume: $volume,  pathToImage: $pathToImage, id: $id }';
  }

  ItemEntity toEntity() {
    return ItemEntity(name, id, volume, selected, pathToImage);
  }

  static Item fromEntity(ItemEntity entity) {
    return Item(
      entity.name,
      selected: entity.selected ?? false,
      volume: entity.volume,
      id: entity.id ?? Uuid().v4(),
      pathToImage: entity.pathToImage,
    );
  }
}
