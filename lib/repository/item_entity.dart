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

  ItemEntity(this.name, this.id, this.volume, this.selected, this.pathToImage,
      this.tags);

  @override
  int get hashCode =>
      selected.hashCode ^
      name.hashCode ^
      volume.hashCode ^
      id.hashCode ^
      pathToImage.hashCode ^
      tags.hashCode;

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
          id == other.id;

  Map<String, Object> toJson() {
    return {
      'selected': selected,
      'name': name,
      'volume': volume,
      'id': id,
      'pathToImage': pathToImage,
      'tags': tags,
    };
  }

  @override
  String toString() {
    return 'ItemEntity {selected: $selected, name: $name, volume: $volume, id: $id, pathToImage: $pathToImage, tags: $tags}';
  }

  static ItemEntity fromJson(Map<String, Object> json) {
    return ItemEntity(
      json['name'] as String,
      json['id'] as String,
      json['volume'] as String,
      json['selected'] as bool,
      json['pathToImage'] as String,
      json['tags'] as List<String>,
    );
  }
}
