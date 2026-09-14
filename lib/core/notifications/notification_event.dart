import 'dart:convert';

import 'package:equatable/equatable.dart';

final class NotificationEvent extends Equatable {
  const NotificationEvent({
    required this.id,
    required this.title,
    required this.message,
    required this.extraData,
    this.type = 'notification',
    this.presenceUserId,
    this.presenceStatus,
    this.presenceLastSeen,
    this.isOpened = false,
  });

  final String id;
  final String title;
  final String message;
  final Map<String, dynamic> extraData;
  final String type;
  final String? presenceUserId;
  final String? presenceStatus;
  final DateTime? presenceLastSeen;
  final bool isOpened;

  factory NotificationEvent.fromPushData(
    Map<String, dynamic> data, {
    bool isOpened = false,
  }) {
    final rawPayload = data['payload'];
    final decoded = rawPayload is String ? jsonDecode(rawPayload) : rawPayload;
    final extraData =
        <String, dynamic>{
            ...data,
            if (decoded is Map)
              ...decoded.map((key, value) => MapEntry(key.toString(), value)),
          }
          ..remove('payload')
          ..remove('title')
          ..remove('message')
          ..remove('notification_id');
    return NotificationEvent(
      id: data['notification_id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      extraData: extraData,
      type: data['type']?.toString() ?? 'notification',
      isOpened: isOpened,
    );
  }

  factory NotificationEvent.fromWebSocket(Map<String, dynamic> data) {
    final type = data['type']?.toString() ?? 'notification';
    return NotificationEvent(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      extraData: data['extra_data'] is Map
          ? (data['extra_data'] as Map).map(
              (key, value) => MapEntry(key.toString(), value),
            )
          : const {},
      type: type,
      presenceUserId: type == 'presence' ? data['user']?.toString() : null,
      presenceStatus: type == 'presence' ? data['status']?.toString() : null,
      presenceLastSeen: type == 'presence'
          ? DateTime.tryParse(data['last_seen']?.toString() ?? '')
          : null,
      isOpened: false,
    );
  }

  bool get isPresence =>
      type == 'presence' && presenceUserId?.isNotEmpty == true;

  bool get isValid => isPresence || id.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    extraData,
    type,
    presenceUserId,
    presenceStatus,
    presenceLastSeen,
    isOpened,
  ];
}

String? notificationMatchRequestId(Map<String, dynamic> data) {
  const keys = [
    'match_request_id',
    'matchRequestId',
    'request_id',
    'requestId',
    'match_request',
    'matchRequest',
  ];
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    if (value is Map) {
      final id = value['id']?.toString().trim();
      if (id != null && id.isNotEmpty) return id;
    }
  }
  return null;
}

bool isMatchRequestNotificationData(Map<String, dynamic> data) {
  final type = (data['type'] ?? data['event_type'] ?? '').toString();
  return type.contains('match') ||
      type.contains('request') ||
      data.keys.any(
        (key) => key == 'match_request' || key == 'match_request_id',
      );
}
