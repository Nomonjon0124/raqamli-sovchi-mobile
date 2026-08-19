import 'package:equatable/equatable.dart';

sealed class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

final class SavedLoadRequested extends SavedEvent {
  const SavedLoadRequested();
}
