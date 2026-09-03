import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:raqamli_sovchi/app/router/route_names.dart';
import 'package:raqamli_sovchi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:raqamli_sovchi/features/settings/presentation/pages/settings_page.dart';
import 'package:raqamli_sovchi/features/settings/presentation/widgets/settings_account_actions.dart';
import 'package:raqamli_sovchi/features/settings/presentation/widgets/settings_delete_dialog.dart';
import 'package:raqamli_sovchi/features/settings/presentation/widgets/settings_section.dart';
import 'package:raqamli_sovchi/gen/assets.gen.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  tearDown(() => serviceLocator.reset());

  testWidgets('renders the Figma settings sections at mobile width', (
    tester,
  ) async {
    await _loadManrope();
    await configureDependencies();
    final authBloc = serviceLocator<AuthBloc>();
    await tester.binding.setSurfaceSize(const Size(390, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const MaterialApp(
          locale: Locale('uz'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sozlamalar'), findsOneWidget);
    expect(find.text('Hisob'), findsOneWidget);
    expect(find.text('Profilni tahrirlash'), findsOneWidget);
    expect(find.text('Maxfiylik va suhbat'), findsOneWidget);
    expect(find.text('Bildirishnoma va ko‘rinish'), findsOneWidget);
    expect(find.text('Hujjatlar'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Yordam va ma’lumot'), 250);
    expect(find.text('Yordam va ma’lumot'), findsOneWidget);

    final logout = find.text('Hisobdan chiqish');
    await tester.scrollUntilVisible(logout, 350);
    expect(logout, findsOneWidget);
    expect(find.text('Hisobni oʻchirish'), findsOneWidget);
  });

  testWidgets('account actions invoke logout and confirm account deletion', (
    tester,
  ) async {
    var logoutRequested = false;
    var deleteRequested = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => SettingsAccountActions(
              logoutText: 'Hisobdan chiqish',
              deleteText: 'Hisobni oʻchirish',
              isLoading: false,
              onLogout: () => logoutRequested = true,
              onDelete: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (_) => const SettingsDeleteDialog(
                    title: 'Hisobingiz oʻchirilsinmi?',
                    message: 'Bu amalni ortga qaytarib boʻlmaydi.',
                    cancelText: 'Bekor qilish',
                    confirmText: 'Oʻchirish',
                  ),
                );
                deleteRequested = confirmed ?? false;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Hisobdan chiqish'));
    expect(logoutRequested, isTrue);

    await tester.tap(find.text('Hisobni oʻchirish'));
    await tester.pumpAndSettle();
    expect(find.text('Hisobingiz oʻchirilsinmi?'), findsOneWidget);

    await tester.tap(find.text('Oʻchirish'));
    await tester.pumpAndSettle();
    expect(deleteRequested, isTrue);
  });

  testWidgets('opens privacy policy through the configured route', (
    tester,
  ) async {
    await _loadManrope();
    await configureDependencies();
    final authBloc = serviceLocator<AuthBloc>();
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SettingsPage()),
        GoRoute(
          path: RouteNames.privacyPolicy,
          builder: (_, _) => const Scaffold(body: Text('Privacy route opened')),
        ),
      ],
    );

    await tester.pumpWidget(
      BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: MaterialApp.router(
          locale: const Locale('uz'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    await tester.scrollUntilVisible(find.text('Maxfiylik siyosati'), 250);
    await tester.tap(find.text('Maxfiylik siyosati'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Privacy route opened'), findsOneWidget);
  });

  testWidgets('keeps SettingsRow title on the left and value on the right', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 350,
            child: SettingsRow(
              icon: Assets.icons.settingsImage,
              title: 'Rasm maxfiyligi',
              value: 'Hammaga ochiq',
              onTap: _noop,
            ),
          ),
        ),
      ),
    );

    final titleRect = tester.getRect(find.text('Rasm maxfiyligi'));
    final valueRect = tester.getRect(find.text('Hammaga ochiq'));
    final icons = find.byType(SvgPicture);
    final leadingIconRect = tester.getRect(icons.at(0));
    final trailingIconRect = tester.getRect(icons.at(1));

    expect(titleRect.left, greaterThan(leadingIconRect.right));
    expect(valueRect.left, greaterThan(titleRect.left));
    expect(valueRect.right, lessThan(trailingIconRect.left));
  });
}

void _noop() {}

Future<void> _loadManrope() async {
  final fontLoader = FontLoader('Manrope')
    ..addFont(rootBundle.load('assets/fonts/Manrope-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Manrope-Medium.ttf'))
    ..addFont(rootBundle.load('assets/fonts/Manrope-SemiBold.ttf'));
  await fontLoader.load();
}
