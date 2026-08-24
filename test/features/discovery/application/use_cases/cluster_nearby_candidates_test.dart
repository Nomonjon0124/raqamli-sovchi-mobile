import 'package:flutter_test/flutter_test.dart';
import 'package:raqamli_sovchi/features/discovery/application/use_cases/cluster_nearby_candidates.dart';
import 'package:raqamli_sovchi/features/discovery/domain/entities/geo_coordinates.dart';

import '../../support/candidate_factory.dart';

void main() {
  const clusterCandidates = ClusterNearbyCandidatesUseCase();
  const viewer = GeoCoordinates(latitude: 41.31, longitude: 69.24);

  test('groups close candidates and exposes only the privacy-zone center', () {
    final first = createCandidate(id: 'first');
    final second = createCandidate(
      id: 'second',
      latitude: '41.300400',
      longitude: '69.200400',
    );

    final result = clusterCandidates(
      candidates: [first, second],
      viewerLocation: viewer,
    );

    expect(result.clusters, hasLength(1));
    expect(result.clusters.single.count, 2);
    expect(result.items, hasLength(2));
    expect(
      result.clusters.single.center,
      isNot(const GeoCoordinates(latitude: 41.3, longitude: 69.2)),
    );
  });

  test('drops candidates with missing or invalid coordinates', () {
    final result = clusterCandidates(
      candidates: [
        createCandidate(id: 'missing', latitude: null),
        createCandidate(id: 'invalid', longitude: 'not-a-number'),
      ],
      viewerLocation: viewer,
    );

    expect(result.clusters, isEmpty);
    expect(result.items, isEmpty);
  });

  test('returns no map data for an invalid viewer location', () {
    final result = clusterCandidates(
      candidates: [createCandidate(id: 'candidate')],
      viewerLocation: const GeoCoordinates(latitude: 91, longitude: 69.24),
    );

    expect(result.clusters, isEmpty);
  });
}
