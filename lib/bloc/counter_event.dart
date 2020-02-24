import 'package:equatable/equatable.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class CounterIncremented extends CounterEvent {}

class CounterDecremented extends CounterEvent {}
