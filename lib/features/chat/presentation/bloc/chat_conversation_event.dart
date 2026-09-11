import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_realtime_event.dart';

sealed class ChatConversationEvent extends Equatable {
  const ChatConversationEvent();
  @override
  List<Object?> get props => [];
}

final class ChatConversationOpened extends ChatConversationEvent {
  const ChatConversationOpened(this.chatRoomId, {this.currentUserId});
  final String chatRoomId;
  final String? currentUserId;
  @override
  List<Object?> get props => [chatRoomId, currentUserId];
}

final class ChatMessageSubmitted extends ChatConversationEvent {
  const ChatMessageSubmitted(this.content);
  final String content;
  @override
  List<Object?> get props => [content];
}

final class ChatReplySelected extends ChatConversationEvent {
  const ChatReplySelected(this.message);
  final ChatMessage message;
  @override
  List<Object?> get props => [message];
}

final class ChatReplyCleared extends ChatConversationEvent {
  const ChatReplyCleared();
}

final class ChatTypingStarted extends ChatConversationEvent {
  const ChatTypingStarted();
}

final class ChatTypingExpired extends ChatConversationEvent {
  const ChatTypingExpired();
}

final class ChatRealtimeReceived extends ChatConversationEvent {
  const ChatRealtimeReceived(this.event);
  final ChatRealtimeEvent event;
  @override
  List<Object?> get props => [event];
}

final class ChatPresenceReceived extends ChatConversationEvent {
  const ChatPresenceReceived({
    required this.userId,
    required this.status,
    this.lastSeen,
  });
  final String userId;
  final String status;
  final DateTime? lastSeen;
  @override
  List<Object?> get props => [userId, status, lastSeen];
}
