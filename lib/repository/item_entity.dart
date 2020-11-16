import 'package:hive/hive.dart';

part 'item_entity.g.dart';

@HiveType(typeId: 0)
class ItemEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String volume;
  @HiveField(3)
  final bool selected;
  @HiveField(4)
  final String pathToImage;
  @HiveField(5)
  final List<String> tags;
  @HiveField(6)
  final String category;
  @HiveField(7)
  final double priceOfBaseUnit;
  @HiveField(8)
  final double quantityInBaseUnits;
  @HiveField(9)
  final List<String> similarItemIds;

  ItemEntity(
      this.name,
      this.id,
      this.volume,
      this.selected,
      this.pathToImage,
      this.tags,
      this.category,
      this.priceOfBaseUnit,
      this.quantityInBaseUnits,
      this.similarItemIds);

  @override
  int get hashCode =>
      selected.hashCode ^
      name.hashCode ^
      volume.hashCode ^
      id.hashCode ^
      pathToImage.hashCode ^
      tags.hashCode ^
      category.hashCode ^
      priceOfBaseUnit.hashCode ^
      quantityInBaseUnits.hashCode ^
      similarItemIds.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntity &&
          runtimeType == other.runtimeType &&
          selected == other.selected &&
          name == other.name &&
          volume == other.volume &&
          pathToImage == other.pathToImage &&
          tags == other.tags &&
          category == other.category &&
          priceOfBaseUnit == other.priceOfBaseUnit &&
          quantityInBaseUnits == other.quantityInBaseUnits &&
          similarItemIds == other.similarItemIds &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      'selected': selected,
      'name': name,
      'volume': volume,
      'id': id,
      'pathToImage': pathToImage,
      'tags': tags,
      'category': category,
      'priceOfBaseUnit': priceOfBaseUnit,
      'quantityInBaseUnits': quantityInBaseUnits,
      'similarItemIds': similarItemIds,
    };
  }

  @override
  String toString() {
    return 'ItemEntity {selected: $selected, name: $name, volume: $volume, id: $id, pathToImage: $pathToImage, tags: $tags, category: $category, priceOfBaseUnit: $priceOfBaseUnit, quantityInBaseUnits: $quantityInBaseUnits, similarItemIds: $similarItemIds}';
  }

  static ItemEntity fromJson(Map<String, Object> json) {
    return ItemEntity(
      json['name'] as String,
      json['id'] as String,
      json['volume'] as String,
      json['selected'] as bool,
      json['pathToImage'] as String,
      json['tags'] as List<String>,
      json['category'] as String,
      json['priceOfBaseUnit'] as double,
      json['quantityInBaseUnits'] as double,
      json['similarItemIds'] as List<String>,
    );
  }
}
