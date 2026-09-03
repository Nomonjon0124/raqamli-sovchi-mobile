import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/core/notifications/notification_event_bus.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/check_location_access.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/cluster_nearby_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/get_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/open_location_settings.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/request_current_location.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/update_profile_location.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/discovery_filter.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/geo_coordinates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/location_access_status.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/location_repository.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_bloc.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidates_page.dart';
import 'package:raqamli_sovchi/features/notifications/application/use_cases/notification_use_cases.dart';
import 'package:raqamli_sovchi/features/notifications/domain/entities/app_notification.dart';
import 'package:raqamli_sovchi/features/notifications/domain/repositories/notification_repository.dart';
import 'package:raqamli_sovchi/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  tearDown(() => serviceLocator.reset());

  testWidgets('shows a toast when nearby loading fails', (tester) async {
    const serverMessage = "Radius butun son bo'lishi kerak.";
    const discoveryRepository = _DiscoveryRepository(
      nearbyFailure: Failure.validation(message: serverMessage),
    );
    final locationRepository = _LocationRepository();
    final profileRepository = _ProfileRepository();
    final notificationRepository = _NotificationRepository();
    final eventBus = NotificationEventBus();
    addTearDown(eventBus.dispose);

    serviceLocator
      ..registerFactory<DiscoveryBloc>(
        () => DiscoveryBloc(
          getCandidates: const GetCandidatesUseCase(discoveryRepository),
          checkLocationAccess: CheckLocationAccessUseCase(locationRepository),
          requestCurrentLocation: RequestCurrentLocationUseCase(
            locationRepository,
          ),
          openLocationSettings: OpenLocationSettingsUseCase(locationRepository),
          updateProfileLocation: UpdateProfileLocationUseCase(
            profileRepository,
          ),
          clusterNearbyCandidates: const ClusterNearbyCandidatesUseCase(),
        ),
      )
      ..registerFactory<NotificationsBloc>(
        () => NotificationsBloc(
          loadNotifications: LoadNotificationsUseCase(notificationRepository),
          loadUnreadCount: LoadUnreadNotificationCountUseCase(
            notificationRepository,
          ),
          markRead: MarkNotificationReadUseCase(notificationRepository),
          markAllRead: MarkAllNotificationsReadUseCase(notificationRepository),
          eventBus: eventBus,
        ),
      );

    await tester.pumpWidget(const _LocalizedTestApp(child: CandidatesPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Atrofdagilar'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(SnackBar),
        matching: find.text(serverMessage),
      ),
      findsOneWidget,
    );
  });
}

final class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}

final class _DiscoveryRepository implements DiscoveryRepository {
  const _DiscoveryRepository({required this.nearbyFailure});

  final Failure nearbyFailure;

  @override
  Future<Either<Failure, List<Candidate>>> getCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
    double? radiusKm,
  }) async {
    if (filter == DiscoveryFilter.nearby) {
      return Left(nearbyFailure);
    }
    return const Right([]);
  }

  @override
  Future<Either<Failure, Candidate>> getCandidate(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Candidate>>> getSavedCandidates() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> saveCandidate(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> unsaveCandidate(String id) =>
      throw UnimplementedError();
}

final class _LocationRepository implements LocationRepository {
  @override
  Future<LocationAccessStatus> checkAccess() async =>
      LocationAccessStatus.granted;

  @override
  Future<bool> openSettings(LocationAccessStatus status) async => true;

  @override
  Future<Either<Failure, GeoCoordinates>> requestCurrentLocation() async =>
      const Right(GeoCoordinates(latitude: 41.311081, longitude: 69.240562));
}

final class _ProfileRepository implements ProfileRepository {
  @override
  Future<Either<Failure, UserProfile>> getMyProfile() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    return const Right(true);
  }
}

final class _NotificationRepository implements NotificationRepository {
  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    int page = 1,
  }) async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async => const Right(0);

  @override
  Future<Either<Failure, void>> markRead(String id) async => const Right(null);

  @override
  Future<Either<Failure, void>> markAllRead() async => const Right(null);

  @override
  Future<Either<Failure, void>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> unregisterDevice(String deviceId) async =>
      const Right(null);

  @override
  Future<Either<Failure, String>> createWebSocketTicket() async =>
      const Right('');
}
