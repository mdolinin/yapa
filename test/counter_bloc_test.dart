import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:yapa/bloc/bloc.dart';

void main() {
  group('CounterBloc', () {
    CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    tearDown(() {
      counterBloc.close();
    });

    test('initial state is 0', () {
      expect(counterBloc.initialState, CounterInitial(0));
    });

    blocTest(
      'emits [0, 1] when IncrementCounterEvent is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(CounterIncremented()),
      expect: [CounterInitial(0), CounterInitial(1)],
    );

    blocTest(
      'emits [0, -1] when DecrementCounterEvent is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(CounterDecremented()),
      expect: [CounterInitial(0), CounterInitial(-1)],
    );
  });
}
