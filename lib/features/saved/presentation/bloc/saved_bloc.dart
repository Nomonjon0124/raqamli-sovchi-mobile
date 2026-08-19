import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../discovery/application/use_cases/get_saved_candidates.dart';
import 'saved_event.dart';
import 'saved_state.dart';

final class SavedBloc extends Bloc<SavedEvent, SavedState> {
  SavedBloc({required GetSavedCandidatesUseCase getSavedCandidates})
    : _getSavedCandidates = getSavedCandidates,
      super(const SavedState()) {
    on<SavedLoadRequested>(_onLoad);
  }

  final GetSavedCandidatesUseCase _getSavedCandidates;

  Future<void> _onLoad(
    SavedLoadRequested event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(status: SavedStatus.loading));
    final result = await _getSavedCandidates();
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
}
