import 'package:equatable/equatable.dart';

import '../../domain/entities/discovery_filter.dart';

sealed class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

final class DiscoveryFetchCandidatesRequested extends DiscoveryEvent {
  const DiscoveryFetchCandidatesRequested({
    this.filter = DiscoveryFilter.matches,
  });

  final DiscoveryFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class DiscoveryRefreshCandidatesRequested extends DiscoveryEvent {
  const DiscoveryRefreshCandidatesRequested();
}
