import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate.dart';

sealed class DiscoveryState extends Equatable {
  const DiscoveryState();

  @override
  List<Object?> get props => [];
}

final class DiscoveryInitial extends DiscoveryState {
  const DiscoveryInitial();
}

final class DiscoveryLoading extends DiscoveryState {
  const DiscoveryLoading();
}

final class DiscoveryLoaded extends DiscoveryState {
  const DiscoveryLoaded({
    required this.candidates,
    this.selectedFilter,
  });

  final List<Candidate> candidates;
  final String? selectedFilter;

  @override
  List<Object?> get props => [candidates, selectedFilter];
}

final class DiscoveryError extends DiscoveryState {
  const DiscoveryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
