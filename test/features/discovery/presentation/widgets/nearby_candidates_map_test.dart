import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/ui/widgets/app_bottom_nav_bar.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/geo_coordinates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/nearby_candidate_cluster.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_state.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/nearby_candidates_map.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

import '../../support/candidate_factory.dart';

void main() {
  testWidgets('renders Figma map controls and reports their actions', (
    tester,
  ) async {
    final visibility = AppBottomNavBarVisibilityController();
    addTearDown(visibility.dispose);

    var closed = false;
    DiscoveryViewMode? selectedMode;
    final candidate = createCandidate(id: 'candidate-1');

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('uz'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppBottomNavBarVisibilityScope(
            controller: visibility,
            child: NearbyCandidatesMap(
              currentLocation: const GeoCoordinates(
                latitude: 41.311081,
                longitude: 69.240562,
              ),
              clusters: [
                NearbyCandidateCluster(
                  id: 'cluster-1',
                  center: const GeoCoordinates(latitude: 41.3, longitude: 69.2),
                  candidates: [candidate],
                  zoneName: 'Yunusobod',
                  distanceKm: 2,
                ),
              ],
              items: [
                NearbyCandidateMapItem(
                  candidate: candidate,
                  zoneName: 'Yunusobod',
                  distanceKm: 2,
                ),
              ],
              radiusKm: 5,
              onRadiusPressed: () {},
              onCandidateTap: (_) {},
              onMapClosed: () => closed = true,
              onViewModeChanged: (mode) => selectedMode = mode,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('5 km ichida'), findsOneWidget);
    expect(find.text('Atrofingizda 1 ta nomzod'), findsOneWidget);
    expect(find.bySemanticsLabel('Xaritani yopish'), findsOneWidget);
    expect(find.bySemanticsLabel('Xarita ko‘rinishi'), findsOneWidget);
    expect(find.byTooltip('Joylashuvimga qaytish'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Xaritani yopish'));
    await tester.pump();
    expect(closed, isTrue);

    await tester.tap(find.bySemanticsLabel('Katak ko‘rinishi'));
    await tester.pump();
    expect(selectedMode, DiscoveryViewMode.grid);

    expect(visibility.isVisible, isTrue);
    expect(find.byType(NearbyCandidatesMap), findsOneWidget);
  });
}
