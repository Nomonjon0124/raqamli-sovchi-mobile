import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate.dart';

enum CandidateDetailStatus { initial, loading, success, failure }

final class CandidateDetailState extends Equatable {
  const CandidateDetailState({
    this.status = CandidateDetailStatus.initial,
    this.candidate,
    this.isSaving = false,
    this.errorMessage,
  });

  final CandidateDetailStatus status;
  final Candidate? candidate;
  final bool isSaving;
  final String? errorMessage;

  CandidateDetailState copyWith({
    CandidateDetailStatus? status,
    Candidate? candidate,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
  }) => CandidateDetailState(
    status: status ?? this.status,
    candidate: candidate ?? this.candidate,
    isSaving: isSaving ?? this.isSaving,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [status, candidate, isSaving, errorMessage];
}
