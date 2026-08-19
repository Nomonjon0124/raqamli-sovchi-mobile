import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/get_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/discovery_filter.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_bloc.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_event.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_state.dart';

void main() {
  const testCandidate = Candidate(
    id: 'candidate-1',
    firstName: 'Mohira',
    lastName: 'Ravshanova',
    middleName: null,
    age: 23,
    isSaved: false,
    birthYear: 2001,
    weight: 55,
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
    regionId: null,
    regionName: 'Toshkent',
    districtId: null,
    districtName: 'Yunusobod',
    educationLevelID: null,
    educationLevelName: 'TATU',
    healthStatusId: null,
    healthStatusName: null,
    martialStatusId: null,
    martialStatusName: null,
    photosInfo: null,
  );

  group('DiscoveryBloc', () {
    test('initial state has matches filter and initial status', () {
      final repository = _FakeDiscoveryRepository(candidates: const [testCandidate]);
      final bloc = DiscoveryBloc(getCandidates: GetCandidatesUseCase(repository));
      expect(bloc.state.status, DiscoveryStatus.initial);
      expect(bloc.state.selectedFilter, DiscoveryFilter.matches);
      expect(bloc.state.candidates, isEmpty);
    });

    blocTest<DiscoveryBloc, DiscoveryState>(
      'emits [loading, success] on initial fetch with matches filter',
      build: () => DiscoveryBloc(
        getCandidates: GetCandidatesUseCase(
          _FakeDiscoveryRepository(candidates: const [testCandidate]),
        ),
      ),
      act: (bloc) => bloc.add(const DiscoveryFetchCandidatesRequested()),
      expect: () => [
        const DiscoveryState(
          status: DiscoveryStatus.loading,
          selectedFilter: DiscoveryFilter.matches,
        ),
        const DiscoveryState(
          status: DiscoveryStatus.success,
          selectedFilter: DiscoveryFilter.matches,
          candidates: [testCandidate],
        ),
      ],
    );

    blocTest<DiscoveryBloc, DiscoveryState>(
      'transitioning from representative to recommended never emits matches filter',
      seed: () => const DiscoveryState(
        status: DiscoveryStatus.success,
        selectedFilter: DiscoveryFilter.representative,
        candidates: [testCandidate],
      ),
      build: () => DiscoveryBloc(
        getCandidates: GetCandidatesUseCase(
          _FakeDiscoveryRepository(candidates: const [testCandidate]),
        ),
      ),
      act: (bloc) => bloc.add(
        const DiscoveryFetchCandidatesRequested(
          filter: DiscoveryFilter.recommended,
        ),
      ),
      expect: () => [
        const DiscoveryState(
          status: DiscoveryStatus.loading,
          selectedFilter: DiscoveryFilter.recommended,
          candidates: [testCandidate],
        ),
        const DiscoveryState(
          status: DiscoveryStatus.success,
          selectedFilter: DiscoveryFilter.recommended,
          candidates: [testCandidate],
        ),
      ],
    );

    blocTest<DiscoveryBloc, DiscoveryState>(
      'preserves selected filter on error',
      build: () => DiscoveryBloc(
        getCandidates: GetCandidatesUseCase(
          _FakeDiscoveryRepository(
            failure: const Failure.server(message: 'Server error'),
          ),
        ),
      ),
      act: (bloc) => bloc.add(
        const DiscoveryFetchCandidatesRequested(
          filter: DiscoveryFilter.nearby,
        ),
      ),
      expect: () => [
        const DiscoveryState(
          status: DiscoveryStatus.loading,
          selectedFilter: DiscoveryFilter.nearby,
        ),
        const DiscoveryState(
          status: DiscoveryStatus.failure,
          selectedFilter: DiscoveryFilter.nearby,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<DiscoveryBloc, DiscoveryState>(
      'ignores repeated fetch if filter is already selected and loaded',
      seed: () => const DiscoveryState(
        status: DiscoveryStatus.success,
        selectedFilter: DiscoveryFilter.recommended,
        candidates: [testCandidate],
      ),
      build: () => DiscoveryBloc(
        getCandidates: GetCandidatesUseCase(
          _FakeDiscoveryRepository(candidates: const [testCandidate]),
        ),
      ),
      act: (bloc) => bloc.add(
        const DiscoveryFetchCandidatesRequested(
          filter: DiscoveryFilter.recommended,
        ),
      ),
      expect: () => <DiscoveryState>[],
    );

    blocTest<DiscoveryBloc, DiscoveryState>(
      'refresh uses current selected filter',
      seed: () => const DiscoveryState(
        status: DiscoveryStatus.success,
        selectedFilter: DiscoveryFilter.representative,
        candidates: [testCandidate],
      ),
      build: () => DiscoveryBloc(
        getCandidates: GetCandidatesUseCase(
          _FakeDiscoveryRepository(candidates: const [testCandidate]),
        ),
      ),
      act: (bloc) => bloc.add(const DiscoveryRefreshCandidatesRequested()),
      expect: () => [
        const DiscoveryState(
          status: DiscoveryStatus.loading,
          selectedFilter: DiscoveryFilter.representative,
          candidates: [testCandidate],
        ),
        const DiscoveryState(
          status: DiscoveryStatus.success,
          selectedFilter: DiscoveryFilter.representative,
          candidates: [testCandidate],
        ),
      ],
    );
  });
}

final class _FakeDiscoveryRepository implements DiscoveryRepository {
  _FakeDiscoveryRepository({this.candidates = const [], this.failure});

  final List<Candidate> candidates;
  final Failure? failure;

  @override
  Future<Either<Failure, List<Candidate>>> getCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
  }) async {
    if (failure != null) return Left(failure!);
    return Right(candidates);
  }
}
