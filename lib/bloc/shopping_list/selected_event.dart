import 'package:equatable/equatable.dart';

abstract class SelectedEvent extends Equatable {
  const SelectedEvent();
}

class SelectionUpdated extends SelectedEvent {
  final bool selected;

  SelectionUpdated(this.selected);

  @override
  List<Object> get props => [selected];

  @override
  bool get stringify => true;
}
