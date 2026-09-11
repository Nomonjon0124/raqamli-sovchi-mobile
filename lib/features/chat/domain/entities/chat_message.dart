import 'package:equatable/equatable.dart';

final class ChatMessageQuote extends Equatable {
  const ChatMessageQuote({
    required this.id,
    required this.senderId,
    required this.content,
    this.attachmentUrl,
    this.createdAt,
  });

  final String id;
  final String senderId;
  final String content;
  final String? attachmentUrl;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, senderId, content, attachmentUrl, createdAt];
}

final class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.attachmentUrl,
    this.replyTo,
  });

  final String id;
  final String chatRoomId;
  final String senderId;
  final String content;
  final String? attachmentUrl;
  final ChatMessageQuote? replyTo;
  final bool isRead;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    chatRoomId,
    senderId,
    content,
    attachmentUrl,
    replyTo,
    isRead,
    createdAt,
  ];
}
