import 'package:equatable/equatable.dart';

final class ChatRoom extends Equatable {
  const ChatRoom({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.matchRequestId,
    this.participantUserId,
    this.participantName,
    this.participantAvatarUrl,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? matchRequestId;
  final String? participantUserId;
  final String? participantName;
  final String? participantAvatarUrl;

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    matchRequestId,
    participantUserId,
    participantName,
    participantAvatarUrl,
  ];
}
