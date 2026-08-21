import 'dart:async';

import 'notification_event.dart';

final class NotificationEventBus {
  final _controller = StreamController<NotificationEvent>.broadcast();

  Stream<NotificationEvent> get events => _controller.stream;
  void add(NotificationEvent event) {
    if (event.isValid) _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
