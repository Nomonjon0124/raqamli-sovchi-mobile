import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/discovery_filter.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/candidates_filter_bar.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({
    required DiscoveryFilter selectedFilter,
    required ValueChanged<DiscoveryFilter> onFilterSelected,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('uz'),
      home: Scaffold(
        body: CandidatesFilterBar(
          selectedFilter: selectedFilter,
          onFilterSelected: onFilterSelected,
        ),
      ),
    );
  }

  group('CandidatesFilterBar', () {
    testWidgets('renders the supported filters with ListView.separated', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(
          selectedFilter: DiscoveryFilter.matches,
          onFilterSelected: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Moslar'), findsOneWidget);
      expect(find.text('Tavsiyalar'), findsOneWidget);
      expect(find.text('Yaqinlar'), findsOneWidget);
      expect(find.text('Vakil'), findsNothing);
    });

    testWidgets('tapping unselected filter calls onFilterSelected', (
      tester,
    ) async {
      DiscoveryFilter? selected;

      await tester.pumpWidget(
        buildTestWidget(
          selectedFilter: DiscoveryFilter.matches,
          onFilterSelected: (filter) => selected = filter,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tavsiyalar'));
      await tester.pump();

      expect(selected, DiscoveryFilter.recommended);
    });

    testWidgets('tapping selected filter does not trigger onFilterSelected', (
      tester,
    ) async {
      DiscoveryFilter? selected;

      await tester.pumpWidget(
        buildTestWidget(
          selectedFilter: DiscoveryFilter.matches,
          onFilterSelected: (filter) => selected = filter,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Moslar'));
      await tester.pump();

      expect(selected, isNull);
    });
  });
}
