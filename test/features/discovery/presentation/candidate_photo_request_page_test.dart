import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/app/di/service_locator.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/pages/candidate_photo_request_page.dart';
import 'package:raqamli_sovchi/features/match/application/use_cases/create_photo_request.dart';
import 'package:raqamli_sovchi/features/match/domain/entities/match_request.dart';
import 'package:raqamli_sovchi/features/match/domain/entities/photo_request.dart';
import 'package:raqamli_sovchi/features/match/domain/repositories/photo_request_repository.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

void main() {
  late _FakePhotoRequestRepository repository;

  setUp(() async {
    await serviceLocator.reset();
    repository = _FakePhotoRequestRepository();
    serviceLocator.registerFactory<CreatePhotoRequestUseCase>(
      () => CreatePhotoRequestUseCase(repository),
    );
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('shows backend error in a snackbar', (tester) async {
    repository.result = const Left(
      Failure.validation(message: 'Backend xatosi'),
    );

    await tester.pumpWidget(_TestApp(child: _page()));
    await tester.enterText(find.byType(TextField), ' Salom ');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(repository.toProfile, 'candidate-1');
    expect(repository.note, ' Salom ');
    expect(find.text('Backend xatosi'), findsOneWidget);
  });

  testWidgets('opens success page after photo request is created', (
    tester,
  ) async {
    repository.result = Right(
      PhotoRequest(
        id: 'request-1',
        createdAt: DateTime.parse('2026-08-01T10:00:00Z'),
        updatedAt: DateTime.parse('2026-08-01T10:00:00Z'),
        status: MatchRequestStatus.pending,
        note: null,
      ),
    );

    await tester.pumpWidget(_TestApp(child: _page()));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Rasm ko‘rish uchun ruxsat so‘raldi'), findsOneWidget);
  });
}

Widget _page() => const CandidatePhotoRequestPage(
  candidateId: 'candidate-1',
  candidateName: 'Mohira',
  subtitle: 'Toshkent',
  imageUrl: null,
);

final class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}

final class _FakePhotoRequestRepository implements PhotoRequestRepository {
  Either<Failure, PhotoRequest> result = const Left(Failure.unknown());
  String? toProfile;
  String? note;

  @override
  Future<Either<Failure, PhotoRequest>> createRequest({
    required String toProfile,
    String? note,
  }) async {
    this.toProfile = toProfile;
    this.note = note;
    return result;
  }
}
