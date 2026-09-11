import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_room.dart';

final class ChatRoomModel extends Equatable {
  const ChatRoomModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.matchRequestId,
    this.participantUserId,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final matchRequest = _asMap(json['match_request_info']);
    final participant = _asMap(
      json['participant'] ?? json['other_participant'],
    );
    return ChatRoomModel(
      id: _asString(json['id']) ?? '',
      createdAt: _asDateTime(json['created_at']),
      updatedAt: _asDateTime(json['updated_at']),
      matchRequestId: _asString(json['match_request'] ?? matchRequest['id']),
      participantUserId: _asString(
        json['participant_user'] ??
            json['other_user'] ??
            participant['user'] ??
            participant['id'],
      ),
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? matchRequestId;
  final String? participantUserId;

  ChatRoom toEntity() => ChatRoom(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    matchRequestId: matchRequestId,
    participantUserId: participantUserId,
  );

  @override
  List<Object?> get props => [
    id,
    createdAt,
    updatedAt,
    matchRequestId,
    participantUserId,
  ];
}

Map<String, dynamic> _asMap(Object? value) => value is Map
    ? value.map((key, item) => MapEntry(key.toString(), item))
    : const {};

String? _asString(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

DateTime _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ??
    DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
