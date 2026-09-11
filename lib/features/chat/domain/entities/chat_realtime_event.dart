import 'package:equatable/equatable.dart';

import 'chat_message.dart';

enum ChatRealtimeEventType { message, typing, error, pong }

final class ChatRealtimeEvent extends Equatable {
  const ChatRealtimeEvent._({
    required this.type,
    this.message,
    this.senderId,
    this.detail,
  });

  const ChatRealtimeEvent.message(ChatMessage message)
    : this._(type: ChatRealtimeEventType.message, message: message);

  const ChatRealtimeEvent.typing(String senderId)
    : this._(type: ChatRealtimeEventType.typing, senderId: senderId);

  const ChatRealtimeEvent.error(String detail)
    : this._(type: ChatRealtimeEventType.error, detail: detail);

  const ChatRealtimeEvent.pong() : this._(type: ChatRealtimeEventType.pong);

  final ChatRealtimeEventType type;
  final ChatMessage? message;
  final String? senderId;
  final String? detail;

  @override
  List<Object?> get props => [type, message, senderId, detail];
}
