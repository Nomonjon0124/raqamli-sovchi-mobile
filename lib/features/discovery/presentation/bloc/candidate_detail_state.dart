import 'package:equatable/equatable.dart';

import '../../../match/domain/entities/match_request.dart';
import '../../domain/entities/candidate.dart';

enum CandidateDetailStatus { initial, loading, success, failure }

final class CandidateDetailState extends Equatable {
  const CandidateDetailState({
    this.status = CandidateDetailStatus.initial,
    this.candidate,
    this.myProfileId,
    this.matchRequest,
    this.isLoadingMatchRequest = false,
    this.isSendingRequest = false,
    this.isSaving = false,
    this.errorMessage,
    this.matchRequestError,
  });

  final CandidateDetailStatus status;
  final Candidate? candidate;
  final String? myProfileId;
  final MatchRequest? matchRequest;
  final bool isLoadingMatchRequest;
  final bool isSendingRequest;
  final bool isSaving;
  final String? errorMessage;
  final String? matchRequestError;

  CandidateDetailState copyWith({
    CandidateDetailStatus? status,
    Candidate? candidate,
    String? myProfileId,
    MatchRequest? matchRequest,
    bool? isLoadingMatchRequest,
    bool? isSendingRequest,
    bool? isSaving,
    String? errorMessage,
    String? matchRequestError,
    bool clearError = false,
    bool clearMatchRequest = false,
    bool clearMatchRequestError = false,
  }) => CandidateDetailState(
    status: status ?? this.status,
    candidate: candidate ?? this.candidate,
    myProfileId: myProfileId ?? this.myProfileId,
    matchRequest: clearMatchRequest
        ? null
        : (matchRequest ?? this.matchRequest),
    isLoadingMatchRequest: isLoadingMatchRequest ?? this.isLoadingMatchRequest,
    isSendingRequest: isSendingRequest ?? this.isSendingRequest,
    isSaving: isSaving ?? this.isSaving,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    matchRequestError: clearMatchRequestError
        ? null
        : (matchRequestError ?? this.matchRequestError),
  );

  @override
  List<Object?> get props => [
    status,
    candidate,
    myProfileId,
    matchRequest,
    isLoadingMatchRequest,
    isSendingRequest,
    isSaving,
    errorMessage,
    matchRequestError,
  ];
}
