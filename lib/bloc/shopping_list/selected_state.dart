import 'package:equatable/equatable.dart';

abstract class SelectedState extends Equatable {
  const SelectedState();
}

class InitialSelectedState extends SelectedState {
  final bool selected;

  InitialSelectedState({this.selected = false});

  @override
  List<Object> get props => [selected];

  @override
  bool get stringify => true;
}
