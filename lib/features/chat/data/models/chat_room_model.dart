import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_room.dart';

final class ChatRoomModel extends Equatable {
  const ChatRoomModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.matchRequestId,
    this.participantUserId,
    this.participantName,
    this.participantAvatarUrl,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    final matchRequest = _asMap(json['match_request_info']);
    final participant = _asMap(
      json['participant'] ?? json['other_participant'] ?? json['partner_info'],
    );
    final profile = _asMap(
      participant['profile'] ?? participant['profile_info'],
    );
    return ChatRoomModel(
      id: _asString(json['id']) ?? '',
      createdAt: _asDateTime(json['created_at']),
      updatedAt: _asDateTime(json['updated_at']),
      matchRequestId: _asString(json['match_request'] ?? matchRequest['id']),
      participantUserId: _asString(
        json['participant_user'] ??
            json['other_user'] ??
            json['partner_user'] ??
            participant['user'] ??
            participant['user_id'] ??
            participant['id'],
      ),
      participantName: _firstNonEmpty([
        _asString(json['partner_info']),
        _displayName(participant),
        _displayName(profile),
      ]),
      participantAvatarUrl: _firstNonEmpty([
        _asString(json['main_photo']),
        _asString(json['avatar']),
        _asString(json['photo']),
        _asString(participant['main_photo']),
        _asString(participant['avatar']),
        _asString(participant['photo']),
        _asString(profile['main_photo']),
        _asString(profile['avatar']),
        _asString(profile['photo']),
      ]),
    );
  }

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? matchRequestId;
  final String? participantUserId;
  final String? participantName;
  final String? participantAvatarUrl;

  ChatRoom toEntity() => ChatRoom(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    matchRequestId: matchRequestId,
    participantUserId: participantUserId,
    participantName: participantName,
    participantAvatarUrl: participantAvatarUrl,
  );

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

Map<String, dynamic> _asMap(Object? value) => value is Map
    ? value.map((key, item) => MapEntry(key.toString(), item))
    : const {};

String? _asString(Object? value) {
  final result = value?.toString().trim();
  return result == null || result.isEmpty ? null : result;
}

String? _displayName(Map<String, dynamic> value) => _firstNonEmpty([
  _asString(value['full_name']),
  _asString(value['display_name']),
  _asString(value['name']),
  [
    _asString(value['first_name']),
    _asString(value['last_name']),
  ].whereType<String>().where((part) => part.isNotEmpty).join(' '),
]);

String? _firstNonEmpty(Iterable<String?> values) {
  for (final value in values) {
    if (value != null && value.trim().isNotEmpty) return value.trim();
  }
  return null;
}

DateTime _asDateTime(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '') ??
    DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
