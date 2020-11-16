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
  final double priceOfBaseUnit;
  final double quantityInBaseUnits;
  final List<Item> similarItems;

  Item(
    this.name, {
    this.selected = false,
    String volume = '',
    String pathToImage = '',
    List<String> tags = const [],
    String category = '',
    String id,
    double priceOfBaseUnit,
    double quantityInBaseUnits,
    List<Item> similarItems = const [],
  })  : this.volume = volume ?? '',
        this.pathToImage = pathToImage ?? '',
        this.tags = tags ?? [],
        this.category = category ?? '',
        this.priceOfBaseUnit = priceOfBaseUnit ?? 0.0,
        this.quantityInBaseUnits = quantityInBaseUnits ?? 0.0,
        this.similarItems = similarItems ?? [],
        this.id = id ?? Uuid().v4();

  Item copyWith(
      {bool selected,
      String id,
      String volume,
      String name,
      String pathToImage,
      List<String> tags,
      double priceOfBaseUnit,
      double quantityInBaseUnits,
      List<Item> similarItems,
      String category}) {
    return Item(
      name ?? this.name,
      selected: selected ?? this.selected,
      id: id ?? this.id,
      volume: volume ?? this.volume,
      pathToImage: pathToImage ?? this.pathToImage,
      tags: tags ?? this.tags,
      priceOfBaseUnit: priceOfBaseUnit ?? this.priceOfBaseUnit,
      quantityInBaseUnits: quantityInBaseUnits ?? this.quantityInBaseUnits,
      similarItems: similarItems ?? this.similarItems,
      category: category ?? this.category,
    );
  }

  @override
  List<Object> get props => [
        selected,
        id,
        volume,
        name,
        pathToImage,
        tags,
        priceOfBaseUnit,
        quantityInBaseUnits,
        similarItems,
        category
      ];

  @override
  String toString() {
    return 'Item { selected: $selected, name: $name, volume: $volume,  pathToImage: $pathToImage, id: $id, tags: $tags, priceOfBaseUnit: $priceOfBaseUnit, quantityInBaseUnits: $quantityInBaseUnits, category: $category , similarItems: $similarItems }';
  }

  ItemEntity toEntity(List<String> similarIds) {
    return ItemEntity(name, id, volume, selected, pathToImage, tags, category,
        priceOfBaseUnit, quantityInBaseUnits, similarIds);
  }

  static Item fromEntity(ItemEntity entity, List<Item> similarItems) {
    return Item(
      entity.name,
      selected: entity.selected ?? false,
      volume: entity.volume,
      id: entity.id ?? Uuid().v4(),
      pathToImage: entity.pathToImage,
      tags: entity.tags,
      category: entity.category,
      priceOfBaseUnit: entity.priceOfBaseUnit,
      quantityInBaseUnits: entity.quantityInBaseUnits,
      similarItems: similarItems,
    );
  }
}
