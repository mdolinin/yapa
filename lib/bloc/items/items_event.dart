import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemsEvent extends Equatable {
  const ItemsEvent();

  @override
  List<Object> get props => [];
}

class LoadItems extends ItemsEvent {}
