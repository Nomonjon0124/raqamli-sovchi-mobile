import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_report_page.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_report_submitted_page.dart';
import 'package:raqamli_sovchi/features/moderation/application/use_cases/create_complaint.dart';
import 'package:raqamli_sovchi/features/moderation/domain/entities/complaint.dart';
import 'package:raqamli_sovchi/features/moderation/domain/repositories/complaint_repository.dart';
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
    userId: 'user-uuid-1',
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
        CandidateReportPage(
          candidate: dummyCandidate,
          candidateName: 'Mohira R., 23',
          createComplaintUseCase: CreateComplaintUseCase(
            _FakeComplaintRepository(),
          ),
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

    expect(find.text('Odobsiz so‘z'), findsOneWidget);
    expect(find.text('Soxta profil'), findsOneWidget);
    expect(find.text('Firibgarlik'), findsOneWidget);
    expect(find.text('Spam va reklama'), findsOneWidget);
    expect(find.text('Noto‘g‘ri ma’lumot'), findsOneWidget);
    expect(find.text('Haqorat va tahdid'), findsOneWidget);
    expect(find.text('Nikoh niyati yo‘q'), findsOneWidget);
    expect(find.text('Boshqa sabab'), findsOneWidget);
    expect(find.text('Qo‘shimcha izoh (ixtiyoriy)'), findsOneWidget);
    expect(find.text('Shikoyatni yuborish'), findsOneWidget);

    // Verify avatar is blurred when blurPhotos is true
    expect(find.byType(ImageFiltered), findsOneWidget);
  });

  testWidgets(
    'selecting a reason enables submit button and navigates to submitted page',
    (tester) async {
      final repository = _FakeComplaintRepository();

      await tester.pumpWidget(
        _testApp(
          CandidateReportPage(
            candidate: dummyCandidate,
            candidateName: 'Mohira R., 23',
            createComplaintUseCase: CreateComplaintUseCase(repository),
          ),
        ),
      );

      await tester.tap(find.text('Odobsiz so‘z'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField),
        '  Qo‘pol so‘z ishlatdi  ',
      );
      await tester.tap(find.text('Shikoyatni yuborish'));
      await tester.pumpAndSettle();

      expect(repository.toUserId, 'user-uuid-1');
      expect(repository.reason, ComplaintReason.abusiveLanguage);
      expect(repository.message, 'Qo‘pol so‘z ishlatdi');
      expect(find.byType(CandidateReportSubmittedPage), findsOneWidget);
      expect(find.text('Shikoyat yuborildi'), findsOneWidget);
      expect(find.text('#complaint-1'), findsOneWidget);
    },
  );

  testWidgets('shows backend error when report submit fails', (tester) async {
    final repository = _FakeComplaintRepository()
      ..result = const Left(
        Failure.validation(message: 'Shikoyat sababi noto‘g‘ri'),
      );

    await tester.pumpWidget(
      _testApp(
        CandidateReportPage(
          candidate: dummyCandidate,
          candidateName: 'Mohira R., 23',
          createComplaintUseCase: CreateComplaintUseCase(repository),
        ),
      ),
    );

    await tester.tap(find.text('Odobsiz so‘z'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shikoyatni yuborish'));
    await tester.pumpAndSettle();

    expect(find.byType(CandidateReportSubmittedPage), findsNothing);
    expect(find.text('Shikoyat sababi noto‘g‘ri'), findsOneWidget);
  });
}

Widget _testApp(Widget child) => MaterialApp(
  locale: const Locale('uz'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

final class _FakeComplaintRepository implements ComplaintRepository {
  Either<Failure, Complaint> result = Right<Failure, Complaint>(
    Complaint(
      id: 'complaint-1',
      reason: ComplaintReason.abusiveLanguage,
      reasonLabel: 'Odobsiz so‘z',
      status: ComplaintStatus.pending,
      statusLabel: 'Ko‘rib chiqilmoqda',
      createdAt: DateTime.parse('2026-09-04T10:00:00Z'),
      updatedAt: DateTime.parse('2026-09-04T10:00:00Z'),
    ),
  );
  String? toUserId;
  ComplaintReason? reason;
  String? message;

  @override
  Future<Either<Failure, Complaint>> createComplaint({
    required String toUserId,
    required ComplaintReason reason,
    String? message,
  }) async {
    this.toUserId = toUserId;
    this.reason = reason;
    this.message = message;
    return result;
  }
}
