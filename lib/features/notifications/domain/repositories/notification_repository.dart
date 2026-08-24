import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/app_notification.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    int page = 1,
  });
  Future<Either<Failure, int>> getUnreadCount();
  Future<Either<Failure, void>> markRead(String id);
  Future<Either<Failure, void>> markAllRead();
  Future<Either<Failure, void>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  });
  Future<Either<Failure, void>> unregisterDevice(String deviceId);
  Future<Either<Failure, String>> createWebSocketTicket();
}
