import 'dart:async';
import 'package:bloc/bloc.dart';
import 'bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  @override
  CounterState get initialState => CounterInitial(0);

  @override
  Stream<CounterState> mapEventToState(
    CounterEvent event,
  ) async* {
    if (event is CounterDecremented) {
      yield CounterInitial(state.counter - 1);
    } else if (event is CounterIncremented) {
      yield CounterInitial(state.counter + 1);
    }
  }
}
