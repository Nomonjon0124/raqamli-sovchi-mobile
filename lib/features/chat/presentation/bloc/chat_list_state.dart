import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/entities/chat_thread.dart';

enum ChatListStatus { initial, loading, success, empty, failure }

final class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.threads = const [],
    this.requests = const [],
    this.presences = const {},
    this.failure,
  });

  final ChatListStatus status;
  final List<ChatThread> threads;
  final List<MatchRequest> requests;
  final Map<String, ChatPresence> presences;
  final Failure? failure;

  ChatListState copyWith({
    ChatListStatus? status,
    List<ChatThread>? threads,
    List<MatchRequest>? requests,
    Map<String, ChatPresence>? presences,
    Failure? failure,
    bool clearFailure = false,
  }) => ChatListState(
    status: status ?? this.status,
    threads: threads ?? this.threads,
    requests: requests ?? this.requests,
    presences: presences ?? this.presences,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [status, threads, requests, presences, failure];
}
