// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemEntityAdapter extends TypeAdapter<ItemEntity> {
  @override
  final typeId = 0;

  @override
  ItemEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemEntity(
      fields[1] as String,
      fields[0] as String,
      fields[2] as String,
      fields[3] as bool,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ItemEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.volume)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.pathToImage);
  }
}
