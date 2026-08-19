import 'package:flutter_bloc/flutter_bloc.dart';

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
    required SaveCandidateUseCase saveCandidate,
    required UnsaveCandidateUseCase unsaveCandidate,
  }) : _getCandidate = getCandidate,
       _saveCandidate = saveCandidate,
       _unsaveCandidate = unsaveCandidate,
       super(const CandidateDetailState()) {
    on<CandidateDetailLoadRequested>(_onLoad);
    on<CandidateDetailSaveToggled>(_onSaveToggled);
  }

  final GetCandidateUseCase _getCandidate;
  final SaveCandidateUseCase _saveCandidate;
  final UnsaveCandidateUseCase _unsaveCandidate;

  Future<void> _onLoad(
    CandidateDetailLoadRequested event,
    Emitter<CandidateDetailState> emit,
  ) async {
    emit(
      state.copyWith(status: CandidateDetailStatus.loading, clearError: true),
    );
    final result = await _getCandidate(event.id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CandidateDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (candidate) => emit(
        state.copyWith(
          status: CandidateDetailStatus.success,
          candidate: candidate,
          clearError: true,
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

  // Candidate is immutable; this keeps the entity constructor in one place.
  Candidate _copyWithSaved(Candidate candidate, bool isSaved) => Candidate(
    id: candidate.id,
    firstName: candidate.firstName,
    lastName: candidate.lastName,
    middleName: candidate.middleName,
    age: candidate.age,
    isSaved: isSaved,
    birthYear: candidate.birthYear,
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
    healthStatusId: candidate.healthStatusId,
    healthStatusName: candidate.healthStatusName,
    martialStatusId: candidate.martialStatusId,
    martialStatusName: candidate.martialStatusName,
    photosInfo: candidate.photosInfo,
    compatibilityScore: candidate.compatibilityScore,
  );
}
