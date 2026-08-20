import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../discovery/application/use_cases/get_my_profile.dart';
import '../../../discovery/application/use_cases/get_saved_candidates.dart';
import '../../../discovery/domain/entities/candidate.dart';
import '../../../match/application/use_cases/get_match_requests.dart';
import '../../../match/domain/entities/match_request.dart';
import 'saved_event.dart';
import 'saved_state.dart';

final class SavedBloc extends Bloc<SavedEvent, SavedState> {
  SavedBloc({
    required GetSavedCandidatesUseCase getSavedCandidates,
    required GetMyProfileUseCase getMyProfile,
    required GetMatchRequestsUseCase getMatchRequests,
  }) : _getSavedCandidates = getSavedCandidates,
       _getMyProfile = getMyProfile,
       _getMatchRequests = getMatchRequests,
       super(const SavedState()) {
    on<SavedLoadRequested>(_onLoad);
    on<SavedFilterChanged>(_onFilterChanged);
  }

  final GetSavedCandidatesUseCase _getSavedCandidates;
  final GetMyProfileUseCase _getMyProfile;
  final GetMatchRequestsUseCase _getMatchRequests;

  Future<void> _onLoad(
    SavedLoadRequested event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(status: SavedStatus.loading, errorMessage: ''));
    final result = await _loadCandidates();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SavedStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty ? SavedStatus.empty : SavedStatus.success,
          candidates: candidates,
          errorMessage: '',
        ),
      ),
    );
  }

  Future<Either<Failure, List<Candidate>>> _loadCandidates() async {
    final savedResult = await _getSavedCandidates();
    if (state.filter == SavedRequestFilter.all) return savedResult;

    return savedResult.fold(Left.new, (candidates) async {
      final profileResult = await _getMyProfile();
      return profileResult.fold(Left.new, (profile) async {
        final requestsResult = await _getMatchRequests(
          fromProfile: profile.id,
          status: _statusFor(state.filter),
        );
        return requestsResult.fold(
          Left.new,
          (requests) => Right(
            candidates
                .where(
                  (candidate) => requests.any(
                    (request) => request.toProfileId == candidate.id,
                  ),
                )
                .toList(),
          ),
        );
      });
    });
  }

  Future<void> _onFilterChanged(
    SavedFilterChanged event,
    Emitter<SavedState> emit,
  ) async {
    if (event.filter == state.filter && state.status != SavedStatus.initial) {
      return;
    }
    emit(state.copyWith(filter: event.filter));
    add(const SavedLoadRequested());
  }

  MatchRequestStatus _statusFor(SavedRequestFilter filter) {
    return switch (filter) {
      SavedRequestFilter.all => MatchRequestStatus.pending,
      SavedRequestFilter.invited => MatchRequestStatus.pending,
      SavedRequestFilter.waiting =>
        MatchRequestStatus.forwardedToRepresentative,
    };
  }
}
