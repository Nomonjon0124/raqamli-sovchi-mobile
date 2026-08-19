import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/get_candidates.dart';
import '../../application/use_cases/get_my_profile.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

final class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  DiscoveryBloc({
    required GetCandidatesUseCase getCandidates,
    required GetMyProfileUseCase getMyProfile,
  })  : _getCandidates = getCandidates,
        _getMyProfile = getMyProfile,
        super(const DiscoveryState()) {
    on<DiscoveryFetchCandidatesRequested>(_onFetchCandidates);
    on<DiscoveryRefreshCandidatesRequested>(_onRefreshCandidates);
    on<DiscoveryProfileLoaded>(_onProfileLoaded);
  }

  final GetCandidatesUseCase _getCandidates;
  final GetMyProfileUseCase _getMyProfile;
  int _requestSerial = 0;

  Future<void> _onFetchCandidates(
    DiscoveryFetchCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final targetFilter = event.filter;
    if (targetFilter == state.selectedFilter &&
        (state.status == DiscoveryStatus.loading ||
            (state.status == DiscoveryStatus.success &&
                state.candidates.isNotEmpty))) {
      return;
    }

    final requestId = ++_requestSerial;

    // Parallel: fetch profile once if not yet loaded.
    if (state.myProfile == null) {
      unawaited(
        _getMyProfile().then(
          (result) => result.fold(
            (_) {},
            (profile) => add(DiscoveryProfileLoaded(profile)),
          ),
        ),
      );
    }

    emit(
      state.copyWith(
        status: DiscoveryStatus.loading,
        selectedFilter: targetFilter,
        clearError: true,
      ),
    );

    final result = await _getCandidates(filter: targetFilter);
    if (requestId != _requestSerial) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message ?? 'Unknown Error',
          selectedFilter: targetFilter,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty
              ? DiscoveryStatus.empty
              : DiscoveryStatus.success,
          candidates: candidates,
          selectedFilter: targetFilter,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onRefreshCandidates(
    DiscoveryRefreshCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final targetFilter = state.selectedFilter;
    final requestId = ++_requestSerial;

    emit(
      state.copyWith(
        status: DiscoveryStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getCandidates(filter: targetFilter);
    if (requestId != _requestSerial) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message ?? 'Unknown Error',
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty
              ? DiscoveryStatus.empty
              : DiscoveryStatus.success,
          candidates: candidates,
          clearError: true,
        ),
      ),
    );
  }

  void _onProfileLoaded(
    DiscoveryProfileLoaded event,
    Emitter<DiscoveryState> emit,
  ) {
    emit(state.copyWith(myProfile: event.profile));
  }
}
