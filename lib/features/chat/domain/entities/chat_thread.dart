import 'package:equatable/equatable.dart';

import 'chat_room.dart';

final class ChatThread extends Equatable {
  const ChatThread({
    required this.room,
    this.participantName,
    this.participantProfileId,
  });

  final ChatRoom room;
  final String? participantName;
  final String? participantProfileId;

  @override
  List<Object?> get props => [room, participantName, participantProfileId];
}
