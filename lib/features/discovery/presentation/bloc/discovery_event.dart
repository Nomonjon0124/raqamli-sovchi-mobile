import 'package:equatable/equatable.dart';

sealed class DiscoveryEvent extends Equatable {
  const DiscoveryEvent();

  @override
  List<Object?> get props => [];
}

final class DiscoveryFetchCandidatesRequested extends DiscoveryEvent {
  const DiscoveryFetchCandidatesRequested({this.filter});

  final String? filter;

  @override
  List<Object?> get props => [filter];
}

final class DiscoveryRefreshCandidatesRequested extends DiscoveryEvent {
  const DiscoveryRefreshCandidatesRequested();
}
