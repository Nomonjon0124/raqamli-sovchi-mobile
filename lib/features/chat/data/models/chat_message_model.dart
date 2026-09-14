import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';

final class ChatMessageModel extends Equatable {
  const ChatMessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.attachmentUrl,
    this.replyTo,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final senderInfo = _asMap(json['sender_info']);
    final roomInfo = _asMap(json['chat_room_info']);
    final rawReply = json['reply_to_info'] ?? json['reply_to'];
    return ChatMessageModel(
      id: _asString(json['id']) ?? '',
      chatRoomId: _asString(json['chat_room'] ?? roomInfo['id']) ?? '',
      senderId: _asString(json['sender'] ?? senderInfo['id']) ?? '',
      content: _asString(json['content']) ?? '',
      attachmentUrl: _asString(json['attachment']),
      replyTo: rawReply is Map
          ? ChatMessageQuoteModel.fromJson(_asMap(rawReply))
          : null,
      isRead: json['is_read'] == true,
      createdAt: _asDateTime(json['created_at']),
    );
  }

  final String id;
  final String chatRoomId;
  final String senderId;
  final String content;
  final String? attachmentUrl;
  final ChatMessageQuoteModel? replyTo;
  final bool isRead;
  final DateTime createdAt;

  ChatMessage toEntity() => ChatMessage(
    id: id,
    chatRoomId: chatRoomId,
    senderId: senderId,
    content: content,
    attachmentUrl: attachmentUrl,
    replyTo: replyTo?.toEntity(),
    isRead: isRead,
    createdAt: createdAt,
  );

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

final class ChatMessageQuoteModel extends Equatable {
  const ChatMessageQuoteModel({
    required this.id,
    required this.senderId,
    required this.content,
    this.attachmentUrl,
    this.createdAt,
  });

  factory ChatMessageQuoteModel.fromJson(Map<String, dynamic> json) =>
      ChatMessageQuoteModel(
        id: _asString(json['id']) ?? '',
        senderId: _asString(json['sender']) ?? '',
        content: _asString(json['content']) ?? '',
        attachmentUrl: _asString(json['attachment']),
        createdAt: json['created_at'] == null
            ? null
            : _asDateTime(json['created_at']),
      );

  final String id;
  final String senderId;
  final String content;
  final String? attachmentUrl;
  final DateTime? createdAt;

  ChatMessageQuote toEntity() => ChatMessageQuote(
    id: id,
    senderId: senderId,
    content: content,
    attachmentUrl: attachmentUrl,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id, senderId, content, attachmentUrl, createdAt];
}

Map<String, dynamic> _asMap(Object? value) => value is Map
    ? value.map((key, item) => MapEntry(key.toString(), item))
    : const {};

String? _asString(Object? value) {
  final result = value?.toString();
  return result == null || result.isEmpty ? null : result;
}

DateTime _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ??
    DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
