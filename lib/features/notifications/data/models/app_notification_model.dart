import 'package:equatable/equatable.dart';

import '../../domain/entities/app_notification.dart';

final class AppNotificationModel extends Equatable {
  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.extraData,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) =>
      AppNotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
        type: json['type']?.toString() ?? 'notification',
        extraData: json['extra_data'] is Map
            ? (json['extra_data'] as Map).map(
                (key, value) => MapEntry(key.toString(), value),
              )
            : const {},
        isRead: json['is_read'] == true,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );

  final String id;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic> extraData;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification toEntity() => AppNotification(
    id: id,
    title: title,
    message: message,
    type: type,
    extraData: extraData,
    isRead: isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    extraData,
    isRead,
    createdAt,
  ];
}
