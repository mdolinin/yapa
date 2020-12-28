// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemEntityAdapter extends TypeAdapter<ItemEntity> {
  @override
  final int typeId = 0;

  @override
  ItemEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemEntity(
      fields[1] as String,
      fields[0] as String,
      fields[2] as QuantityType,
      fields[3] as bool,
      fields[4] as String,
      (fields[5] as List)?.cast<String>(),
      fields[6] as String,
      fields[7] as double,
      fields[8] as double,
      (fields[9] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ItemEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.qtyType)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.pathToImage)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.priceOfBaseUnit)
      ..writeByte(8)
      ..write(obj.quantityInBaseUnits)
      ..writeByte(9)
      ..write(obj.similarItemIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
