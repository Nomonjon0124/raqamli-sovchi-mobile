import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_presence.dart';

final class ChatPresenceModel extends Equatable {
  const ChatPresenceModel({
    required this.userId,
    required this.status,
    this.lastSeen,
  });

  factory ChatPresenceModel.fromJson(
    Map<String, dynamic> json, {
    String? userId,
  }) => ChatPresenceModel(
    userId: userId ?? json['user']?.toString() ?? '',
    status: ChatPresenceStatus.fromApiName(json['status']?.toString()),
    lastSeen: DateTime.tryParse(json['last_seen']?.toString() ?? ''),
  );

  final String userId;
  final ChatPresenceStatus status;
  final DateTime? lastSeen;

  ChatPresence toEntity() =>
      ChatPresence(userId: userId, status: status, lastSeen: lastSeen);

  @override
  List<Object?> get props => [userId, status, lastSeen];
}
