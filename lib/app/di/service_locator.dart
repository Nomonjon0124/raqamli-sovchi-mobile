import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_client.dart';
import '../../core/security/screenshot_guard.dart';
import '../../core/security/secure_storage.dart';
import '../../core/security/token_store.dart';
import '../../features/auth/application/use_cases/restore_session.dart';
import '../../features/auth/application/use_cases/sign_in.dart';
import '../../features/auth/application/use_cases/sign_out.dart';
import '../../features/auth/data/data_sources/mock_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> configureDependencies() async {
  if (serviceLocator.isRegistered<AuthBloc>()) {
    return;
  }

  serviceLocator
    ..registerLazySingleton<SecureStorage>(
      () => const FlutterSecureStorageAdapter(FlutterSecureStorage()),
    )
    ..registerLazySingleton<TokenStore>(
      () => SecureTokenStore(serviceLocator()),
    )
    ..registerLazySingleton<ScreenshotGuard>(SecureScreenshotGuard.new)
    ..registerLazySingleton<ApiClient>(
      () => DioApiClient(
        tokenStore: serviceLocator(),
        client: Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 30),
          ),
        ),
      ),
    )
    ..registerLazySingleton<MockAuthDataSource>(
      () => MockAuthDataSource(serviceLocator()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    ..registerFactory<RestoreSessionUseCase>(
      () => RestoreSessionUseCase(serviceLocator()),
    )
    ..registerFactory<SignInUseCase>(() => SignInUseCase(serviceLocator()))
    ..registerFactory<SignOutUseCase>(() => SignOutUseCase(serviceLocator()))
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        restoreSession: serviceLocator(),
        signIn: serviceLocator(),
        signOut: serviceLocator(),
      ),
    );
}

Future<void> resetDependencies() => serviceLocator.reset();
