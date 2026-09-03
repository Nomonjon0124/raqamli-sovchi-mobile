import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../match/application/use_cases/create_match_request.dart';
import '../../../match/application/use_cases/get_match_request_for_candidate.dart';
import '../../../profile/application/use_cases/get_my_profile.dart';
import '../../application/use_cases/get_candidate.dart';
import '../../application/use_cases/save_candidate.dart';
import '../../application/use_cases/unsave_candidate.dart';
import '../../domain/entities/candidate.dart';
import 'candidate_detail_event.dart';
import 'candidate_detail_state.dart';

final class CandidateDetailBloc
    extends Bloc<CandidateDetailEvent, CandidateDetailState> {
  CandidateDetailBloc({
    required GetCandidateUseCase getCandidate,
    required GetMyProfileUseCase getMyProfile,
    required GetMatchRequestForCandidateUseCase getMatchRequest,
    required CreateMatchRequestUseCase createMatchRequest,
    required SaveCandidateUseCase saveCandidate,
    required UnsaveCandidateUseCase unsaveCandidate,
  }) : _getCandidate = getCandidate,
       _getMyProfile = getMyProfile,
       _getMatchRequest = getMatchRequest,
       _createMatchRequest = createMatchRequest,
       _saveCandidate = saveCandidate,
       _unsaveCandidate = unsaveCandidate,
       super(const CandidateDetailState()) {
    on<CandidateDetailLoadRequested>(_onLoad);
    on<CandidateDetailSaveToggled>(_onSaveToggled);
    on<CandidateDetailRequestSubmitted>(_onRequestSubmitted);
  }

  final GetCandidateUseCase _getCandidate;
  final GetMyProfileUseCase _getMyProfile;
  final GetMatchRequestForCandidateUseCase _getMatchRequest;
  final CreateMatchRequestUseCase _createMatchRequest;
  final SaveCandidateUseCase _saveCandidate;
  final UnsaveCandidateUseCase _unsaveCandidate;

  Future<void> _onLoad(
    CandidateDetailLoadRequested event,
    Emitter<CandidateDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CandidateDetailStatus.loading,
        isLoadingMatchRequest: false,
        clearMatchRequest: true,
        clearMatchRequestError: true,
        clearError: true,
      ),
    );
    final candidateResult = await _getCandidate(event.id);
    Candidate? candidate;
    String? candidateError;
    candidateResult.fold(
      (failure) => candidateError = failure.message,
      (value) => candidate = value,
    );
    if (candidate == null) {
      emit(
        state.copyWith(
          status: CandidateDetailStatus.failure,
          errorMessage: candidateError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CandidateDetailStatus.success,
        candidate: candidate,
        isLoadingMatchRequest: true,
        clearMatchRequestError: true,
        clearError: true,
      ),
    );

    final profileResult = await _getMyProfile();
    String? profileId;
    String? profileError;
    profileResult.fold(
      (failure) => profileError = failure.message,
      (profile) => profileId = profile.id,
    );
    if (profileId == null) {
      emit(
        state.copyWith(
          isLoadingMatchRequest: false,
          matchRequestError: profileError,
        ),
      );
      return;
    }

    emit(state.copyWith(myProfileId: profileId));
    final requestResult = await _getMatchRequest(
      fromProfile: profileId!,
      toProfile: candidate!.id,
    );
    requestResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMatchRequest: false,
          matchRequestError: failure.message,
        ),
      ),
      (request) => emit(
        state.copyWith(
          matchRequest: request,
          isLoadingMatchRequest: false,
          clearMatchRequestError: true,
        ),
      ),
    );
  }

  Future<void> _onRequestSubmitted(
    CandidateDetailRequestSubmitted event,
    Emitter<CandidateDetailState> emit,
  ) async {
    final candidate = state.candidate;
    if (candidate == null || state.isSendingRequest) return;

    var profileId = state.myProfileId;
    if (profileId == null) {
      final profileResult = await _getMyProfile();
      profileResult.fold((_) {}, (profile) => profileId = profile.id);
    }
    if (profileId == null) {
      emit(state.copyWith(matchRequestError: 'profile_unavailable'));
      return;
    }

    emit(state.copyWith(isSendingRequest: true, clearMatchRequestError: true));
    final result = await _createMatchRequest(
      fromProfile: profileId!,
      toProfile: candidate.id,
      note: event.note,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          isSendingRequest: false,
          matchRequestError: failure.message,
        ),
      ),
      (request) => emit(
        state.copyWith(
          isSendingRequest: false,
          matchRequest: request,
          myProfileId: profileId,
          clearMatchRequestError: true,
        ),
      ),
    );
  }

  Future<void> _onSaveToggled(
    CandidateDetailSaveToggled event,
    Emitter<CandidateDetailState> emit,
  ) async {
    final candidate = state.candidate;
    if (candidate == null || state.isSaving) return;

    emit(state.copyWith(isSaving: true, clearError: true));
    final result = candidate.isSaved
        ? await _unsaveCandidate(candidate.id)
        : await _saveCandidate(candidate.id);

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          candidate: _copyWithSaved(candidate, !candidate.isSaved),
          clearError: true,
        ),
      ),
    );
  }

  Candidate _copyWithSaved(Candidate candidate, bool isSaved) => Candidate(
    id: candidate.id,
    firstName: candidate.firstName,
    lastName: candidate.lastName,
    middleName: candidate.middleName,
    age: candidate.age,
    isSaved: isSaved,
    birthYear: candidate.birthYear,
    birthDate: candidate.birthDate,
    height: candidate.height,
    weight: candidate.weight,
    hasChildren: candidate.hasChildren,
    childrenCount: candidate.childrenCount,
    bio: candidate.bio,
    voiceIntro: candidate.voiceIntro,
    latitude: candidate.latitude,
    longitude: candidate.longitude,
    blurPhotos: candidate.blurPhotos,
    phoneNumber: candidate.phoneNumber,
    email: candidate.email,
    isVerified: candidate.isVerified,
    regionId: candidate.regionId,
    regionName: candidate.regionName,
    districtId: candidate.districtId,
    districtName: candidate.districtName,
    educationLevelID: candidate.educationLevelID,
    educationLevelName: candidate.educationLevelName,
    professionId: candidate.professionId,
    professionName: candidate.professionName,
    healthStatusId: candidate.healthStatusId,
    healthStatusName: candidate.healthStatusName,
    martialStatusId: candidate.martialStatusId,
    martialStatusName: candidate.martialStatusName,
    photosInfo: candidate.photosInfo,
    compatibilityScore: candidate.compatibilityScore,
  );
}
