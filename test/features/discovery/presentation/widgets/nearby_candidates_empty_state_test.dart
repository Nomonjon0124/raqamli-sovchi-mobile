import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/nearby_candidates_empty_state.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('offers radius expansion and notification controls', (
    tester,
  ) async {
    var expanded = false;
    var notificationsEnabled = true;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('uz'),
        home: Scaffold(
          body: NearbyCandidatesEmptyState(
            radiusKm: 5,
            notificationsEnabled: notificationsEnabled,
            onExpandRadius: () => expanded = true,
            onChangeCriteria: () {},
            onNotificationsChanged: (value) => notificationsEnabled = value,
          ),
        ),
      ),
    );

    expect(find.text('5 km ichida hozircha nomzod yo‘q'), findsOneWidget);
    await tester.tap(find.text('Radiusni 25 km ga kengaytirish'));
    await tester.pump();
    expect(expanded, isTrue);
  });
}
