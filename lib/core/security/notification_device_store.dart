import 'package:uuid/uuid.dart';

import 'secure_storage.dart';

abstract interface class NotificationDeviceStore {
  Future<String> readOrCreateDeviceId();
  Future<void> saveFcmToken(String token);
  Future<String?> readFcmToken();
  Future<void> clear();
}

final class SecureNotificationDeviceStore implements NotificationDeviceStore {
  const SecureNotificationDeviceStore(this._storage);

  static const _deviceIdKey = 'notifications.device_id';
  static const _fcmTokenKey = 'notifications.fcm_token';
  final SecureStorage _storage;

  @override
  Future<String> readOrCreateDeviceId() async {
    final current = await _storage.read(key: _deviceIdKey);
    if (current != null && current.isNotEmpty) return current;
    final deviceId = const Uuid().v4();
    await _storage.write(key: _deviceIdKey, value: deviceId);
    return deviceId;
  }

  @override
  Future<void> saveFcmToken(String token) =>
      _storage.write(key: _fcmTokenKey, value: token);

  @override
  Future<String?> readFcmToken() => _storage.read(key: _fcmTokenKey);

  @override
  Future<void> clear() async {
    await _storage.delete(key: _fcmTokenKey);
    await _storage.delete(key: _deviceIdKey);
  }
}
