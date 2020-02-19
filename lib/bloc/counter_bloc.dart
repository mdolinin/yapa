import 'dart:async';
import 'package:bloc/bloc.dart';
import 'bloc.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  @override
  CounterState get initialState => InitialCounterState(0);

  @override
  Stream<CounterState> mapEventToState(
    CounterEvent event,
  ) async* {
    if (event is DecrementCounterEvent) {
      yield InitialCounterState(state.counter - 1);
    } else if (event is IncrementCounterEvent) {
      yield InitialCounterState(state.counter + 1);
    }
  }
}
