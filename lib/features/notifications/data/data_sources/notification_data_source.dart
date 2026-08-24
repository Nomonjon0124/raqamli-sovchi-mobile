import '../../../../core/network/api_client.dart';
import '../models/app_notification_model.dart';

abstract interface class NotificationDataSource {
  Future<List<AppNotificationModel>> fetchNotifications({int page = 1});
  Future<int> fetchUnreadCount();
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<void> registerDevice(Map<String, dynamic> data);
  Future<void> unregisterDevice(String deviceId);
  Future<String> createWebSocketTicket();
}

final class RemoteNotificationDataSource implements NotificationDataSource {
  const RemoteNotificationDataSource(this._client);
  final ApiClient _client;
  static const _basePath = '/api/v1/accounts/notifications/';

  @override
  Future<List<AppNotificationModel>> fetchNotifications({int page = 1}) async {
    final response = await _client.get<dynamic>(
      _basePath,
      queryParameters: {'page': page},
    );
    final data = _unwrap(response.data);
    final values = data['results'] is List
        ? data['results'] as List
        : <dynamic>[];
    return values
        .whereType<Map>()
        .map(
          (item) => AppNotificationModel.fromJson(
            item.map((key, value) => MapEntry(key.toString(), value)),
          ),
        )
        .toList();
  }

  @override
  Future<int> fetchUnreadCount() async {
    final response = await _client.get<dynamic>('${_basePath}count/');
    final value = _unwrap(response.data)['unread'];
    return value is num
        ? value.toInt()
        : int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Future<void> markRead(String id) =>
      _client.patch<dynamic>('$_basePath$id/read/');
  @override
  Future<void> markAllRead() => _client.post<dynamic>('${_basePath}read-all/');
  @override
  Future<void> registerDevice(Map<String, dynamic> data) =>
      _client.post<dynamic>('${_basePath}devices/register/', data: data);
  @override
  Future<void> unregisterDevice(String deviceId) => _client.delete<dynamic>(
    '${_basePath}devices/current/',
    data: {'device_id': deviceId},
  );
  @override
  Future<String> createWebSocketTicket() async {
    final response = await _client.post<dynamic>('${_basePath}tickets/');
    final ticket = _unwrap(response.data)['ticket']?.toString();
    if (ticket == null || ticket.isEmpty)
      throw const FormatException('Missing notification ticket');
    return ticket;
  }
}

Map<String, dynamic> _unwrap(Object? value) {
  if (value is! Map) return const {};
  final map = value.map((key, item) => MapEntry(key.toString(), item));
  return map['data'] is Map ? _unwrap(map['data']) : map;
}
