import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_state.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/nearby_radius_settings_sheet.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('shows Figma radius settings and returns saved values', (
    tester,
  ) async {
    NearbyRadiusSettingsResult? savedResult;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('uz'),
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () async {
                savedResult = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const NearbyRadiusSettingsSheet(
                    initialRadiusKm: 5,
                    initialProfileVisibility: true,
                    initialAudience: NearbyVisibilityAudience.highCompatibility,
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Radius va ko‘rinish'), findsOneWidget);
    expect(find.text('Radius'), findsOneWidget);
    expect(find.text('1–25 km'), findsOneWidget);
    expect(find.text('1 km'), findsOneWidget);
    expect(find.text('3 km'), findsOneWidget);
    expect(find.text('5 km'), findsOneWidget);
    expect(find.text('15 km'), findsOneWidget);
    expect(find.text('Butun viloyat'), findsNothing);
    expect(find.text('Faqat moslik 70% dan yuqori'), findsOneWidget);

    await tester.tap(find.text('15 km'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Saqlash'));
    await tester.tap(find.text('Saqlash'));
    await tester.pumpAndSettle();

    expect(savedResult?.radiusKm, 15);
    expect(savedResult?.isProfileVisible, isTrue);
    expect(savedResult?.audience, NearbyVisibilityAudience.highCompatibility);
  });
}
