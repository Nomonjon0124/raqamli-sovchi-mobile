import 'package:equatable/equatable.dart';

sealed class CandidateDetailEvent extends Equatable {
  const CandidateDetailEvent();

  @override
  List<Object?> get props => [];
}

final class CandidateDetailLoadRequested extends CandidateDetailEvent {
  const CandidateDetailLoadRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class CandidateDetailSaveToggled extends CandidateDetailEvent {
  const CandidateDetailSaveToggled();
}

final class CandidateDetailRequestSubmitted extends CandidateDetailEvent {
  const CandidateDetailRequestSubmitted({this.note});

  final String? note;

  @override
  List<Object?> get props => [note];
}
