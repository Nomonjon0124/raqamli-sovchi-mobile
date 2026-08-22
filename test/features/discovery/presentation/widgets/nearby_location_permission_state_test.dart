import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/location_access_status.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/nearby_location_permission_state.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  Widget buildWidget({
    LocationAccessStatus status = LocationAccessStatus.denied,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onDismissed,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('uz'),
      home: Scaffold(
        body: NearbyLocationPermissionState(
          accessStatus: status,
          isLoading: false,
          onPrimaryPressed: onPrimaryPressed ?? () {},
          onDismissed: onDismissed ?? () {},
        ),
      ),
    );
  }

  testWidgets('explains privacy before asking for location', (tester) async {
    var allowed = false;
    var dismissed = false;
    await tester.pumpWidget(
      buildWidget(
        onPrimaryPressed: () => allowed = true,
        onDismissed: () => dismissed = true,
      ),
    );

    expect(find.text('Yaqin atrofdagi nomzodlar'), findsOneWidget);
    expect(
      find.text('Aniq manzilingiz hech kimga ko‘rsatilmaydi'),
      findsOneWidget,
    );

    await tester.tap(find.text('Joylashuvga ruxsat berish'));
    await tester.pump();
    expect(allowed, isTrue);

    await tester.tap(find.text('Hozir emas'));
    await tester.pump();
    expect(dismissed, isTrue);
  });

  testWidgets('directs permanently denied users to app settings', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildWidget(status: LocationAccessStatus.permanentlyDenied),
    );

    expect(find.text('Sozlamalarni ochish'), findsOneWidget);
  });
}
