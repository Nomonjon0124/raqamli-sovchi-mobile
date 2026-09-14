import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/get_saved_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:raqamli_sovchi/features/match/application/use_cases/get_match_requests.dart';
import 'package:raqamli_sovchi/features/match/domain/repositories/match_request_repository.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/get_my_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:raqamli_sovchi/features/saved/presentation/pages/saved_page.dart';
import 'package:raqamli_sovchi/l10n/app_localizations.dart';

final class _MockDiscoveryRepository extends Mock
    implements DiscoveryRepository {}

final class _MockProfileRepository extends Mock implements ProfileRepository {}

final class _MockMatchRequestRepository extends Mock
    implements MatchRequestRepository {}

void main() {
  final serviceLocator = GetIt.instance;
  late _MockDiscoveryRepository discoveryRepository;

  setUp(() async {
    await serviceLocator.reset();
    discoveryRepository = _MockDiscoveryRepository();
    final profileRepository = _MockProfileRepository();
    final matchRequestRepository = _MockMatchRequestRepository();

    when(
      () => discoveryRepository.getSavedCandidates(),
    ).thenAnswer((_) async => const Right([]));

    serviceLocator.registerFactory<SavedBloc>(
      () => SavedBloc(
        getSavedCandidates: GetSavedCandidatesUseCase(discoveryRepository),
        getMyProfile: GetMyProfileUseCase(profileRepository),
        getMatchRequests: GetMatchRequestsUseCase(matchRequestRepository),
      ),
    );
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('hides unsupported waiting filter', (tester) async {
    await tester.pumpWidget(const _LocalizedTestApp(child: SavedPage()));
    await tester.pump();

    expect(find.text('Hammasi'), findsOneWidget);
    expect(find.text('Taklif yuborilgan'), findsOneWidget);
    expect(find.text('Javob kutilmoqda'), findsNothing);
  });
}

final class _LocalizedTestApp extends StatelessWidget {
  const _LocalizedTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('uz'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }
}
