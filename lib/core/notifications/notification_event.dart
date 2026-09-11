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
  });

  final String id;
  final String title;
  final String message;
  final Map<String, dynamic> extraData;
  final String type;
  final String? presenceUserId;
  final String? presenceStatus;
  final DateTime? presenceLastSeen;

  factory NotificationEvent.fromPushData(Map<String, dynamic> data) {
    final rawPayload = data['payload'];
    final decoded = rawPayload is String ? jsonDecode(rawPayload) : rawPayload;
    return NotificationEvent(
      id: data['notification_id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      extraData: decoded is Map
          ? decoded.map((key, value) => MapEntry(key.toString(), value))
          : const {},
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
  ];
}
