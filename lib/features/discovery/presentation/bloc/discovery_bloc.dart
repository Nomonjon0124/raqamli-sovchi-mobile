import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/use_cases/get_candidates.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

final class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  DiscoveryBloc({required GetCandidatesUseCase getCandidates})
      : _getCandidates = getCandidates,
        super(const DiscoveryInitial()) {
    on<DiscoveryFetchCandidatesRequested>(_onFetchCandidates);
    on<DiscoveryRefreshCandidatesRequested>(_onRefreshCandidates);
  }

  final GetCandidatesUseCase _getCandidates;

  Future<void> _onFetchCandidates(
    DiscoveryFetchCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    emit(const DiscoveryLoading());
    final result = await _getCandidates(filter: event.filter);

    result.fold(
      (failure) => emit(DiscoveryError(failure.message ?? 'Unknown Error')),
      (candidates) {
        if (candidates.isNotEmpty) {
          debugPrint('bloc candidates count: ${candidates.length}, first candidate: ${candidates.first.firstName}');
        } else {
          debugPrint('bloc candidates result: empty list');
        }
        return emit(
          DiscoveryLoaded(
            candidates: candidates,
            selectedFilter: event.filter,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshCandidates(
    DiscoveryRefreshCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final result = await _getCandidates();
    result.fold(
      (failure) => emit(DiscoveryError(failure.message ?? 'Unknown Error')),
      (candidates) => emit(DiscoveryLoaded(candidates: candidates)),
    );
  }
}
