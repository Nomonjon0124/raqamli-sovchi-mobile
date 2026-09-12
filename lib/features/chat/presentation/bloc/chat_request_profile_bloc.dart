import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../discovery/application/use_cases/get_candidate.dart';
import '../../../discovery/domain/entities/candidate.dart';
import '../../../match/application/use_cases/accept_match_request.dart';
import '../../../match/application/use_cases/get_match_request.dart';
import '../../../match/application/use_cases/reject_match_request.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../domain/entities/chat_request_profile.dart';
import 'chat_request_profile_event.dart';
import 'chat_request_profile_state.dart';

final class ChatRequestProfileBloc
    extends Bloc<ChatRequestProfileEvent, ChatRequestProfileState> {
  ChatRequestProfileBloc({
    required GetMatchRequestUseCase getRequest,
    required GetCandidateUseCase getCandidate,
    required AcceptMatchRequestUseCase acceptRequest,
    required RejectMatchRequestUseCase rejectRequest,
  }) : _getRequest = getRequest,
       _getCandidate = getCandidate,
       _acceptRequest = acceptRequest,
       _rejectRequest = rejectRequest,
       super(const ChatRequestProfileState()) {
    on<ChatRequestProfileOpened>(_onOpened);
    on<ChatRequestAccepted>(_onAccepted);
    on<ChatRequestRejected>(_onRejected);
  }

  final GetMatchRequestUseCase _getRequest;
  final GetCandidateUseCase _getCandidate;
  final AcceptMatchRequestUseCase _acceptRequest;
  final RejectMatchRequestUseCase _rejectRequest;

  Future<void> _onOpened(
    ChatRequestProfileOpened event,
    Emitter<ChatRequestProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ChatRequestProfileStatus.loading,
        request: event.request,
        actionStatus: ChatRequestActionStatus.idle,
        clearFailure: true,
        clearActionResult: true,
      ),
    );

    ChatRequestProfile? request = event.request;
    if (request == null) {
      final result = await _getRequest(event.requestId);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ChatRequestProfileStatus.failure,
            failure: failure,
          ),
        ),
        (value) => request = value,
      );
      if (state.status == ChatRequestProfileStatus.failure) return;
      if (request == null) {
        emit(state.copyWith(status: ChatRequestProfileStatus.failure));
        return;
      }
    }

    Candidate? candidate;
    final candidateId = request!.fromProfileId;
    if (candidateId != null && candidateId.trim().isNotEmpty) {
      final candidateResult = await _getCandidate(candidateId);
      candidateResult.fold((_) {}, (value) => candidate = value);
    }
    emit(
      state.copyWith(
        status: ChatRequestProfileStatus.success,
        request: request,
        candidate: candidate,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onAccepted(
    ChatRequestAccepted event,
    Emitter<ChatRequestProfileState> emit,
  ) => _runAction(
    emit,
    action: _acceptRequest.call,
    result: ChatRequestActionResult.accepted,
  );

  Future<void> _onRejected(
    ChatRequestRejected event,
    Emitter<ChatRequestProfileState> emit,
  ) => _runAction(
    emit,
    action: _rejectRequest.call,
    result: ChatRequestActionResult.rejected,
  );

  Future<void> _runAction(
    Emitter<ChatRequestProfileState> emit, {
    required Future<Either<Failure, MatchRequest>> Function(String) action,
    required ChatRequestActionResult result,
  }) async {
    final request = state.request;
    if (request == null ||
        state.actionStatus == ChatRequestActionStatus.loading) {
      return;
    }
    emit(
      state.copyWith(
        actionStatus: ChatRequestActionStatus.loading,
        clearFailure: true,
        clearActionResult: true,
      ),
    );
    final actionResult = await action(request.id);
    actionResult.fold(
      (failure) => emit(
        state.copyWith(
          actionStatus: ChatRequestActionStatus.failure,
          failure: failure,
        ),
      ),
      (updatedRequest) => emit(
        state.copyWith(
          actionStatus: ChatRequestActionStatus.success,
          request: updatedRequest,
          actionResult: result,
          clearFailure: true,
        ),
      ),
    );
  }
}
