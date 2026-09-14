import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../discovery/domain/entities/candidate.dart';
import '../../domain/entities/chat_request_profile.dart';

enum ChatRequestProfileStatus { initial, loading, success, failure }

enum ChatRequestActionStatus { idle, loading, success, failure }

final class ChatRequestProfileState extends Equatable {
  const ChatRequestProfileState({
    this.status = ChatRequestProfileStatus.initial,
    this.actionStatus = ChatRequestActionStatus.idle,
    this.request,
    this.candidate,
    this.actionResult,
    this.failure,
  });

  final ChatRequestProfileStatus status;
  final ChatRequestActionStatus actionStatus;
  final ChatRequestProfile? request;
  final Candidate? candidate;
  final ChatRequestActionResult? actionResult;
  final Failure? failure;

  ChatRequestProfileState copyWith({
    ChatRequestProfileStatus? status,
    ChatRequestActionStatus? actionStatus,
    ChatRequestProfile? request,
    Candidate? candidate,
    ChatRequestActionResult? actionResult,
    Failure? failure,
    bool clearFailure = false,
    bool clearActionResult = false,
  }) => ChatRequestProfileState(
    status: status ?? this.status,
    actionStatus: actionStatus ?? this.actionStatus,
    request: request ?? this.request,
    candidate: candidate ?? this.candidate,
    actionResult: clearActionResult ? null : actionResult ?? this.actionResult,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    request,
    candidate,
    actionResult,
    failure,
  ];
}
