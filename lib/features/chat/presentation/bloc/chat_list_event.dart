import 'package:equatable/equatable.dart';

sealed class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

final class ChatListLoadRequested extends ChatListEvent {
  const ChatListLoadRequested();
}

final class ChatListPresenceReceived extends ChatListEvent {
  const ChatListPresenceReceived({
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
