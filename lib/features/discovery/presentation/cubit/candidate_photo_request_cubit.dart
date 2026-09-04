import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../match/application/use_cases/create_photo_request.dart';
import 'candidate_photo_request_state.dart';

final class CandidatePhotoRequestCubit
    extends Cubit<CandidatePhotoRequestState> {
  CandidatePhotoRequestCubit({required CreatePhotoRequestUseCase createRequest})
    : _createRequest = createRequest,
      super(const CandidatePhotoRequestState());

  final CreatePhotoRequestUseCase _createRequest;

  Future<void> submit({required String toProfile, String? note}) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    final result = await _createRequest(toProfile: toProfile, note: note);
    result.fold(
      (failure) => emit(
        state.copyWith(isSubmitting: false, errorMessage: failure.message),
      ),
      (request) => emit(
        state.copyWith(isSubmitting: false, request: request, clearError: true),
      ),
    );
  }
}
