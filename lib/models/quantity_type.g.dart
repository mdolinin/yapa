// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quantity_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuantityTypeAdapter extends TypeAdapter<QuantityType> {
  @override
  final int typeId = 2;

  @override
  QuantityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuantityType.not_applicable;
      case 1:
        return QuantityType.oz;
      case 2:
        return QuantityType.lbs;
      case 3:
        return QuantityType.pieces;
      case 4:
        return QuantityType.each;
      case 5:
        return QuantityType.gallon;
      case 6:
        return QuantityType.dozen;
      case 7:
        return QuantityType.bag;
      case 8:
        return QuantityType.can;
      case 9:
        return QuantityType.bottle;
      case 10:
        return QuantityType.box;
      case 11:
        return QuantityType.pack;
      case 12:
        return QuantityType.roll;
      case 13:
        return QuantityType.jar;
      case 14:
        return QuantityType.bunch;
      case 15:
        return QuantityType.gram;
      case 16:
        return QuantityType.kg;
      case 17:
        return QuantityType.l;
      case 18:
        return QuantityType.ml;
      case 19:
        return QuantityType.qt;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, QuantityType obj) {
    switch (obj) {
      case QuantityType.not_applicable:
        writer.writeByte(0);
        break;
      case QuantityType.oz:
        writer.writeByte(1);
        break;
      case QuantityType.lbs:
        writer.writeByte(2);
        break;
      case QuantityType.pieces:
        writer.writeByte(3);
        break;
      case QuantityType.each:
        writer.writeByte(4);
        break;
      case QuantityType.gallon:
        writer.writeByte(5);
        break;
      case QuantityType.dozen:
        writer.writeByte(6);
        break;
      case QuantityType.bag:
        writer.writeByte(7);
        break;
      case QuantityType.can:
        writer.writeByte(8);
        break;
      case QuantityType.bottle:
        writer.writeByte(9);
        break;
      case QuantityType.box:
        writer.writeByte(10);
        break;
      case QuantityType.pack:
        writer.writeByte(11);
        break;
      case QuantityType.roll:
        writer.writeByte(12);
        break;
      case QuantityType.jar:
        writer.writeByte(13);
        break;
      case QuantityType.bunch:
        writer.writeByte(14);
        break;
      case QuantityType.gram:
        writer.writeByte(15);
        break;
      case QuantityType.kg:
        writer.writeByte(16);
        break;
      case QuantityType.l:
        writer.writeByte(17);
        break;
      case QuantityType.ml:
        writer.writeByte(18);
        break;
      case QuantityType.qt:
        writer.writeByte(19);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuantityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
