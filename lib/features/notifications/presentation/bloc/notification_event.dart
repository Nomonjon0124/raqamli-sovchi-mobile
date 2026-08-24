import 'package:equatable/equatable.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

final class NotificationsLoadRequested extends NotificationsEvent {
  const NotificationsLoadRequested();
}

final class NotificationsReadRequested extends NotificationsEvent {
  const NotificationsReadRequested(this.id);
  final String id;
  @override
  List<Object?> get props => [id];
}

final class NotificationsReadAllRequested extends NotificationsEvent {
  const NotificationsReadAllRequested();
}

final class NotificationsRealtimeReceived extends NotificationsEvent {
  const NotificationsRealtimeReceived();
}
