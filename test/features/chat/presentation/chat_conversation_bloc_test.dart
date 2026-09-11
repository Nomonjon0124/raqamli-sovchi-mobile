import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/notifications/notification_event_bus.dart';
import 'package:raqamli_sovchi/features/chat/application/use_cases/chat_use_cases.dart';
import 'package:raqamli_sovchi/features/chat/domain/entities/chat_message.dart';
import 'package:raqamli_sovchi/features/chat/domain/entities/chat_presence.dart';
import 'package:raqamli_sovchi/features/chat/domain/entities/chat_realtime_event.dart';
import 'package:raqamli_sovchi/features/chat/domain/entities/chat_room.dart';
import 'package:raqamli_sovchi/features/chat/domain/repositories/chat_repository.dart';
import 'package:raqamli_sovchi/features/chat/presentation/bloc/chat_conversation_bloc.dart';
import 'package:raqamli_sovchi/features/chat/presentation/bloc/chat_conversation_event.dart';
import 'package:raqamli_sovchi/features/chat/presentation/bloc/chat_conversation_state.dart';

void main() {
  test('sends a reply and ignores the duplicate WebSocket broadcast', () async {
    final repository = _ChatRepository();
    final eventBus = NotificationEventBus();
    final bloc = ChatConversationBloc(
      loadMessages: LoadChatMessagesUseCase(repository),
      sendMessage: SendChatMessageUseCase(repository),
      markRoomRead: MarkChatRoomReadUseCase(repository),
      loadPresence: LoadChatRoomPresenceUseCase(repository),
      connectChatRoom: ConnectChatRoomUseCase(repository),
      disconnectChatRoom: DisconnectChatRoomUseCase(repository),
      sendTyping: SendChatTypingUseCase(repository),
      repository: repository,
      eventBus: eventBus,
    );
    final loaded = bloc.stream.firstWhere(
      (state) => state.status == ChatConversationStatus.success,
    );

    bloc.add(const ChatConversationOpened('room-1', currentUserId: 'me'));
    await loaded;
    bloc.add(ChatReplySelected(repository.initialMessage));
    bloc.add(const ChatMessageSubmitted('Javob'));
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.messages, hasLength(2));
    expect(bloc.state.messages.last.replyTo?.id, 'message-1');
    repository.addRealtime(repository.sentMessage!);
    await Future<void>.delayed(Duration.zero);
    expect(bloc.state.messages, hasLength(2));

    await bloc.close();
    await eventBus.dispose();
    await repository.dispose();
  });
}

final class _ChatRepository implements ChatRepository {
  final _events = StreamController<ChatRealtimeEvent>.broadcast();
  final initialMessage = ChatMessage(
    id: 'message-1',
    chatRoomId: 'room-1',
    senderId: 'other',
    content: 'Salom',
    isRead: true,
    createdAt: DateTime.utc(2026, 9, 10),
  );
  ChatMessage? sentMessage;

  @override
  Stream<ChatRealtimeEvent> get realtimeEvents => _events.stream;

  @override
  Future<Either<Failure, void>> connect(String chatRoomId) async =>
      const Right(null);

  @override
  Future<void> disconnect() async {}

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(
    String chatRoomId,
  ) async => Right([initialMessage]);

  @override
  Future<Either<Failure, ChatPresence>> getRoomPresence(
    String chatRoomId,
  ) async => const Right(
    ChatPresence(userId: 'other', status: ChatPresenceStatus.online),
  );

  @override
  Future<Either<Failure, List<ChatRoom>>> getChatRooms() async =>
      const Right([]);

  @override
  Future<Either<Failure, Map<String, ChatPresence>>> getRoomsPresence() async =>
      const Right({});

  @override
  Future<Either<Failure, void>> markRoomRead(String chatRoomId) async =>
      const Right(null);

  @override
  void sendTyping() {}

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String chatRoomId,
    required String content,
    String? replyToId,
  }) async {
    sentMessage = ChatMessage(
      id: 'message-2',
      chatRoomId: chatRoomId,
      senderId: 'me',
      content: content,
      isRead: false,
      createdAt: DateTime.utc(2026, 9, 10, 1),
      replyTo: ChatMessageQuote(
        id: replyToId ?? '',
        senderId: 'other',
        content: 'Salom',
      ),
    );
    return Right(sentMessage!);
  }

  void addRealtime(ChatMessage message) =>
      _events.add(ChatRealtimeEvent.message(message));

  Future<void> dispose() => _events.close();
}
