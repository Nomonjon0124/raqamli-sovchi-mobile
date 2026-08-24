import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/candidate_detail_incomplete_profile_card.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/widgets/candidate_detail_information_sections.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  testWidgets('renders only available candidate information', (tester) async {
    await tester.pumpWidget(
      _testApp(CandidateDetailInformationSections(candidate: _candidate())),
    );

    expect(find.text('Asosiy ma’lumotlar'), findsOneWidget);
    expect(find.text('2003 · 23 yosh'), findsOneWidget);
    expect(find.text('Toshkent, Yunusobod'), findsOneWidget);
    expect(find.text('165 sm'), findsOneWidget);
    expect(find.text('54 kg'), findsOneWidget);
    expect(find.text('Ta’lim va ish'), findsOneWidget);
    expect(find.text('Oliy'), findsOneWidget);
    expect(find.text('Sog‘lig‘i'), findsOneWidget);
  });

  testWidgets('shows incomplete profile card when key details are missing', (
    tester,
  ) async {
    final candidate = _candidate(educationLevelName: null);

    await tester.pumpWidget(
      _testApp(CandidateDetailIncompleteProfileCard(candidate: candidate)),
    );

    expect(find.text('Anketa to‘liq emas'), findsOneWidget);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

Candidate _candidate({String? educationLevelName = 'Oliy'}) => Candidate(
  id: 'candidate-id',
  firstName: 'Mohira',
  lastName: 'R.',
  middleName: null,
  age: 23,
  isSaved: false,
  birthYear: 2003,
  height: 165,
  weight: 54,
  hasChildren: false,
  childrenCount: 0,
  bio: null,
  voiceIntro: null,
  latitude: null,
  longitude: null,
  blurPhotos: true,
  phoneNumber: null,
  email: null,
  isVerified: true,
  regionId: 'toshkent',
  regionName: 'Toshkent',
  districtId: 'yunusobod',
  districtName: 'Yunusobod',
  educationLevelID: 'higher',
  educationLevelName: educationLevelName,
  healthStatusId: 'healthy',
  healthStatusName: 'Sog‘lom',
  martialStatusId: 'single',
  martialStatusName: 'Turmush qurmagan',
  photosInfo: const [],
);
