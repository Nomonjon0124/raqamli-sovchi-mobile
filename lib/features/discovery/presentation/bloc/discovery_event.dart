import 'package:equatable/equatable.dart';

import '../../domain/entities/discovery_filter.dart';
import '../../domain/entities/user_profile.dart';
import 'discovery_state.dart';

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

final class DiscoveryViewModeChanged extends DiscoveryEvent {
  const DiscoveryViewModeChanged(this.viewMode);

  final DiscoveryViewMode viewMode;

  @override
  List<Object?> get props => [viewMode];
}

final class DiscoveryNearbyLocationActionRequested extends DiscoveryEvent {
  const DiscoveryNearbyLocationActionRequested();
}

final class DiscoveryNearbyPermissionDismissed extends DiscoveryEvent {
  const DiscoveryNearbyPermissionDismissed();
}

final class DiscoveryNearbySettingsSaved extends DiscoveryEvent {
  const DiscoveryNearbySettingsSaved({
    required this.radiusKm,
    required this.isProfileVisible,
    required this.audience,
  });

  final double radiusKm;
  final bool isProfileVisible;
  final NearbyVisibilityAudience audience;

  @override
  List<Object?> get props => [radiusKm, isProfileVisible, audience];
}

final class DiscoveryNearbyNotificationsChanged extends DiscoveryEvent {
  const DiscoveryNearbyNotificationsChanged(this.isEnabled);

  final bool isEnabled;

  @override
  List<Object?> get props => [isEnabled];
}

final class DiscoveryProfileLoaded extends DiscoveryEvent {
  const DiscoveryProfileLoaded(this.profile);

  final UserProfile profile;

  @override
  List<Object?> get props => [profile];
}
