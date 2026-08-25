import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../core/security/screenshot_guard.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/notifications/data/services/notification_lifecycle_service.dart';
import '../firebase_options.dart';
import 'app.dart';
import 'di/service_locator.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await configureDependencies();
  await serviceLocator<NotificationLifecycleService>().initialize();
  await serviceLocator<ScreenshotGuard>().enableProtection();

  final authBloc = serviceLocator<AuthBloc>()..add(const AuthStarted());

  runApp(App(authBloc: authBloc));
}
