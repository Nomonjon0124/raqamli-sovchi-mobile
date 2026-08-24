import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/app_notification.dart';

enum NotificationsStatus { initial, loading, success, empty, failure }

final class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.failure,
  });
  final NotificationsStatus status;
  final List<AppNotification> notifications;
  final int unreadCount;
  final Failure? failure;
  NotificationsState copyWith({
    NotificationsStatus? status,
    List<AppNotification>? notifications,
    int? unreadCount,
    Failure? failure,
    bool clearFailure = false,
  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
    unreadCount: unreadCount ?? this.unreadCount,
    failure: clearFailure ? null : failure ?? this.failure,
  );
  @override
  List<Object?> get props => [status, notifications, unreadCount, failure];
}
