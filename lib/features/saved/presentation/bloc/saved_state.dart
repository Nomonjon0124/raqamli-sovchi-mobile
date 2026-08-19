import 'package:equatable/equatable.dart';

import '../../../discovery/domain/entities/candidate.dart';

enum SavedStatus { initial, loading, success, empty, failure }

final class SavedState extends Equatable {
  const SavedState({
    this.status = SavedStatus.initial,
    this.candidates = const [],
    this.errorMessage,
  });

  final SavedStatus status;
  final List<Candidate> candidates;
  final String? errorMessage;

  SavedState copyWith({
    SavedStatus? status,
    List<Candidate>? candidates,
    String? errorMessage,
  }) => SavedState(
    status: status ?? this.status,
    candidates: candidates ?? this.candidates,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, candidates, errorMessage];
}
