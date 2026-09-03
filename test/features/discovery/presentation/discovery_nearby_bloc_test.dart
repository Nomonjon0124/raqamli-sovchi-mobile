import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/core/errors/either.dart';
import 'package:raqamli_sovchi/core/errors/failure.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/check_location_access.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/cluster_nearby_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/get_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/open_location_settings.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/request_current_location.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/update_profile_location.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/candidate.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/discovery_filter.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/geo_coordinates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/location_access_status.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/discovery_repository.dart';
import 'package:raqamli_sovchi/features/discovery/domain/repositories/location_repository.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_bloc.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_event.dart';
import 'package:raqamli_sovchi/features/discovery/presentation/bloc/discovery_state.dart';
import 'package:raqamli_sovchi/features/profile/domain/entities/user_profile.dart';
import 'package:raqamli_sovchi/features/profile/domain/repositories/profile_repository.dart';

import '../support/candidate_factory.dart';

void main() {
  test(
    'nearby selection requests permission before any network call',
    () async {
      final locationRepository = _LocationRepository(
        accessStatus: LocationAccessStatus.denied,
      );
      final discoveryRepository = _DiscoveryRepository();
      final profileRepository = _ProfileRepository();
      final bloc = _buildBloc(
        locationRepository: locationRepository,
        discoveryRepository: discoveryRepository,
        profileRepository: profileRepository,
      );
      addTearDown(bloc.close);

      final permissionState = bloc.stream.firstWhere(
        (state) => state.status == DiscoveryStatus.permissionRequired,
      );
      bloc.add(
        const DiscoveryFetchCandidatesRequested(filter: DiscoveryFilter.nearby),
      );

      expect(
        (await permissionState).locationAccessStatus,
        LocationAccessStatus.denied,
      );
      expect(discoveryRepository.requests, isEmpty);
      expect(profileRepository.updatedLocations, isEmpty);
    },
  );

  test(
    'map mode updates location then fetches a five kilometre page',
    () async {
      final locationRepository = _LocationRepository(
        accessStatus: LocationAccessStatus.granted,
      );
      final discoveryRepository = _DiscoveryRepository(
        candidates: [createCandidate(id: 'candidate-1')],
      );
      final profileRepository = _ProfileRepository();
      final bloc = _buildBloc(
        locationRepository: locationRepository,
        discoveryRepository: discoveryRepository,
        profileRepository: profileRepository,
      );
      addTearDown(bloc.close);

      final gridReady = bloc.stream.firstWhere(
        (state) => state.status == DiscoveryStatus.success,
      );
      bloc.add(
        const DiscoveryFetchCandidatesRequested(filter: DiscoveryFilter.nearby),
      );
      await gridReady;

      final mapReady = bloc.stream.firstWhere(
        (state) =>
            state.status == DiscoveryStatus.success &&
            state.viewMode == DiscoveryViewMode.map,
      );
      bloc.add(const DiscoveryViewModeChanged(DiscoveryViewMode.map));
      final mapState = await mapReady;

      expect(profileRepository.updatedLocations, hasLength(2));
      expect(discoveryRepository.requests, hasLength(2));
      expect(discoveryRepository.requests.last.filter, DiscoveryFilter.nearby);
      expect(discoveryRepository.requests.last.pageSize, 100);
      expect(discoveryRepository.requests.last.radiusKm, 5);
      expect(mapState.nearbyClusters, hasLength(1));
      expect(mapState.nearbyMapItems.single.candidate.id, 'candidate-1');
    },
  );

  test(
    'changing radius reuses location and only refetches candidates',
    () async {
      final locationRepository = _LocationRepository(
        accessStatus: LocationAccessStatus.granted,
      );
      final discoveryRepository = _DiscoveryRepository(
        candidates: [createCandidate(id: 'candidate-1')],
      );
      final profileRepository = _ProfileRepository();
      final bloc = _buildBloc(
        locationRepository: locationRepository,
        discoveryRepository: discoveryRepository,
        profileRepository: profileRepository,
      );
      addTearDown(bloc.close);

      final initialReady = bloc.stream.firstWhere(
        (state) => state.status == DiscoveryStatus.success,
      );
      bloc.add(
        const DiscoveryFetchCandidatesRequested(filter: DiscoveryFilter.nearby),
      );
      await initialReady;

      final radiusReloaded = bloc.stream
          .where((state) => state.nearbyRadiusKm == 25)
          .skipWhile((state) => state.status != DiscoveryStatus.loading)
          .firstWhere((state) => state.status == DiscoveryStatus.success);
      bloc.add(
        const DiscoveryNearbySettingsSaved(
          radiusKm: 25,
          isProfileVisible: true,
          audience: NearbyVisibilityAudience.highCompatibility,
        ),
      );
      final result = await radiusReloaded;

      expect(result.nearbyRadiusKm, 25);
      expect(profileRepository.updatedLocations, hasLength(1));
      expect(discoveryRepository.requests, hasLength(2));
      expect(discoveryRepository.requests.last.radiusKm, 25);

      final visibilityUpdated = bloc.stream.firstWhere(
        (state) =>
            !state.isNearbyProfileVisible &&
            state.nearbyVisibilityAudience == NearbyVisibilityAudience.all,
      );
      bloc.add(
        const DiscoveryNearbySettingsSaved(
          radiusKm: 25,
          isProfileVisible: false,
          audience: NearbyVisibilityAudience.all,
        ),
      );
      await visibilityUpdated;

      expect(profileRepository.updatedLocations, hasLength(1));
      expect(discoveryRepository.requests, hasLength(2));
    },
  );
}

DiscoveryBloc _buildBloc({
  required _LocationRepository locationRepository,
  required _DiscoveryRepository discoveryRepository,
  required _ProfileRepository profileRepository,
}) {
  return DiscoveryBloc(
    getCandidates: GetCandidatesUseCase(discoveryRepository),
    checkLocationAccess: CheckLocationAccessUseCase(locationRepository),
    requestCurrentLocation: RequestCurrentLocationUseCase(locationRepository),
    openLocationSettings: OpenLocationSettingsUseCase(locationRepository),
    updateProfileLocation: UpdateProfileLocationUseCase(profileRepository),
    clusterNearbyCandidates: const ClusterNearbyCandidatesUseCase(),
  );
}

final class _LocationRepository implements LocationRepository {
  _LocationRepository({required this.accessStatus});

  LocationAccessStatus accessStatus;
  final coordinates = const GeoCoordinates(
    latitude: 41.311081,
    longitude: 69.240562,
  );

  @override
  Future<LocationAccessStatus> checkAccess() async => accessStatus;

  @override
  Future<bool> openSettings(LocationAccessStatus status) async => true;

  @override
  Future<Either<Failure, GeoCoordinates>> requestCurrentLocation() async =>
      Right(coordinates);
}

final class _DiscoveryRequest {
  const _DiscoveryRequest({
    required this.pageSize,
    required this.filter,
    required this.radiusKm,
  });

  final int pageSize;
  final DiscoveryFilter filter;
  final double? radiusKm;
}

final class _DiscoveryRepository implements DiscoveryRepository {
  _DiscoveryRepository({this.candidates = const []});

  final List<Candidate> candidates;
  final requests = <_DiscoveryRequest>[];

  @override
  Future<Either<Failure, List<Candidate>>> getCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
    double? radiusKm,
  }) async {
    requests.add(
      _DiscoveryRequest(pageSize: pageSize, filter: filter, radiusKm: radiusKm),
    );
    return Right(candidates);
  }

  @override
  Future<Either<Failure, Candidate>> getCandidate(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<Candidate>>> getSavedCandidates() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> saveCandidate(String id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> unsaveCandidate(String id) =>
      throw UnimplementedError();
}

final class _ProfileRepository implements ProfileRepository {
  final updatedLocations = <GeoCoordinates>[];

  @override
  Future<Either<Failure, UserProfile>> getMyProfile() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    updatedLocations.add(
      GeoCoordinates(latitude: latitude, longitude: longitude),
    );
    return const Right(true);
  }
}
