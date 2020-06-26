import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:yapa/bloc/shopping_list/selected.dart';

void main() {
  group('SelectedBloc', () {
    blocTest<SelectedBloc, SelectedEvent, SelectedState>(
      'should update selection in response to SelectionUpdated Event',
      build: () => SelectedBloc(),
      act: (SelectedBloc bloc) async => bloc..add(SelectionUpdated(true)),
      expect: <SelectedState>[
        InitialSelectedState(),
        InitialSelectedState(selected: true),
      ],
    );
  });
}
