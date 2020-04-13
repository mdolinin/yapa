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

  ItemEntity(this.name, this.id, this.volume, this.selected, this.pathToImage);

  @override
  int get hashCode =>
      selected.hashCode ^
      name.hashCode ^
      volume.hashCode ^
      id.hashCode ^
      pathToImage.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntity &&
          runtimeType == other.runtimeType &&
          selected == other.selected &&
          name == other.name &&
          volume == other.volume &&
          pathToImage == other.pathToImage &&
          id == other.id;

  Map<String, Object> toJson() {
    return {
      'selected': selected,
      'name': name,
      'volume': volume,
      'id': id,
      'pathToImage': pathToImage,
    };
  }

  @override
  String toString() {
    return 'ItemEntity {selected: $selected, name: $name, volume: $volume, id: $id, pathToImage: $pathToImage}';
  }

  static ItemEntity fromJson(Map<String, Object> json) {
    return ItemEntity(
      json['name'] as String,
      json['id'] as String,
      json['volume'] as String,
      json['selected'] as bool,
      json['pathToImage'] as String,
    );
  }
}
