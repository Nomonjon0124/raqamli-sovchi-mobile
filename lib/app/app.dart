import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:thunder/thunder.dart';

import '../core/notifications/notification_event.dart';
import '../core/notifications/notification_event_bus.dart';
import '../core/security/background_lock_gate.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/notifications/data/services/notification_lifecycle_service.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({required this.authBloc, this.backgroundLockGate, super.key});

  final AuthBloc authBloc;
  final BackgroundLockGate? backgroundLockGate;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> with WidgetsBindingObserver {
  late final GoRouter _router = AppRouter(authBloc: widget.authBloc).router;
  late final BackgroundLockGate _backgroundLockGate =
      widget.backgroundLockGate ?? serviceLocator<BackgroundLockGate>();
  late final StreamSubscription<NotificationEvent> _notificationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationSubscription = serviceLocator<NotificationEventBus>().events
        .where((event) => event.isOpened && !event.isPresence)
        .listen(_handleOpenedNotification);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_notificationSubscription.cancel());
    super.dispose();
  }

  void _handleOpenedNotification(NotificationEvent event) {
    final requestId = notificationMatchRequestId(event.extraData);
    if (requestId != null) {
      _router.push(RouteNames.chatRequestProfileFor(requestId));
    } else if (isMatchRequestNotificationData(event.extraData)) {
      _router.go('${RouteNames.messages}?tab=requests');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _backgroundLockGate.markBackgrounded();
      return;
    }

    if (state == AppLifecycleState.resumed &&
        _backgroundLockGate.consumeShouldLockOnResume()) {
      widget.authBloc.add(const AuthApplicationResumed());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          final lifecycle = serviceLocator<NotificationLifecycleService>();
          if (state.status == AuthStatus.authenticated) {
            lifecycle.activate();
          } else if (state.status == AuthStatus.unauthenticated) {
            lifecycle.deactivate();
          }
        },
        child: MaterialApp.router(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,
          locale: const Locale('uz'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
          builder: (context, child) => Thunder(
            enabled: true,
            dio: [serviceLocator<Dio>()],
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
