import 'dart:convert';

import 'package:equatable/equatable.dart';

final class NotificationEvent extends Equatable {
  const NotificationEvent({
    required this.id,
    required this.title,
    required this.message,
    required this.extraData,
  });

  final String id;
  final String title;
  final String message;
  final Map<String, dynamic> extraData;

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

  factory NotificationEvent.fromWebSocket(Map<String, dynamic> data) =>
      NotificationEvent(
        id: data['id']?.toString() ?? '',
        title: data['title']?.toString() ?? '',
        message: data['message']?.toString() ?? '',
        extraData: data['extra_data'] is Map
            ? (data['extra_data'] as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              )
            : const {},
      );

  bool get isValid => id.isNotEmpty;

  @override
  List<Object?> get props => [id, title, message, extraData];
}
