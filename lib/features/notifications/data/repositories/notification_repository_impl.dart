import 'package:dio/dio.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/notification_data_source.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._source);
  final NotificationDataSource _source;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    int page = 1,
  }) => _guard(
    () async => (await _source.fetchNotifications(
      page: page,
    )).map((item) => item.toEntity()).toList(),
  );
  @override
  Future<Either<Failure, int>> getUnreadCount() =>
      _guard(_source.fetchUnreadCount);
  @override
  Future<Either<Failure, void>> markRead(String id) =>
      _guard(() => _source.markRead(id));
  @override
  Future<Either<Failure, void>> markAllRead() => _guard(_source.markAllRead);
  @override
  Future<Either<Failure, void>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) => _guard(
    () => _source.registerDevice({
      'fcm_token': fcmToken,
      'device_id': deviceId,
      'device_type': deviceType,
    }),
  );
  @override
  Future<Either<Failure, void>> unregisterDevice(String deviceId) =>
      _guard(() => _source.unregisterDevice(deviceId));
  @override
  Future<Either<Failure, String>> createWebSocketTicket() =>
      _guard(_source.createWebSocketTicket);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DioException catch (error) {
      return Left(mapDioException(error));
    } on FormatException {
      return const Left(Failure.validation());
    } catch (_) {
      return const Left(Failure.unknown());
    }
  }
}
