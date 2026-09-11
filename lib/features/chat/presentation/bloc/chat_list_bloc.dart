import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notification_event.dart';
import '../../../../core/notifications/notification_event_bus.dart';
import '../../../match/application/use_cases/get_match_requests.dart';
import '../../../match/domain/entities/match_request.dart';
import '../../../profile/application/use_cases/get_my_profile.dart';
import '../../../profile/domain/entities/user_profile.dart';
import '../../application/use_cases/chat_use_cases.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/entities/chat_thread.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

final class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  ChatListBloc({
    required LoadChatRoomsUseCase loadChatRooms,
    required LoadChatRoomsPresenceUseCase loadRoomsPresence,
    required GetMyProfileUseCase getMyProfile,
    required GetMatchRequestsUseCase getMatchRequests,
    required NotificationEventBus eventBus,
  }) : _loadChatRooms = loadChatRooms,
       _loadRoomsPresence = loadRoomsPresence,
       _getMyProfile = getMyProfile,
       _getMatchRequests = getMatchRequests,
       super(const ChatListState()) {
    on<ChatListLoadRequested>(_onLoad);
    on<ChatListPresenceReceived>(_onPresence);
    _presenceSubscription = eventBus.events
        .where((event) => event.isPresence)
        .listen(
          (event) => add(
            ChatListPresenceReceived(
              userId: event.presenceUserId!,
              status: event.presenceStatus!,
              lastSeen: event.presenceLastSeen,
            ),
          ),
        );
  }

  final LoadChatRoomsUseCase _loadChatRooms;
  final LoadChatRoomsPresenceUseCase _loadRoomsPresence;
  final GetMyProfileUseCase _getMyProfile;
  final GetMatchRequestsUseCase _getMatchRequests;
  late final StreamSubscription<NotificationEvent> _presenceSubscription;

  Future<void> _onLoad(
    ChatListLoadRequested event,
    Emitter<ChatListState> emit,
  ) async {
    emit(state.copyWith(status: ChatListStatus.loading, clearFailure: true));
    final roomsResult = await _loadChatRooms();
    await roomsResult.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(status: ChatListStatus.failure, failure: failure),
      ),
      (rooms) async {
        final profileResult = await _getMyProfile();
        final requestsResult = await _getMatchRequests();
        final presenceResult = await _loadRoomsPresence();
        final UserProfile? profile = profileResult.fold<UserProfile?>(
          (_) => null,
          (value) => value,
        );
        final List<MatchRequest> requests = requestsResult
            .fold<List<MatchRequest>>((_) => const [], (value) => value);
        final requestsById = {
          for (final request in requests) request.id: request,
        };
        final threads = rooms.map((room) {
          final request = requestsById[room.matchRequestId];
          final isFromProfile = profile == null
              ? null
              : request?.fromProfileId == profile.id;
          return ChatThread(
            room: room,
            participantName: switch (isFromProfile) {
              true => request?.toProfileName,
              false => request?.fromProfileName,
              null => null,
            },
            participantProfileId: switch (isFromProfile) {
              true => request?.toProfileId,
              false => request?.fromProfileId,
              null => null,
            },
          );
        }).toList();
        final Map<String, ChatPresence> presences = presenceResult.fold(
          (_) => state.presences,
          (value) => value,
        );
        emit(
          ChatListState(
            status: threads.isEmpty
                ? ChatListStatus.empty
                : ChatListStatus.success,
            threads: threads,
            presences: presences,
          ),
        );
      },
    );
  }

  void _onPresence(
    ChatListPresenceReceived event,
    Emitter<ChatListState> emit,
  ) {
    emit(
      state.copyWith(
        presences: {
          ...state.presences,
          event.userId: ChatPresence(
            userId: event.userId,
            status: ChatPresenceStatus.fromApiName(event.status),
            lastSeen: event.lastSeen,
          ),
        },
      ),
    );
  }

  @override
  Future<void> close() {
    _presenceSubscription.cancel();
    return super.close();
  }
}
