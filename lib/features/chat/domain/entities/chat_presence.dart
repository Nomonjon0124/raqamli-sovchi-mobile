import 'package:equatable/equatable.dart';

enum ChatPresenceStatus {
  online,
  offline;

  static ChatPresenceStatus fromApiName(String? value) => value == 'online'
      ? ChatPresenceStatus.online
      : ChatPresenceStatus.offline;

  String get apiName => name;
}

final class ChatPresence extends Equatable {
  const ChatPresence({
    required this.userId,
    required this.status,
    this.lastSeen,
  });

  final String userId;
  final ChatPresenceStatus status;
  final DateTime? lastSeen;

  bool get isOnline => status == ChatPresenceStatus.online;

  @override
  List<Object?> get props => [userId, status, lastSeen];
}
