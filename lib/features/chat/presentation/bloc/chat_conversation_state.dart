import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_presence.dart';

enum ChatConversationStatus { initial, loading, success, empty, failure }

final class ChatConversationState extends Equatable {
  const ChatConversationState({
    this.status = ChatConversationStatus.initial,
    this.messages = const [],
    this.presence,
    this.replyingTo,
    this.failure,
    this.isSending = false,
    this.isOtherTyping = false,
  });

  final ChatConversationStatus status;
  final List<ChatMessage> messages;
  final ChatPresence? presence;
  final ChatMessage? replyingTo;
  final Failure? failure;
  final bool isSending;
  final bool isOtherTyping;

  ChatConversationState copyWith({
    ChatConversationStatus? status,
    List<ChatMessage>? messages,
    ChatPresence? presence,
    ChatMessage? replyingTo,
    Failure? failure,
    bool? isSending,
    bool? isOtherTyping,
    bool clearReplyingTo = false,
    bool clearFailure = false,
  }) => ChatConversationState(
    status: status ?? this.status,
    messages: messages ?? this.messages,
    presence: presence ?? this.presence,
    replyingTo: clearReplyingTo ? null : replyingTo ?? this.replyingTo,
    failure: clearFailure ? null : failure ?? this.failure,
    isSending: isSending ?? this.isSending,
    isOtherTyping: isOtherTyping ?? this.isOtherTyping,
  );

  @override
  List<Object?> get props => [
    status,
    messages,
    presence,
    replyingTo,
    failure,
    isSending,
    isOtherTyping,
  ];
}
