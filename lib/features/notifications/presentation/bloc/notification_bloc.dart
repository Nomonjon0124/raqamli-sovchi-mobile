import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notification_event.dart';
import '../../../../core/notifications/notification_event_bus.dart';
import '../../application/use_cases/notification_use_cases.dart';
import 'notification_event.dart';
import 'notification_state.dart';

final class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required LoadNotificationsUseCase loadNotifications,
    required LoadUnreadNotificationCountUseCase loadUnreadCount,
    required MarkNotificationReadUseCase markRead,
    required MarkAllNotificationsReadUseCase markAllRead,
    required NotificationEventBus eventBus,
  }) : _loadNotifications = loadNotifications,
       _loadUnreadCount = loadUnreadCount,
       _markRead = markRead,
       _markAllRead = markAllRead,
       super(const NotificationsState()) {
    on<NotificationsLoadRequested>(_load);
    on<NotificationsReadRequested>(_read);
    on<NotificationsReadAllRequested>(_readAll);
    on<NotificationsRealtimeReceived>(
      (_, emit) => add(const NotificationsLoadRequested()),
    );
    _subscription = eventBus.events
        .where((event) => !event.isPresence)
        .listen((_) => add(const NotificationsRealtimeReceived()));
  }
  final LoadNotificationsUseCase _loadNotifications;
  final LoadUnreadNotificationCountUseCase _loadUnreadCount;
  final MarkNotificationReadUseCase _markRead;
  final MarkAllNotificationsReadUseCase _markAllRead;
  late final StreamSubscription<NotificationEvent> _subscription;
  Future<void> _load(
    NotificationsLoadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      state.copyWith(status: NotificationsStatus.loading, clearFailure: true),
    );
    final notificationsResult = await _loadNotifications();
    final unreadResult = await _loadUnreadCount();
    notificationsResult.fold(
      (failure) => emit(
        state.copyWith(status: NotificationsStatus.failure, failure: failure),
      ),
      (items) {
        final unread = unreadResult.fold(
          (_) => state.unreadCount,
          (count) => count,
        );
        emit(
          NotificationsState(
            status: items.isEmpty
                ? NotificationsStatus.empty
                : NotificationsStatus.success,
            notifications: items,
            unreadCount: unread,
          ),
        );
      },
    );
  }

  Future<void> _read(
    NotificationsReadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markRead(event.id);
    result.fold((failure) => emit(state.copyWith(failure: failure)), (_) {
      final items = state.notifications
          .map(
            (item) => item.id == event.id ? item.copyWith(isRead: true) : item,
          )
          .toList();
      emit(
        state.copyWith(
          notifications: items,
          unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
        ),
      );
    });
  }

  Future<void> _readAll(
    NotificationsReadAllRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    final result = await _markAllRead();
    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (_) => emit(
        state.copyWith(
          notifications: state.notifications
              .map((item) => item.copyWith(isRead: true))
              .toList(),
          unreadCount: 0,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
