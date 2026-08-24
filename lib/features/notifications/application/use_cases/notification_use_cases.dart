import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';

final class LoadNotificationsUseCase {
  const LoadNotificationsUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, List<AppNotification>>> call({int page = 1}) =>
      _repository.getNotifications(page: page);
}

final class LoadUnreadNotificationCountUseCase {
  const LoadUnreadNotificationCountUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, int>> call() => _repository.getUnreadCount();
}

final class MarkNotificationReadUseCase {
  const MarkNotificationReadUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, void>> call(String id) => _repository.markRead(id);
}

final class MarkAllNotificationsReadUseCase {
  const MarkAllNotificationsReadUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, void>> call() => _repository.markAllRead();
}

final class RegisterNotificationDeviceUseCase {
  const RegisterNotificationDeviceUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, void>> call({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) => _repository.registerDevice(
    fcmToken: fcmToken,
    deviceId: deviceId,
    deviceType: deviceType,
  );
}

final class UnregisterNotificationDeviceUseCase {
  const UnregisterNotificationDeviceUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, void>> call(String deviceId) =>
      _repository.unregisterDevice(deviceId);
}

final class CreateNotificationTicketUseCase {
  const CreateNotificationTicketUseCase(this._repository);
  final NotificationRepository _repository;
  Future<Either<Failure, String>> call() => _repository.createWebSocketTicket();
}
