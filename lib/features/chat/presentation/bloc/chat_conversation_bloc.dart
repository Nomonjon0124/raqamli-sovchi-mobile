import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notification_event.dart';
import '../../../../core/notifications/notification_event_bus.dart';
import '../../application/use_cases/chat_use_cases.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_presence.dart';
import '../../domain/entities/chat_realtime_event.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_conversation_event.dart';
import 'chat_conversation_state.dart';

final class ChatConversationBloc
    extends Bloc<ChatConversationEvent, ChatConversationState> {
  ChatConversationBloc({
    required LoadChatMessagesUseCase loadMessages,
    required SendChatMessageUseCase sendMessage,
    required MarkChatRoomReadUseCase markRoomRead,
    required LoadChatRoomPresenceUseCase loadPresence,
    required ConnectChatRoomUseCase connectChatRoom,
    required DisconnectChatRoomUseCase disconnectChatRoom,
    required SendChatTypingUseCase sendTyping,
    required ChatRepository repository,
    required NotificationEventBus eventBus,
  }) : _loadMessages = loadMessages,
       _sendMessage = sendMessage,
       _markRoomRead = markRoomRead,
       _loadPresence = loadPresence,
       _connectChatRoom = connectChatRoom,
       _disconnectChatRoom = disconnectChatRoom,
       _sendTyping = sendTyping,
       super(const ChatConversationState()) {
    on<ChatConversationOpened>(_onOpened);
    on<ChatMessageSubmitted>(_onSubmitted);
    on<ChatReplySelected>(
      (event, emit) => emit(state.copyWith(replyingTo: event.message)),
    );
    on<ChatReplyCleared>(
      (_, emit) => emit(state.copyWith(clearReplyingTo: true)),
    );
    on<ChatTypingStarted>((_, _) => _sendTyping());
    on<ChatTypingExpired>(
      (_, emit) => emit(state.copyWith(isOtherTyping: false)),
    );
    on<ChatRealtimeReceived>(_onRealtimeReceived);
    on<ChatPresenceReceived>(_onPresenceReceived);
    _realtimeSubscription = repository.realtimeEvents.listen(
      (event) => add(ChatRealtimeReceived(event)),
    );
    _presenceSubscription = eventBus.events
        .where((event) => event.isPresence)
        .listen(
          (event) => add(
            ChatPresenceReceived(
              userId: event.presenceUserId!,
              status: event.presenceStatus!,
              lastSeen: event.presenceLastSeen,
            ),
          ),
        );
  }

  final LoadChatMessagesUseCase _loadMessages;
  final SendChatMessageUseCase _sendMessage;
  final MarkChatRoomReadUseCase _markRoomRead;
  final LoadChatRoomPresenceUseCase _loadPresence;
  final ConnectChatRoomUseCase _connectChatRoom;
  final DisconnectChatRoomUseCase _disconnectChatRoom;
  final SendChatTypingUseCase _sendTyping;
  late final StreamSubscription<ChatRealtimeEvent> _realtimeSubscription;
  late final StreamSubscription<NotificationEvent> _presenceSubscription;
  Timer? _typingTimer;
  String? _chatRoomId;
  String? _currentUserId;

  Future<void> _onOpened(
    ChatConversationOpened event,
    Emitter<ChatConversationState> emit,
  ) async {
    _chatRoomId = event.chatRoomId;
    _currentUserId = event.currentUserId;
    emit(
      state.copyWith(
        status: ChatConversationStatus.loading,
        clearFailure: true,
      ),
    );
    final messagesResult = await _loadMessages(event.chatRoomId);
    messagesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: ChatConversationStatus.failure,
          failure: failure,
        ),
      ),
      (messages) {
        emit(
          state.copyWith(
            status: messages.isEmpty
                ? ChatConversationStatus.empty
                : ChatConversationStatus.success,
            messages: _ordered(messages),
          ),
        );
        unawaited(_markRoomRead(event.chatRoomId));
      },
    );
    unawaited(_connectChatRoom(event.chatRoomId));
    final presenceResult = await _loadPresence(event.chatRoomId);
    presenceResult.fold(
      (_) {},
      (presence) => emit(state.copyWith(presence: presence)),
    );
  }

  Future<void> _onSubmitted(
    ChatMessageSubmitted event,
    Emitter<ChatConversationState> emit,
  ) async {
    final chatRoomId = _chatRoomId;
    final content = event.content.trim();
    if (chatRoomId == null || content.isEmpty || state.isSending) return;
    emit(state.copyWith(isSending: true, clearFailure: true));
    final result = await _sendMessage(
      chatRoomId: chatRoomId,
      content: content,
      replyToId: state.replyingTo?.id,
    );
    result.fold(
      (failure) => emit(state.copyWith(isSending: false, failure: failure)),
      (message) => emit(
        state.copyWith(
          status: ChatConversationStatus.success,
          messages: _addMessage(message),
          isSending: false,
          clearReplyingTo: true,
        ),
      ),
    );
  }

  void _onRealtimeReceived(
    ChatRealtimeReceived event,
    Emitter<ChatConversationState> emit,
  ) {
    switch (event.event.type) {
      case ChatRealtimeEventType.message:
        final message = event.event.message;
        if (message == null || message.chatRoomId != _chatRoomId) return;
        emit(
          state.copyWith(
            status: ChatConversationStatus.success,
            messages: _addMessage(message),
          ),
        );
        unawaited(_markRoomRead(message.chatRoomId));
      case ChatRealtimeEventType.typing:
        if (event.event.senderId == _currentUserId) {
          return;
        }
        _typingTimer?.cancel();
        emit(state.copyWith(isOtherTyping: true));
        _typingTimer = Timer(const Duration(seconds: 3), () {
          if (!isClosed) {
            add(const ChatTypingExpired());
          }
        });
      case ChatRealtimeEventType.error:
        emit(state.copyWith(isSending: false));
      case ChatRealtimeEventType.pong:
        if (state.isOtherTyping) {
          emit(state.copyWith(isOtherTyping: false));
        }
    }
  }

  void _onPresenceReceived(
    ChatPresenceReceived event,
    Emitter<ChatConversationState> emit,
  ) {
    final existing = state.presence;
    if (existing == null || existing.userId != event.userId) return;
    emit(
      state.copyWith(
        presence: ChatPresence(
          userId: event.userId,
          status: ChatPresenceStatus.fromApiName(event.status),
          lastSeen: event.lastSeen,
        ),
      ),
    );
  }

  List<ChatMessage> _addMessage(ChatMessage message) {
    final withoutDuplicate = state.messages
        .where((item) => item.id != message.id)
        .toList();
    return _ordered([...withoutDuplicate, message]);
  }

  List<ChatMessage> _ordered(Iterable<ChatMessage> messages) =>
      messages.toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  @override
  Future<void> close() async {
    _typingTimer?.cancel();
    await _realtimeSubscription.cancel();
    await _presenceSubscription.cancel();
    await _disconnectChatRoom();
    return super.close();
  }
}
