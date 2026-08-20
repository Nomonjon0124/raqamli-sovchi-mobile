import 'package:equatable/equatable.dart';

import '../../../discovery/domain/entities/candidate.dart';

enum SavedStatus { initial, loading, success, empty, failure }

enum SavedRequestFilter { all, invited, waiting }

final class SavedState extends Equatable {
  const SavedState({
    this.status = SavedStatus.initial,
    this.candidates = const [],
    this.filter = SavedRequestFilter.all,
    this.errorMessage,
  });

  final SavedStatus status;
  final List<Candidate> candidates;
  final SavedRequestFilter filter;
  final String? errorMessage;

  SavedState copyWith({
    SavedStatus? status,
    List<Candidate>? candidates,
    SavedRequestFilter? filter,
    String? errorMessage,
  }) => SavedState(
    status: status ?? this.status,
    candidates: candidates ?? this.candidates,
    filter: filter ?? this.filter,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [status, candidates, filter, errorMessage];
}
