import 'package:equatable/equatable.dart';

import 'candidate.dart';
import 'geo_coordinates.dart';

final class NearbyCandidateCluster extends Equatable {
  const NearbyCandidateCluster({
    required this.id,
    required this.center,
    required this.candidates,
    required this.zoneName,
    required this.distanceKm,
  });

  final String id;
  final GeoCoordinates center;
  final List<Candidate> candidates;
  final String? zoneName;
  final double distanceKm;

  int get count => candidates.length;

  @override
  List<Object?> get props => [id, center, candidates, zoneName, distanceKm];
}

final class NearbyCandidateMapItem extends Equatable {
  const NearbyCandidateMapItem({
    required this.candidate,
    required this.zoneName,
    required this.distanceKm,
  });

  final Candidate candidate;
  final String? zoneName;
  final double distanceKm;

  @override
  List<Object?> get props => [candidate, zoneName, distanceKm];
}

final class NearbyCandidateClustering extends Equatable {
  const NearbyCandidateClustering({
    this.clusters = const [],
    this.items = const [],
  });

  final List<NearbyCandidateCluster> clusters;
  final List<NearbyCandidateMapItem> items;

  @override
  List<Object?> get props => [clusters, items];
}
