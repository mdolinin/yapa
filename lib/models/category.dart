import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import 'package:yapa/repository/category_entity.dart';

final noCategory = Category('', id: '');

class Category extends Equatable {
  final String id;
  final String name;

  Category(this.name, {String id}) : this.id = id ?? Uuid().v4();

  @override
  List<Object> get props => [id, name];

  @override
  bool get stringify => true;

  Category copyWith({String id, String name}) {
    return Category(name ?? this.name, id: id ?? this.id);
  }

  CategoryEntity toEntity() {
    return CategoryEntity(name, id);
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      entity.name,
      id: entity.id ?? Uuid().v4(),
    );
  }
}
