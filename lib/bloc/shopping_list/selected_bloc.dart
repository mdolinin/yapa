import 'dart:async';

import 'package:bloc/bloc.dart';

import './selected.dart';

class SelectedBloc extends Bloc<SelectedEvent, SelectedState> {
  @override
  SelectedState get initialState => InitialSelectedState();

  @override
  Stream<SelectedState> mapEventToState(SelectedEvent event) async* {
    if (event is SelectionUpdated) {
      yield InitialSelectedState(selected: event.selected);
    }
  }
}
