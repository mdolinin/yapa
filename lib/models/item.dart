import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:yapa/repository/item_entity.dart';

class Item extends Equatable {
  final String id;
  final String name;
  final String volume;
  final bool selected;
  final String pathToImage;
  final List<String> tags;
  final String category;

  Item(
    this.name, {
    this.selected = false,
    String volume = '',
    String pathToImage = '',
    List<String> tags = const [],
    String category = '',
    String id,
  })  : this.volume = volume ?? '',
        this.pathToImage = pathToImage ?? '',
        this.tags = tags ?? [],
        this.category = category ?? '',
        this.id = id ?? Uuid().v4();

  Item copyWith(
      {bool selected,
      String id,
      String volume,
      String name,
      String pathToImage,
      List<String> tags,
      String category}) {
    return Item(
      name ?? this.name,
      selected: selected ?? this.selected,
      id: id ?? this.id,
      volume: volume ?? this.volume,
      pathToImage: pathToImage ?? this.pathToImage,
      tags: tags ?? this.tags,
      category: category ?? this.category,
    );
  }

  @override
  List<Object> get props =>
      [selected, id, volume, name, pathToImage, tags, category];

  @override
  String toString() {
    return 'Item { selected: $selected, name: $name, volume: $volume,  pathToImage: $pathToImage, id: $id, tags: $tags, category: $category }';
  }

  ItemEntity toEntity() {
    return ItemEntity(name, id, volume, selected, pathToImage, tags, category);
  }

  static Item fromEntity(ItemEntity entity) {
    return Item(
      entity.name,
      selected: entity.selected ?? false,
      volume: entity.volume,
      id: entity.id ?? Uuid().v4(),
      pathToImage: entity.pathToImage,
      tags: entity.tags,
      category: entity.category,
    );
  }
}
