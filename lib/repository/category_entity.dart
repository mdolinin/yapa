import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category_entity.g.dart';

@HiveType(typeId: 0)
class CategoryEntity extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  CategoryEntity(this.name, this.id);

  @override
  List<Object> get props => [id, name];

  @override
  bool get stringify => true;
}
