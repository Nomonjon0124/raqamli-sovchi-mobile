import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../../domain/entities/user_profile.dart';

enum DiscoveryStatus { initial, loading, success, empty, failure }

final class DiscoveryState extends Equatable {
  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.selectedFilter = DiscoveryFilter.matches,
    this.candidates = const [],
    this.errorMessage,
    this.myProfile,
  });

  final DiscoveryStatus status;
  final DiscoveryFilter selectedFilter;
  final List<Candidate> candidates;
  final String? errorMessage;
  final UserProfile? myProfile;

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    DiscoveryFilter? selectedFilter,
    List<Candidate>? candidates,
    String? errorMessage,
    bool clearError = false,
    UserProfile? myProfile,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      candidates: candidates ?? this.candidates,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      myProfile: myProfile ?? this.myProfile,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedFilter,
        candidates,
        errorMessage,
        myProfile,
      ];
}
