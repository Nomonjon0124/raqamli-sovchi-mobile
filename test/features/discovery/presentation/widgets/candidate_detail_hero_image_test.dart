import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/candidate_detail_hero_image.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('clips blurred hero image to its fixed bounds', (tester) async {
    await tester.pumpWidget(
      _testApp(
        const CandidateDetailHeroImage(imageUrl: null, shouldBlur: true),
      ),
    );

    final clip = find.byKey(const ValueKey('candidate-detail-hero-clip'));
    expect(clip, findsOneWidget);
    expect(tester.getSize(clip).height, 330);
    expect(find.byType(ImageFiltered), findsOneWidget);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);
