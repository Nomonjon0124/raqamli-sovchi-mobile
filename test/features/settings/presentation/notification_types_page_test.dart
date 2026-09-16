import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/theme/app_theme.dart';
import 'package:raqamli_sovchi/features/settings/presentation/pages/notification_types_page.dart';
import 'package:raqamli_sovchi/features/settings/presentation/widgets/settings_section.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'renders notification types in Uzbek Cyrillic and toggles locally',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale.fromSubtags(
            languageCode: 'uz',
            scriptCode: 'Cyrl',
          ),
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const NotificationTypesPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Билдиришномалар'), findsOneWidget);
      expect(
        find.text('Қайси ҳодисалар ҳақида хабар олишни танланг.'),
        findsOneWidget,
      );
      expect(find.byType(SettingsToggleRow), findsNWidgets(5));
      expect(find.text('Янги мослик'), findsOneWidget);
      expect(find.text('Янги хабар'), findsOneWidget);
      expect(find.text('Профил кўрилди'), findsOneWidget);
      expect(find.text('Психолог эслатмаси'), findsOneWidget);
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
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const NotificationTypesPage(),
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
