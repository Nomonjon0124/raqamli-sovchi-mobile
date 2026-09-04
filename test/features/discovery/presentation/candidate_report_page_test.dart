import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_report_page.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_report_submitted_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  const dummyCandidate = Candidate(
    id: 'c-1',
    firstName: 'Mohira',
    lastName: 'R.',
    middleName: null,
    age: 23,
    isSaved: false,
    birthYear: 2003,
    height: 165,
    weight: 55,
    hasChildren: false,
    childrenCount: null,
    bio: null,
    voiceIntro: null,
    latitude: null,
    longitude: null,
    blurPhotos: true,
    phoneNumber: null,
    email: null,
    isVerified: true,
    regionId: null,
    regionName: null,
    districtId: null,
    districtName: null,
    educationLevelID: null,
    educationLevelName: null,
    healthStatusId: null,
    healthStatusName: null,
    martialStatusId: null,
    martialStatusName: null,
    photosInfo: [],
  );

  testWidgets('renders Figma report page elements and blurs avatar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const CandidateReportPage(
          candidate: dummyCandidate,
          candidateName: 'Mohira R., 23',
        ),
      ),
    );

    expect(find.text('Nima bo‘ldi?'), findsOneWidget);
    expect(
      find.text('Suhbat tarixi bizda saqlanadi, tekshirishga yordam beradi.'),
      findsOneWidget,
    );
    expect(find.text('Mohira R., 23'), findsOneWidget);
    expect(find.text('Shikoyat shu profil ustidan'), findsOneWidget);
    expect(find.text('Sabab'), findsOneWidget);

    expect(find.text('Odobsiz so‘z yoki rasm'), findsOneWidget);
    expect(find.text('Yolg‘on ma’lumot yoki soxta profil'), findsOneWidget);
    expect(find.text('Nikoh niyati yo‘q'), findsOneWidget);
    expect(find.text('Moliyaviy firibgarlik'), findsOneWidget);
    expect(find.text('Boshqa sabab'), findsOneWidget);
    expect(find.text('Qo‘shimcha izoh (ixtiyoriy)'), findsOneWidget);
    expect(find.text('Shikoyatni yuborish'), findsOneWidget);

    // Verify avatar is blurred when blurPhotos is true
    expect(find.byType(ImageFiltered), findsOneWidget);
  });

  testWidgets(
    'selecting a reason enables submit button and navigates to submitted page',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          const CandidateReportPage(
            candidate: dummyCandidate,
            candidateName: 'Mohira R., 23',
          ),
        ),
      );

      // Tap on a reason
      await tester.tap(find.text('Odobsiz so‘z yoki rasm'));
      await tester.pumpAndSettle();

      // Tap submit button
      await tester.tap(find.text('Shikoyatni yuborish'));
      await tester.pumpAndSettle();

      // Verify CandidateReportSubmittedPage is shown
      expect(find.byType(CandidateReportSubmittedPage), findsOneWidget);
      expect(find.text('Shikoyat yuborildi'), findsOneWidget);
    },
  );
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);
