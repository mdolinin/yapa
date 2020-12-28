import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'quantity_type.g.dart';

@HiveType(typeId: 2)
enum QuantityType {
  @HiveField(0)
  not_applicable,
  @HiveField(1)
  oz,
  @HiveField(2)
  lbs,
  @HiveField(3)
  pieces,
  @HiveField(4)
  each,
  @HiveField(5)
  gallon,
  @HiveField(6)
  dozen,
  @HiveField(7)
  bag,
  @HiveField(8)
  can,
  @HiveField(9)
  bottle,
  @HiveField(10)
  box,
  @HiveField(11)
  pack,
  @HiveField(12)
  roll,
  @HiveField(13)
  jar,
  @HiveField(14)
  bunch,
  @HiveField(15)
  gram,
  @HiveField(16)
  kg,
  @HiveField(17)
  l,
  @HiveField(18)
  ml,
  @HiveField(19)
  qt,
}

extension QuantityTypeExt on QuantityType {
  String get toStr => describeEnum(this).replaceAll('_', ' ');
}
