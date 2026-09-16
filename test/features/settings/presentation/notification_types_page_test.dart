import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/theme/app_theme.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/notifications/application/use_cases/notification_use_cases.dart';
import 'package:raqamli_sovchi/features/notifications/domain/entities/app_notification.dart';
import 'package:raqamli_sovchi/features/notifications/domain/entities/notification_preferences.dart';
import 'package:raqamli_sovchi/features/notifications/domain/repositories/notification_repository.dart';
import 'package:raqamli_sovchi/features/notifications/presentation/cubit/notification_preferences_cubit.dart';
import 'package:raqamli_sovchi/features/settings/presentation/pages/notification_types_page.dart';
import 'package:raqamli_sovchi/features/settings/presentation/widgets/settings_section.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'renders notification types in Uzbek Cyrillic and toggles locally',
    (tester) async {
      final repository = _NotificationPreferencesRepository();
      final cubit = _createCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale.fromSubtags(
            languageCode: 'uz',
            scriptCode: 'Cyrl',
          ),
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: NotificationTypesPage(cubit: cubit),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Билдиришномалар'), findsOneWidget);
      expect(
        find.text('Қайси ҳодисалар ҳақида хабар олишни танланг.'),
        findsOneWidget,
      );
      expect(find.byType(SettingsToggleRow), findsNWidgets(4));
      expect(find.text('Янги мослик'), findsOneWidget);
      expect(find.text('Янги хабар'), findsOneWidget);
      expect(find.text('Профил кўрилди'), findsOneWidget);
      expect(find.text('Тизим хабарлари'), findsOneWidget);

      final profileSwitch = find.byType(AnimatedContainer).at(2);
      final initialDecoration = tester.widget<AnimatedContainer>(profileSwitch);
      expect(
        (initialDecoration.decoration! as BoxDecoration).color,
        AppTheme.dark.colorScheme.outline,
      );

      await tester.tap(profileSwitch);
      await tester.pump(const Duration(milliseconds: 200));

      expect(
        (tester.widget<AnimatedContainer>(profileSwitch).decoration!
                as BoxDecoration)
            .color,
        AppTheme.dark.colorScheme.primary,
      );
    },
  );

  testWidgets('renders English notification type labels in light theme', (
    tester,
  ) async {
    final cubit = _createCubit(_NotificationPreferencesRepository());
    addTearDown(cubit.close);
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: NotificationTypesPage(cubit: cubit),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(
      find.text('Choose which events to get notified about.'),
      findsOneWidget,
    );
    expect(find.text('New match'), findsOneWidget);
  });
}

NotificationPreferencesCubit _createCubit(NotificationRepository repository) =>
    NotificationPreferencesCubit(
      load: LoadNotificationPreferencesUseCase(repository),
      update: UpdateNotificationPreferenceUseCase(repository),
    );

final class _NotificationPreferencesRepository
    implements NotificationRepository {
  NotificationPreferences _preferences = const NotificationPreferences();

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    int page = 1,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, int>> getUnreadCount() => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, void>> markAllRead() => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> registerDevice({
    required String fcmToken,
    required String deviceId,
    required String deviceType,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> unregisterDevice(String deviceId) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, String>> createWebSocketTicket() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, NotificationPreferences>>
  getNotificationPreferences() async => Right(_preferences);

  @override
  Future<Either<Failure, NotificationPreferences>> updateNotificationPreference(
    NotificationPreferenceType type,
    bool enabled,
  ) async {
    _preferences = _preferences.withValue(type, enabled);
    return Right(_preferences);
  }
}
