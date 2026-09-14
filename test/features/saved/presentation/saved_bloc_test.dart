import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/get_saved_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:raqamli_sovchi/features/match/application/use_cases/get_match_requests.dart';
import 'package:raqamli_sovchi/features/match/domain/entities/match_request.dart';
import 'package:raqamli_sovchi/features/match/domain/repositories/match_request_repository.dart';
import 'package:raqamli_sovchi/features/profile/application/use_cases/get_my_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';
import 'package:raqamli_sovchi/features/saved/presentation/bloc/saved_bloc.dart';
import 'package:raqamli_sovchi/features/saved/presentation/bloc/saved_event.dart';
import 'package:raqamli_sovchi/features/saved/presentation/bloc/saved_state.dart';

final class _MockDiscoveryRepository extends Mock
    implements DiscoveryRepository {}

final class _MockProfileRepository extends Mock implements ProfileRepository {}

final class _MockMatchRequestRepository extends Mock
    implements MatchRequestRepository {}

void main() {
  const profile = UserProfile(
    id: 'profile-1',
    hasAnsweredTest: true,
    answeredQuestionsCount: 10,
  );
  final candidate = _candidate('candidate-1');
  final otherCandidate = _candidate('candidate-2');
  final request = _matchRequest('candidate-1');

  late _MockDiscoveryRepository discoveryRepository;
  late _MockProfileRepository profileRepository;
  late _MockMatchRequestRepository matchRequestRepository;

  setUp(() {
    discoveryRepository = _MockDiscoveryRepository();
    profileRepository = _MockProfileRepository();
    matchRequestRepository = _MockMatchRequestRepository();

    when(
      () => discoveryRepository.getSavedCandidates(),
    ).thenAnswer((_) async => Right([candidate, otherCandidate]));
    when(
      () => profileRepository.getMyProfile(),
    ).thenAnswer((_) async => const Right(profile));
    when(
      () => matchRequestRepository.getRequests(
        fromProfile: any(named: 'fromProfile'),
        toProfile: any(named: 'toProfile'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async => Right([request]));
  });

  SavedBloc buildBloc() => SavedBloc(
    getSavedCandidates: GetSavedCandidatesUseCase(discoveryRepository),
    getMyProfile: GetMyProfileUseCase(profileRepository),
    getMatchRequests: GetMatchRequestsUseCase(matchRequestRepository),
  );

  blocTest<SavedBloc, SavedState>(
    'loads all saved candidates without profile or match requests',
    build: buildBloc,
    act: (bloc) => bloc.add(const SavedLoadRequested()),
    expect: () => [
      const SavedState(status: SavedStatus.loading, errorMessage: ''),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate, otherCandidate],
        errorMessage: '',
      ),
    ],
    verify: (_) {
      verify(() => discoveryRepository.getSavedCandidates()).called(1);
      verifyNever(() => profileRepository.getMyProfile());
      verifyNever(
        () => matchRequestRepository.getRequests(
          fromProfile: any(named: 'fromProfile'),
          toProfile: any(named: 'toProfile'),
          status: any(named: 'status'),
        ),
      );
    },
  );

  blocTest<SavedBloc, SavedState>(
    'caches saved data and sends pending status for invited filter',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SavedLoadRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SavedFilterChanged(SavedRequestFilter.invited));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SavedFilterChanged(SavedRequestFilter.all));
    },
    expect: () => [
      const SavedState(status: SavedStatus.loading, errorMessage: ''),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate, otherCandidate],
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate, otherCandidate],
        filter: SavedRequestFilter.invited,
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.loading,
        candidates: [candidate, otherCandidate],
        filter: SavedRequestFilter.invited,
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate],
        filter: SavedRequestFilter.invited,
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate],
        filter: SavedRequestFilter.all,
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.loading,
        candidates: [candidate],
        filter: SavedRequestFilter.all,
        errorMessage: '',
      ),
      SavedState(
        status: SavedStatus.success,
        candidates: [candidate, otherCandidate],
        filter: SavedRequestFilter.all,
        errorMessage: '',
      ),
    ],
    verify: (_) {
      verify(() => discoveryRepository.getSavedCandidates()).called(1);
      verify(() => profileRepository.getMyProfile()).called(1);
      verify(
        () => matchRequestRepository.getRequests(
          fromProfile: 'profile-1',
          toProfile: null,
          status: MatchRequestStatus.pending,
        ),
      ).called(1);
    },
  );

  blocTest<SavedBloc, SavedState>(
    'ignores the unsupported waiting filter',
    build: buildBloc,
    act: (bloc) =>
        bloc.add(const SavedFilterChanged(SavedRequestFilter.waiting)),
    expect: () => const [],
    verify: (_) {
      verifyNever(() => discoveryRepository.getSavedCandidates());
      verifyNever(() => profileRepository.getMyProfile());
      verifyNever(
        () => matchRequestRepository.getRequests(
          fromProfile: any(named: 'fromProfile'),
          toProfile: any(named: 'toProfile'),
          status: any(named: 'status'),
        ),
      );
    },
  );

  blocTest<SavedBloc, SavedState>(
    'force refresh clears cache and reloads current filter',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const SavedLoadRequested());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const SavedLoadRequested(forceRefresh: true));
    },
    verify: (_) {
      verify(() => discoveryRepository.getSavedCandidates()).called(2);
    },
  );

  blocTest<SavedBloc, SavedState>(
    'emits failure when match requests cannot be loaded',
    build: () {
      when(
        () => matchRequestRepository.getRequests(
          fromProfile: any(named: 'fromProfile'),
          toProfile: any(named: 'toProfile'),
          status: any(named: 'status'),
        ),
      ).thenAnswer(
        (_) async => const Left(Failure.server(message: 'Request error')),
      );
      return buildBloc();
    },
    act: (bloc) =>
        bloc.add(const SavedFilterChanged(SavedRequestFilter.invited)),
    expect: () => [
      const SavedState(filter: SavedRequestFilter.invited),
      const SavedState(
        status: SavedStatus.loading,
        filter: SavedRequestFilter.invited,
        errorMessage: '',
      ),
      const SavedState(
        status: SavedStatus.failure,
        filter: SavedRequestFilter.invited,
        errorMessage: 'Request error',
      ),
    ],
  );
}

Candidate _candidate(String id) => Candidate(
  id: id,
  firstName: id,
  lastName: '',
  middleName: '',
  age: null,
  isSaved: true,
  birthYear: null,
  height: null,
  weight: null,
  hasChildren: null,
  childrenCount: null,
  bio: null,
  voiceIntro: null,
  latitude: null,
  longitude: null,
  blurPhotos: false,
  phoneNumber: null,
  email: null,
  isVerified: false,
  regionId: null,
  regionName: null,
  districtId: null,
  districtName: null,
  educationLevelID: null,
  educationLevelName: null,
  professionId: null,
  professionName: null,
  healthStatusId: null,
  healthStatusName: null,
  martialStatusId: null,
  martialStatusName: null,
  photosInfo: const [],
);

MatchRequest _matchRequest(String toProfileId) => MatchRequest(
  id: 'request-1',
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
  status: MatchRequestStatus.pending,
  visibilityScope: MatchRequestVisibilityScope.onlyThisUser,
  note: null,
  fromProfileId: 'profile-1',
  toProfileId: toProfileId,
);
