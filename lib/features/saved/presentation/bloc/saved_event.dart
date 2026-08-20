import 'package:equatable/equatable.dart';

import 'saved_state.dart';

sealed class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

final class SavedLoadRequested extends SavedEvent {
  const SavedLoadRequested();
}

final class SavedFilterChanged extends SavedEvent {
  const SavedFilterChanged(this.filter);

  final SavedRequestFilter filter;

  @override
  List<Object?> get props => [filter];
}
