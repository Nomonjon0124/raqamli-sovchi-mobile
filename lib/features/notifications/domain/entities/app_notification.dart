import 'package:equatable/equatable.dart';

final class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.extraData,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String message;
  final Map<String, dynamic> extraData;
  final bool isRead;
  final DateTime? createdAt;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    message: message,
    extraData: extraData,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt,
  );

  @override
  List<Object?> get props => [id, title, message, extraData, isRead, createdAt];
}
