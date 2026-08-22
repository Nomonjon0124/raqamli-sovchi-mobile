import 'dart:math' as math;

import '../../domain/entities/candidate.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/nearby_candidate_cluster.dart';

final class ClusterNearbyCandidatesUseCase {
  const ClusterNearbyCandidatesUseCase();

  static const _kilometersPerLatitudeDegree = 111.32;

  NearbyCandidateClustering call({
    required List<Candidate> candidates,
    required GeoCoordinates viewerLocation,
    double privacyZoneKm = 2,
  }) {
    if (!viewerLocation.isValid || privacyZoneKm <= 0) {
      return const NearbyCandidateClustering();
    }

    final latitudeStep = privacyZoneKm / _kilometersPerLatitudeDegree;
    final longitudeScale = math
        .cos(viewerLocation.latitude * math.pi / 180)
        .abs()
        .clamp(0.2, 1.0);
    final longitudeStep =
        privacyZoneKm / (_kilometersPerLatitudeDegree * longitudeScale);
    final buckets = <String, List<Candidate>>{};

    for (final candidate in candidates) {
      final latitude = double.tryParse(candidate.latitude ?? '');
      final longitude = double.tryParse(candidate.longitude ?? '');
      if (latitude == null || longitude == null) continue;
      final coordinates = GeoCoordinates(
        latitude: latitude,
        longitude: longitude,
      );
      if (!coordinates.isValid) continue;

      final latitudeCell = (latitude / latitudeStep).floor();
      final longitudeCell = (longitude / longitudeStep).floor();
      final key = '$latitudeCell:$longitudeCell';
      buckets.putIfAbsent(key, () => <Candidate>[]).add(candidate);
    }

    final clusters =
        buckets.entries
            .map((entry) {
              final parts = entry.key.split(':');
              final latitudeCell = int.parse(parts.first);
              final longitudeCell = int.parse(parts.last);
              final center = GeoCoordinates(
                latitude: (latitudeCell + 0.5) * latitudeStep,
                longitude: (longitudeCell + 0.5) * longitudeStep,
              );
              return NearbyCandidateCluster(
                id: entry.key,
                center: center,
                candidates: List<Candidate>.unmodifiable(entry.value),
                zoneName: _mostCommonZoneName(entry.value),
                distanceKm: _distanceKm(viewerLocation, center),
              );
            })
            .toList(growable: false)
          ..sort((left, right) => left.distanceKm.compareTo(right.distanceKm));

    final immutableClusters = List<NearbyCandidateCluster>.unmodifiable(
      clusters,
    );
    final items = <NearbyCandidateMapItem>[
      for (final cluster in immutableClusters)
        for (final candidate in cluster.candidates)
          NearbyCandidateMapItem(
            candidate: candidate,
            zoneName: cluster.zoneName,
            distanceKm: cluster.distanceKm,
          ),
    ];
    return NearbyCandidateClustering(
      clusters: immutableClusters,
      items: List<NearbyCandidateMapItem>.unmodifiable(items),
    );
  }

  String? _mostCommonZoneName(List<Candidate> candidates) {
    final counts = <String, int>{};
    for (final candidate in candidates) {
      final name = candidate.districtName?.trim().isNotEmpty == true
          ? candidate.districtName!.trim()
          : candidate.regionName?.trim();
      if (name == null || name.isEmpty) continue;
      counts.update(name, (count) => count + 1, ifAbsent: () => 1);
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((left, right) {
      if (right.value > left.value) return right;
      if (right.value == left.value && right.key.compareTo(left.key) < 0) {
        return right;
      }
      return left;
    }).key;
  }

  double _distanceKm(GeoCoordinates from, GeoCoordinates to) {
    const earthRadiusKm = 6371.0;
    final latitudeDelta = (to.latitude - from.latitude) * math.pi / 180;
    final longitudeDelta = (to.longitude - from.longitude) * math.pi / 180;
    final fromLatitude = from.latitude * math.pi / 180;
    final toLatitude = to.latitude * math.pi / 180;
    final a =
        math.sin(latitudeDelta / 2) * math.sin(latitudeDelta / 2) +
        math.cos(fromLatitude) *
            math.cos(toLatitude) *
            math.sin(longitudeDelta / 2) *
            math.sin(longitudeDelta / 2);
    final safeA = a.clamp(0.0, 1.0);
    return earthRadiusKm *
        2 *
        math.atan2(math.sqrt(safeA), math.sqrt(1 - safeA));
  }
}
