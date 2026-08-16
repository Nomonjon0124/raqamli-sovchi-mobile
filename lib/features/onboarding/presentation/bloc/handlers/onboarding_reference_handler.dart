part of '../profile_onboarding_bloc.dart';

mixin OnboardingReferenceHandler
    on Bloc<ProfileOnboardingEvent, ProfileOnboardingState> {
  OnboardingRepository get _onboardingRepository;
  OnboardingLocationService get _locationService;
  int get _educationPage;
  set _educationPage(int value);
  int get _regionPage;
  set _regionPage(int value);
  int get _districtPage;
  set _districtPage(int value);
  int get _healthStatusPage;
  set _healthStatusPage(int value);
  int get _maritalStatusPage;
  set _maritalStatusPage(int value);
  String? get _districtRegionRequest;
  set _districtRegionRequest(String? value);
  String get _districtSearch;
  set _districtSearch(String value);

  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit,
  );

  bool _isDivorcedStatus(String name);

  Future<void> _onEducationLevelsRequested(
    EducationLevelsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _educationPage + 1 : 1;
    emit(
      state.copyWith(
        educationStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getEducationLevels(page);
    result.fold(
      (failure) => emit(
        state.copyWith(
          educationStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) {
        _educationPage = page;
        final items = event.loadNextPage
            ? [...state.educationLevels, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            educationLevels: items,
            educationStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onEducationLevelSaved(
    EducationLevelSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.educationLevelId.isEmpty) return;
    await _save(draft.copyWith(educationLevelId: event.educationLevelId), emit);
  }

  Future<void> _onEducationContinuePressed(
    EducationContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.educationLevelId?.isEmpty ?? true) return;
    await _save(draft!.copyWith(currentStep: OnboardingStep.height), emit);
  }

  Future<void> _onRegionsRequested(
    RegionsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _regionPage + 1 : 1;
    emit(
      state.copyWith(regionStatus: ReferenceStatus.loading, clearFailure: true),
    );
    final result = await _onboardingRepository.getRegions(page);
    result.fold(
      (failure) => emit(
        state.copyWith(regionStatus: ReferenceStatus.failure, failure: failure),
      ),
      (response) {
        _regionPage = page;
        final items = event.loadNextPage
            ? [...state.regions, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            regions: items,
            regionStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onRegionSaved(
    RegionSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.regionId.isEmpty) return;
    _districtPage = 0;
    _districtRegionRequest = event.regionId;
    _districtSearch = '';
    await _save(
      draft.copyWith(
        regionId: event.regionId,
        clearDistrict: true,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
    add(const DistrictsRequested());
  }

  Future<void> _onDistrictsRequested(
    DistrictsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final regionId = state.draft?.regionId;
    if (regionId == null || regionId.isEmpty) return;
    final search = event.search ?? _districtSearch;
    final isNewSearch = search != _districtSearch;
    final page = event.loadNextPage && !isNewSearch ? _districtPage + 1 : 1;
    _districtSearch = search;
    final requestId = regionId;
    _districtRegionRequest = requestId;
    emit(
      state.copyWith(
        districtStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getDistricts(
      regionId: regionId,
      page: page,
      search: search,
    );
    if (_districtRegionRequest != requestId ||
        _districtSearch != search ||
        state.draft?.regionId != requestId) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(
          districtStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) {
        _districtPage = page;
        final items = event.loadNextPage && !isNewSearch
            ? [...state.districts, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            districts: items,
            districtStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onDistrictSaved(
    DistrictSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.districtId.isEmpty) return;
    await _save(
      draft.copyWith(
        districtId: event.districtId,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
  }

  Future<void> _onHealthStatusesRequested(
    HealthStatusesRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _healthStatusPage + 1 : 1;
    emit(
      state.copyWith(
        healthStatusStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getHealthStatuses(page);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          healthStatusStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) async {
        _healthStatusPage = page;
        final items = event.loadNextPage
            ? [...state.healthStatuses, ...response.items]
            : response.items;
        var nextDraft = state.draft;
        if (items.isNotEmpty && (nextDraft?.healthStatusId?.isEmpty ?? true)) {
          final defaultStatus = items.firstWhere(
            (item) => !item.name.toLowerCase().contains('nogiron'),
            orElse: () => items.first,
          );
          nextDraft = nextDraft?.copyWith(healthStatusId: defaultStatus.id);
        }
        if (nextDraft != state.draft) {
          await _save(nextDraft!, emit);
        }
        emit(
          state.copyWith(
            draft: nextDraft,
            healthStatuses: items,
            healthStatusStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onLocationContinuePressed(
    LocationContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if ((draft?.regionId?.isEmpty ?? true) ||
        (draft?.districtId?.isEmpty ?? true)) {
      return;
    }
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.healthStatus),
      emit,
    );
  }

  Future<void> _onHealthStatusSaved(
    HealthStatusSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.healthStatusId.isEmpty) return;
    await _save(
      draft.copyWith(
        healthStatusId: event.healthStatusId,
        currentStep: OnboardingStep.healthStatus,
      ),
      emit,
    );
  }

  Future<void> _onHealthStatusContinuePressed(
    HealthStatusContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.healthStatusId?.isEmpty ?? true) return;
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.maritalStatus),
      emit,
    );
  }

  Future<void> _onMaritalStatusesRequested(
    MaritalStatusesRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _maritalStatusPage + 1 : 1;
    emit(
      state.copyWith(
        maritalStatusStatus: ReferenceStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.getMaritalStatuses(page);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          maritalStatusStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) async {
        _maritalStatusPage = page;
        final items = event.loadNextPage
            ? [...state.maritalStatuses, ...response.items]
            : response.items;
        var nextDraft = state.draft;
        if (items.isNotEmpty && (nextDraft?.maritalStatusId?.isEmpty ?? true)) {
          final defaultStatus = items.firstWhere(
            (item) => !_isDivorcedStatus(item.name),
            orElse: () => items.first,
          );
          nextDraft = nextDraft?.copyWith(maritalStatusId: defaultStatus.id);
        }
        if (nextDraft != state.draft) {
          await _save(nextDraft!, emit);
        }
        emit(
          state.copyWith(
            draft: nextDraft,
            maritalStatuses: items,
            maritalStatusStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
          ),
        );
      },
    );
  }

  Future<void> _onMaritalStatusSaved(
    MaritalStatusSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.maritalStatusId.isEmpty) return;
    await _save(
      draft.copyWith(
        maritalStatusId: event.maritalStatusId,
        currentStep: OnboardingStep.maritalStatus,
      ),
      emit,
    );
  }

  Future<void> _onMaritalStatusContinuePressed(
    MaritalStatusContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.maritalStatusId?.isEmpty ?? true) return;
    add(const ProfileBootstrapRequested());
  }

  Future<void> _onLocationPermissionRequested(
    LocationPermissionRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isLocationLoading) return;
    emit(state.copyWith(isLocationLoading: true, clearFailure: true));
    try {
      final coordinates = await _locationService.requestCurrentLocation();
      await _save(
        draft.copyWith(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude,
          currentStep: draft.candidateType == CandidateType.representative
              ? OnboardingStep.representativeContact
              : OnboardingStep.success,
        ),
        emit,
      );
      emit(state.copyWith(isLocationLoading: false));
    } on OnboardingLocationPermissionException {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.forbidden(),
        ),
      );
    } on OnboardingLocationUnavailableException {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.unsupported(),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLocationLoading: false,
          failure: const Failure.unknown(),
        ),
      );
    }
  }
}
