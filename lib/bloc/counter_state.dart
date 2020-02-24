import 'package:equatable/equatable.dart';

abstract class CounterState extends Equatable {
  final int counter;

  const CounterState(this.counter);

  @override
  List<Object> get props => [counter];
}

class CounterInitial extends CounterState {
  CounterInitial(int counter) : super(counter);
}
