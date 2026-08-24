import 'package:equatable/equatable.dart';

import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/location_access_status.dart';
import '../../domain/entities/nearby_candidate_cluster.dart';
import '../../domain/entities/user_profile.dart';

enum DiscoveryStatus {
  initial,
  loading,
  success,
  empty,
  permissionRequired,
  failure,
}

enum DiscoveryViewMode { grid, map }

enum NearbyVisibilityAudience { all, highCompatibility, representedOnly }

final class DiscoveryState extends Equatable {
  const DiscoveryState({
    this.status = DiscoveryStatus.initial,
    this.selectedFilter = DiscoveryFilter.matches,
    this.candidates = const [],
    this.errorMessage,
    this.myProfile,
    this.viewMode = DiscoveryViewMode.grid,
    this.locationAccessStatus = LocationAccessStatus.unknown,
    this.currentLocation,
    this.nearbyClusters = const [],
    this.nearbyMapItems = const [],
    this.isLocationOperationInProgress = false,
    this.nearbyRadiusKm = 5,
    this.isNearbyProfileVisible = true,
    this.nearbyVisibilityAudience = NearbyVisibilityAudience.highCompatibility,
    this.areNearbyNotificationsEnabled = true,
  });

  final DiscoveryStatus status;
  final DiscoveryFilter selectedFilter;
  final List<Candidate> candidates;
  final String? errorMessage;
  final UserProfile? myProfile;
  final DiscoveryViewMode viewMode;
  final LocationAccessStatus locationAccessStatus;
  final GeoCoordinates? currentLocation;
  final List<NearbyCandidateCluster> nearbyClusters;
  final List<NearbyCandidateMapItem> nearbyMapItems;
  final bool isLocationOperationInProgress;
  final double nearbyRadiusKm;
  final bool isNearbyProfileVisible;
  final NearbyVisibilityAudience nearbyVisibilityAudience;
  final bool areNearbyNotificationsEnabled;

  DiscoveryState copyWith({
    DiscoveryStatus? status,
    DiscoveryFilter? selectedFilter,
    List<Candidate>? candidates,
    String? errorMessage,
    bool clearError = false,
    UserProfile? myProfile,
    DiscoveryViewMode? viewMode,
    LocationAccessStatus? locationAccessStatus,
    GeoCoordinates? currentLocation,
    List<NearbyCandidateCluster>? nearbyClusters,
    List<NearbyCandidateMapItem>? nearbyMapItems,
    bool? isLocationOperationInProgress,
    double? nearbyRadiusKm,
    bool? isNearbyProfileVisible,
    NearbyVisibilityAudience? nearbyVisibilityAudience,
    bool? areNearbyNotificationsEnabled,
  }) {
    return DiscoveryState(
      status: status ?? this.status,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      candidates: candidates ?? this.candidates,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      myProfile: myProfile ?? this.myProfile,
      viewMode: viewMode ?? this.viewMode,
      locationAccessStatus: locationAccessStatus ?? this.locationAccessStatus,
      currentLocation: currentLocation ?? this.currentLocation,
      nearbyClusters: nearbyClusters ?? this.nearbyClusters,
      nearbyMapItems: nearbyMapItems ?? this.nearbyMapItems,
      isLocationOperationInProgress:
          isLocationOperationInProgress ?? this.isLocationOperationInProgress,
      nearbyRadiusKm: nearbyRadiusKm ?? this.nearbyRadiusKm,
      isNearbyProfileVisible:
          isNearbyProfileVisible ?? this.isNearbyProfileVisible,
      nearbyVisibilityAudience:
          nearbyVisibilityAudience ?? this.nearbyVisibilityAudience,
      areNearbyNotificationsEnabled:
          areNearbyNotificationsEnabled ?? this.areNearbyNotificationsEnabled,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedFilter,
    candidates,
    errorMessage,
    myProfile,
    viewMode,
    locationAccessStatus,
    currentLocation,
    nearbyClusters,
    nearbyMapItems,
    isLocationOperationInProgress,
    nearbyRadiusKm,
    isNearbyProfileVisible,
    nearbyVisibilityAudience,
    areNearbyNotificationsEnabled,
  ];
}
