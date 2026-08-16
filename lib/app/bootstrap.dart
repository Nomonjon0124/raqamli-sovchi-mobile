import 'package:flutter/widgets.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import 'app.dart';
import 'di/service_locator.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  // await serviceLocator<ScreenshotGuard>().enableProtection();

  final authBloc = serviceLocator<AuthBloc>()..add(const AuthStarted());

  runApp(App(authBloc: authBloc));
}
