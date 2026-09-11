import 'package:equatable/equatable.dart';

final class ChatRoom extends Equatable {
  const ChatRoom({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.matchRequestId,
    this.participantUserId,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? matchRequestId;
  final String? participantUserId;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    matchRequestId,
    participantUserId,
  ];
}
