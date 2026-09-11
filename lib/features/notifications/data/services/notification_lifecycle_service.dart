import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/notifications/notification_event.dart';
import '../../../../core/notifications/notification_event_bus.dart';
import '../../../../core/security/notification_device_store.dart';
import '../../application/use_cases/notification_use_cases.dart';

final class NotificationLifecycleService {
  NotificationLifecycleService({
    required NotificationDeviceStore deviceStore,
    required RegisterNotificationDeviceUseCase registerDevice,
    required UnregisterNotificationDeviceUseCase unregisterDevice,
    required CreateNotificationTicketUseCase createTicket,
    required NotificationEventBus eventBus,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _deviceStore = deviceStore,
       _registerDevice = registerDevice,
       _unregisterDevice = unregisterDevice,
       _createTicket = createTicket,
       _eventBus = eventBus,
       _messaging = messaging ?? FirebaseMessaging.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  static const channelId = 'raqamli_sovchi_notifications';
  final NotificationDeviceStore _deviceStore;
  final RegisterNotificationDeviceUseCase _registerDevice;
  final UnregisterNotificationDeviceUseCase _unregisterDevice;
  final CreateNotificationTicketUseCase _createTicket;
  final NotificationEventBus _eventBus;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;
  StreamSubscription<dynamic>? _socketSubscription;
  WebSocketChannel? _socket;
  Timer? _pingTimer;
  bool _initialized = false;
  bool _active = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: android,
      iOS: DarwinInitializationSettings(),
    );
    await _localNotifications.initialize(settings: settings);
    const channel = AndroidNotificationChannel(
      channelId,
      'Raqamli Sovchi bildirishnomalari',
      description: 'Yangi so‘rovlar va xabarlar',
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _handleForeground,
    );
    _openedSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleOpened,
    );
    _initialized = true;
  }

  Future<void> activate() async {
    if (_active) return;
    _active = true;
    await _connectSocket();
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;
    await _messaging.setAutoInitEnabled(true);
    final token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) await _syncToken(token);
    _tokenSubscription = _messaging.onTokenRefresh.listen(_syncToken);
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handleOpened(initial);
  }

  Future<void> deactivate() async {
    _active = false;
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
    await _socketSubscription?.cancel();
    _socketSubscription = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    await _socket?.sink.close();
    _socket = null;
    final deviceId = await _deviceStore.readOrCreateDeviceId();
    await _unregisterDevice(deviceId);
    await _messaging.deleteToken();
    await _deviceStore.clear();
  }

  Future<void> dispose() async {
    await deactivate();
    await _foregroundSubscription?.cancel();
    await _openedSubscription?.cancel();
  }

  Future<void> _syncToken(String token) async {
    if (!_active) return;
    final deviceId = await _deviceStore.readOrCreateDeviceId();
    final result = await _registerDevice(
      fcmToken: token,
      deviceId: deviceId,
      deviceType: Platform.isIOS ? 'ios' : 'android',
    );
    result.fold((_) {}, (_) => unawaited(_deviceStore.saveFcmToken(token)));
  }

  Future<void> _connectSocket() async {
    if (AppConfig.wsUrl.isEmpty || !_active) return;
    final ticketResult = await _createTicket();
    ticketResult.fold((_) {}, (ticket) {
      final endpoint = Uri.parse(AppConfig.wsUrl).replace(
        path: '/ws/notifications/',
        queryParameters: {'ticket': ticket},
      );
      _socket = WebSocketChannel.connect(endpoint);
      _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        try {
          _socket?.sink.add(jsonEncode({'type': 'ping'}));
        } catch (_) {}
      });
      _socketSubscription = _socket!.stream.listen((dynamic raw) {
        if (raw is! String) return;
        try {
          final decoded = jsonDecode(raw);
          if (decoded is Map) {
            _eventBus.add(
              NotificationEvent.fromWebSocket(
                decoded.map((key, value) => MapEntry(key.toString(), value)),
              ),
            );
          }
        } catch (_) {}
      });
    });
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    final event = _eventFromMessage(message);
    if (event != null) _eventBus.add(event);
    final notification = message.notification;
    if (notification == null) return;
    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Raqamli Sovchi bildirishnomalari',
          channelDescription: 'Yangi so‘rovlar va xabarlar',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _handleOpened(RemoteMessage message) {
    final event = _eventFromMessage(message);
    if (event != null) _eventBus.add(event);
  }

  NotificationEvent? _eventFromMessage(RemoteMessage message) {
    try {
      return NotificationEvent.fromPushData({
        ...message.data,
        'title': message.notification?.title ?? message.data['title'],
        'message': message.notification?.body ?? message.data['message'],
      });
    } catch (_) {
      return null;
    }
  }
}
