import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../../profile/application/use_cases/get_my_profile.dart';
import '../../application/use_cases/check_location_access.dart';
import '../../application/use_cases/cluster_nearby_candidates.dart';
import '../../application/use_cases/get_candidates.dart';
import '../../application/use_cases/open_location_settings.dart';
import '../../application/use_cases/request_current_location.dart';
import '../../application/use_cases/update_profile_location.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/entities/discovery_filter.dart';
import '../../domain/entities/geo_coordinates.dart';
import '../../domain/entities/location_access_status.dart';
import 'discovery_event.dart';
import 'discovery_state.dart';

final class DiscoveryBloc extends Bloc<DiscoveryEvent, DiscoveryState> {
  DiscoveryBloc({
    required GetCandidatesUseCase getCandidates,
    required CheckLocationAccessUseCase checkLocationAccess,
    required RequestCurrentLocationUseCase requestCurrentLocation,
    required OpenLocationSettingsUseCase openLocationSettings,
    required UpdateProfileLocationUseCase updateProfileLocation,
    required ClusterNearbyCandidatesUseCase clusterNearbyCandidates,
    GetMyProfileUseCase? getMyProfile,
  }) : _getCandidates = getCandidates,
       _checkLocationAccess = checkLocationAccess,
       _requestCurrentLocation = requestCurrentLocation,
       _openLocationSettings = openLocationSettings,
       _updateProfileLocation = updateProfileLocation,
       _clusterNearbyCandidates = clusterNearbyCandidates,
       _getMyProfile = getMyProfile,
       super(const DiscoveryState()) {
    on<DiscoveryFetchCandidatesRequested>(_onFetchCandidates);
    on<DiscoveryRefreshCandidatesRequested>(_onRefreshCandidates);
    on<DiscoveryViewModeChanged>(_onViewModeChanged);
    on<DiscoveryNearbyLocationActionRequested>(_onLocationActionRequested);
    on<DiscoveryNearbyPermissionDismissed>(_onPermissionDismissed);
    on<DiscoveryNearbySettingsSaved>(_onNearbySettingsSaved);
    on<DiscoveryNearbyNotificationsChanged>(_onNearbyNotificationsChanged);
    on<DiscoveryProfileLoaded>(_onProfileLoaded);
  }

  static const _mapPageSize = 100;

  final GetCandidatesUseCase _getCandidates;
  final CheckLocationAccessUseCase _checkLocationAccess;
  final RequestCurrentLocationUseCase _requestCurrentLocation;
  final OpenLocationSettingsUseCase _openLocationSettings;
  final UpdateProfileLocationUseCase _updateProfileLocation;
  final ClusterNearbyCandidatesUseCase _clusterNearbyCandidates;
  final GetMyProfileUseCase? _getMyProfile;
  int _requestSerial = 0;

  Future<void> _onFetchCandidates(
    DiscoveryFetchCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final targetFilter = event.filter;
    if (targetFilter == state.selectedFilter &&
        (state.status == DiscoveryStatus.loading ||
            (state.status == DiscoveryStatus.success &&
                state.candidates.isNotEmpty))) {
      return;
    }
    final requestId = ++_requestSerial;

    if (targetFilter == DiscoveryFilter.nearby) {
      final locationAccess = await _checkLocationAccess();
      if (requestId != _requestSerial) return;
      if (locationAccess != LocationAccessStatus.granted) {
        emit(
          state.copyWith(
            status: DiscoveryStatus.permissionRequired,
            selectedFilter: targetFilter,
            viewMode: DiscoveryViewMode.map,
            locationAccessStatus: locationAccess,
            isLocationOperationInProgress: false,
            clearError: true,
          ),
        );
        return;
      }
      await _prepareNearby(
        emit,
        viewMode: DiscoveryViewMode.map,
        showPermissionCardWhileLocating: false,
      );
      return;
    }

    // Parallel: fetch profile once if not yet loaded.
    if (state.myProfile == null && _getMyProfile != null) {
      unawaited(
        _getMyProfile().then(
          (result) => result.fold(
            (_) {},
            (profile) => add(DiscoveryProfileLoaded(profile)),
          ),
        ),
      );
    }

    emit(
      state.copyWith(
        status: DiscoveryStatus.loading,
        selectedFilter: targetFilter,
        clearError: true,
      ),
    );

    final result = await _getCandidatesWithMatchesFallback(targetFilter);
    if (requestId != _requestSerial) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message,
          selectedFilter: targetFilter,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty
              ? DiscoveryStatus.empty
              : DiscoveryStatus.success,
          candidates: candidates,
          selectedFilter: targetFilter,
          nearbyClusters: const [],
          nearbyMapItems: const [],
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onRefreshCandidates(
    DiscoveryRefreshCandidatesRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final targetFilter = state.selectedFilter;
    if (targetFilter == DiscoveryFilter.nearby) {
      await _prepareNearby(
        emit,
        viewMode: state.viewMode,
        showPermissionCardWhileLocating: false,
      );
      return;
    }
    final requestId = ++_requestSerial;

    emit(state.copyWith(status: DiscoveryStatus.loading, clearError: true));

    final result = await _getCandidatesWithMatchesFallback(targetFilter);
    if (requestId != _requestSerial) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (candidates) => emit(
        state.copyWith(
          status: candidates.isEmpty
              ? DiscoveryStatus.empty
              : DiscoveryStatus.success,
          candidates: candidates,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> _onViewModeChanged(
    DiscoveryViewModeChanged event,
    Emitter<DiscoveryState> emit,
  ) async {
    if (event.viewMode == state.viewMode ||
        state.selectedFilter != DiscoveryFilter.nearby) {
      return;
    }
    if (event.viewMode == DiscoveryViewMode.grid) {
      ++_requestSerial;
      emit(state.copyWith(viewMode: DiscoveryViewMode.grid));
      return;
    }

    final requestId = ++_requestSerial;
    final locationAccess = await _checkLocationAccess();
    if (requestId != _requestSerial) return;
    if (locationAccess != LocationAccessStatus.granted) {
      emit(
        state.copyWith(
          status: DiscoveryStatus.permissionRequired,
          viewMode: DiscoveryViewMode.map,
          locationAccessStatus: locationAccess,
          isLocationOperationInProgress: false,
          clearError: true,
        ),
      );
      return;
    }

    await _prepareNearby(
      emit,
      viewMode: DiscoveryViewMode.map,
      showPermissionCardWhileLocating: false,
    );
  }

  Future<void> _onLocationActionRequested(
    DiscoveryNearbyLocationActionRequested event,
    Emitter<DiscoveryState> emit,
  ) async {
    final requestId = ++_requestSerial;
    final currentAccess = await _checkLocationAccess();
    if (requestId != _requestSerial) return;
    if (currentAccess == LocationAccessStatus.permanentlyDenied ||
        currentAccess == LocationAccessStatus.serviceDisabled) {
      emit(
        state.copyWith(
          locationAccessStatus: currentAccess,
          isLocationOperationInProgress: true,
          clearError: true,
        ),
      );
      await _openLocationSettings(currentAccess);
      if (requestId != _requestSerial) return;
      emit(state.copyWith(isLocationOperationInProgress: false));
      return;
    }

    await _prepareNearby(
      emit,
      viewMode: DiscoveryViewMode.map,
      showPermissionCardWhileLocating: true,
    );
  }

  Future<void> _onPermissionDismissed(
    DiscoveryNearbyPermissionDismissed event,
    Emitter<DiscoveryState> emit,
  ) async {
    ++_requestSerial;
    emit(
      state.copyWith(
        status: DiscoveryStatus.initial,
        selectedFilter: DiscoveryFilter.matches,
        viewMode: DiscoveryViewMode.grid,
        isLocationOperationInProgress: false,
        clearError: true,
      ),
    );
    add(
      const DiscoveryFetchCandidatesRequested(filter: DiscoveryFilter.matches),
    );
  }

  Future<void> _onNearbySettingsSaved(
    DiscoveryNearbySettingsSaved event,
    Emitter<DiscoveryState> emit,
  ) async {
    final shouldReloadCandidates = event.radiusKm != state.nearbyRadiusKm;
    emit(
      state.copyWith(
        nearbyRadiusKm: event.radiusKm,
        isNearbyProfileVisible: event.isProfileVisible,
        nearbyVisibilityAudience: event.audience,
      ),
    );
    if (!shouldReloadCandidates) return;

    final coordinates = state.currentLocation;
    if (coordinates == null) {
      await _prepareNearby(
        emit,
        viewMode: state.viewMode,
        showPermissionCardWhileLocating: false,
      );
      return;
    }

    final requestId = ++_requestSerial;
    emit(state.copyWith(status: DiscoveryStatus.loading, clearError: true));
    await _loadNearbyCandidates(
      emit,
      requestId: requestId,
      coordinates: coordinates,
      viewMode: state.viewMode,
    );
  }

  void _onNearbyNotificationsChanged(
    DiscoveryNearbyNotificationsChanged event,
    Emitter<DiscoveryState> emit,
  ) {
    emit(state.copyWith(areNearbyNotificationsEnabled: event.isEnabled));
  }

  Future<void> _prepareNearby(
    Emitter<DiscoveryState> emit, {
    required DiscoveryViewMode viewMode,
    required bool showPermissionCardWhileLocating,
  }) async {
    final requestId = ++_requestSerial;
    emit(
      state.copyWith(
        status: showPermissionCardWhileLocating
            ? DiscoveryStatus.permissionRequired
            : DiscoveryStatus.loading,
        selectedFilter: DiscoveryFilter.nearby,
        viewMode: viewMode,
        isLocationOperationInProgress: true,
        clearError: true,
      ),
    );

    final locationResult = await _requestCurrentLocation();
    if (requestId != _requestSerial) return;

    GeoCoordinates? coordinates;
    locationResult.fold((_) {}, (value) => coordinates = value);
    if (coordinates == null) {
      final locationAccess = await _checkLocationAccess();
      if (requestId != _requestSerial) return;
      emit(
        state.copyWith(
          status: locationAccess == LocationAccessStatus.granted
              ? DiscoveryStatus.failure
              : DiscoveryStatus.permissionRequired,
          locationAccessStatus: locationAccess,
          isLocationOperationInProgress: false,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: DiscoveryStatus.loading,
        viewMode: viewMode,
        currentLocation: coordinates,
        locationAccessStatus: LocationAccessStatus.granted,
        isLocationOperationInProgress: false,
        clearError: true,
      ),
    );

    final updateResult = await _updateProfileLocation(coordinates!);
    if (requestId != _requestSerial) return;
    String? updateError;
    updateResult.fold((failure) => updateError = failure.message, (_) {});
    if (updateError != null || updateResult.isLeft) {
      emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: updateError,
          isLocationOperationInProgress: false,
        ),
      );
      return;
    }

    await _loadNearbyCandidates(
      emit,
      requestId: requestId,
      coordinates: coordinates!,
      viewMode: viewMode,
    );
  }

  Future<void> _loadNearbyCandidates(
    Emitter<DiscoveryState> emit, {
    required int requestId,
    required GeoCoordinates coordinates,
    required DiscoveryViewMode viewMode,
  }) async {
    final candidatesResult = await _getCandidates(
      filter: DiscoveryFilter.nearby,
      pageSize: viewMode == DiscoveryViewMode.map ? _mapPageSize : 10,
      radiusKm: state.nearbyRadiusKm,
    );
    if (requestId != _requestSerial) return;

    candidatesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: DiscoveryStatus.failure,
          errorMessage: failure.message,
          selectedFilter: DiscoveryFilter.nearby,
          viewMode: viewMode,
          isLocationOperationInProgress: false,
        ),
      ),
      (candidates) {
        final clustering = _clusterNearbyCandidates(
          candidates: candidates,
          viewerLocation: coordinates,
        );
        emit(
          state.copyWith(
            status: candidates.isEmpty
                ? DiscoveryStatus.empty
                : DiscoveryStatus.success,
            candidates: candidates,
            selectedFilter: DiscoveryFilter.nearby,
            viewMode: candidates.isEmpty ? DiscoveryViewMode.grid : viewMode,
            currentLocation: coordinates,
            nearbyClusters: clustering.clusters,
            nearbyMapItems: clustering.items,
            locationAccessStatus: LocationAccessStatus.granted,
            isLocationOperationInProgress: false,
            clearError: true,
          ),
        );
      },
    );
  }

  void _onProfileLoaded(
    DiscoveryProfileLoaded event,
    Emitter<DiscoveryState> emit,
  ) {
    emit(state.copyWith(myProfile: event.profile));
  }

  Future<Either<Failure, List<Candidate>>> _getCandidatesWithMatchesFallback(
    DiscoveryFilter filter,
  ) async {
    final result = await _getCandidates(filter: filter);
    if (filter != DiscoveryFilter.matches) return result;

    return switch (result) {
      Left<Failure, List<Candidate>>() => result,
      Right<Failure, List<Candidate>>(value: final candidates) =>
        candidates.isNotEmpty
            ? result
            : _getCandidates(filter: DiscoveryFilter.recommended),
    };
  }
}
