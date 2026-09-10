import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:thunder/thunder.dart';

import '../core/security/background_lock_gate.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/notifications/data/services/notification_lifecycle_service.dart';
import '../l10n/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends StatefulWidget {
  const App({required this.authBloc, this.backgroundLockGate, super.key});

  final AuthBloc authBloc;
  final BackgroundLockGate? backgroundLockGate;

  @override
  State<App> createState() => _AppState();
}

final class _AppState extends State<App> with WidgetsBindingObserver {
  late final RouterConfig<Object> _router = AppRouter(
    authBloc: widget.authBloc,
  ).router;
  late final BackgroundLockGate _backgroundLockGate =
      widget.backgroundLockGate ?? serviceLocator<BackgroundLockGate>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
