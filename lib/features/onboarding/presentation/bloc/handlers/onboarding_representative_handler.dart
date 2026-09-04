// ignore_for_file: unused_element_parameter
part of '../profile_onboarding_bloc.dart';

mixin OnboardingRepresentativeHandler
    on Bloc<ProfileOnboardingEvent, ProfileOnboardingState> {
  OnboardingRepository get _onboardingRepository;
  int get _kinshipPage;
  set _kinshipPage(int value);

  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit, [
    Failure? failure,
  ]);

  Future<void> _onRepresentativeIntroContinuePressed(
    RepresentativeIntroContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.candidateType != CandidateType.representative) return;
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.representativeIdentity),
      emit,
    );
  }

  Future<void> _onRepresentativeIdentitySaved(
    RepresentativeIdentitySaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        event.firstName.trim().isEmpty ||
        event.lastName.trim().isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        representativeFirstName: event.firstName.trim(),
        representativeLastName: event.lastName.trim(),
        currentStep: OnboardingStep.representativeRelation,
      ),
      emit,
    );
  }

  Future<void> _onKinshipsRequested(
    KinshipsRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final page = event.loadNextPage ? _kinshipPage + 1 : 1;
    emit(state.copyWith(kinshipStatus: ReferenceStatus.loading));
    final result = await _onboardingRepository.getKinships(page);
    result.fold(
      (failure) => emit(
        state.copyWith(
          kinshipStatus: ReferenceStatus.failure,
          failure: failure,
        ),
      ),
      (response) {
        _kinshipPage = page;
        final items = event.loadNextPage
            ? [...state.kinships, ...response.items]
            : response.items;
        emit(
          state.copyWith(
            kinships: items,
            kinshipStatus: items.isEmpty
                ? ReferenceStatus.empty
                : ReferenceStatus.loaded,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<void> _onRepresentativeRelationSaved(
    RepresentativeRelationSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.kinshipId.isEmpty) return;
    await _save(draft.copyWith(kinshipId: event.kinshipId), emit);
  }

  Future<void> _onRepresentativeRelationContinuePressed(
    RepresentativeRelationContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.kinshipId?.isEmpty ?? true) return;
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.representativeCandidateType),
      emit,
    );
  }

  Future<void> _onRepresentedCandidateTypeSaved(
    RepresentedCandidateTypeSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.candidateType == CandidateType.representative) {
      return;
    }
    await _save(
      draft.copyWith(representedCandidateType: event.candidateType),
      emit,
    );
  }

  Future<void> _onRepresentedCandidateTypeContinuePressed(
    RepresentedCandidateTypeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.representedCandidateType == null) return;
    await _save(draft!.copyWith(currentStep: OnboardingStep.identity), emit);
  }

  Future<void> _onProfileBootstrapRequested(
    ProfileBootstrapRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        !draft.hasQuestionnaire ||
        draft.candidateType == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (draft.profileServerId != null) {
      await _save(draft.copyWith(currentStep: OnboardingStep.photos), emit);
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final request = ProfileBootstrapRequest(
      firstName: draft.firstName!,
      lastName: draft.lastName!,
      fatherName: draft.patronymic,
      candidateType: draft.candidateType!,
      birthDate: draft.birthDate!,
      heightCm: draft.heightCm!,
      weightKg: draft.weightKg,
      regionId: draft.regionId!,
      districtId: draft.districtId!,
      educationLevelId: draft.educationLevelId!,
      professionId: draft.professionId,
      maritalStatusId: draft.maritalStatusId!,
      hasChildren: draft.childrenCount > 0 || draft.childrenNotLivingWithMe,
      childrenCount: draft.childrenNotLivingWithMe ? 0 : draft.childrenCount,
      healthStatusId: draft.healthStatusId,
      representedCandidateType: draft.representedCandidateType,
    );
    final result = await _onboardingRepository.createProfile(request);
    await result.fold<Future<void>>(
      (failure) async {
        if (failure.type == FailureType.networkTimeout) {
          final reconcile = await _onboardingRepository.getMyProfile();
          await reconcile.fold<Future<void>>(
            (reconcileFailure) async => emit(
              state.copyWith(
                status: ProfileOnboardingStatus.editing,
                failure: reconcileFailure,
              ),
            ),
            (profile) => _save(
              draft.copyWith(
                profileServerId: profile.id,
                currentStep: OnboardingStep.photos,
              ),
              emit,
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: ProfileOnboardingStatus.editing,
            failure: failure,
          ),
        );
      },
      (profile) => _save(
        draft.copyWith(
          profileServerId: profile.id,
          currentStep: OnboardingStep.photos,
        ),
        emit,
      ),
    );
  }

  Future<void> _onRepresentativeContactSubmitted(
    RepresentativeContactSubmitted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    final contact = _normalizeRepresentativeContact(event.contact);
    if (draft == null || !_isValidRepresentativeContact(contact)) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    final request = _representativeRequest(draft, candidateContact: contact);
    if (request == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.sendRepresentativeConsent(
      request,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (info) => _save(
        draft.copyWith(
          representativeInfoId: info.id,
          candidateContact: contact,
          candidateUsesApp: true,
          consentRequestSent: true,
          currentStep: OnboardingStep.representativeConsentSent,
        ),
        emit,
      ),
    );
  }

  Future<void> _onRepresentativeCandidateDoesNotUseApp(
    RepresentativeCandidateDoesNotUseApp event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final request = _representativeRequest(draft);
    if (request == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.createRepresentativeInfo(
      request,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (info) => _save(
        draft.copyWith(
          representativeInfoId: info.id,
          candidateUsesApp: false,
          consentRequestSent: false,
          clearCandidateContact: true,
          currentStep: OnboardingStep.representativePledge,
        ),
        emit,
      ),
    );
  }

  Future<void> _onRepresentativeConsentAcknowledged(
    RepresentativeConsentAcknowledged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.consentRequestSent != true) return;
    await _save(
      draft!.copyWith(currentStep: OnboardingStep.representativePledge),
      emit,
    );
  }

  Future<void> _onRepresentativeResponsibilityChanged(
    RepresentativeResponsibilityChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || event.index < 0 || event.index > 2) return;
    await _save(switch (event.index) {
      0 => draft.copyWith(representativeAccuracyAccepted: event.accepted),
      1 => draft.copyWith(representativePrivacyAccepted: event.accepted),
      _ => draft.copyWith(representativeInterestAccepted: event.accepted),
    }, emit);
  }

  Future<void> _onRepresentativePledgeContinuePressed(
    RepresentativePledgeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !draft.hasAcceptedRepresentativeResponsibility) {
      return;
    }
    await _save(draft.copyWith(pledgeAcceptedTerms: true), emit);
    add(const ProfileOnboardingFinalizationRequested());
  }

  bool _isValidRepresentativeContact(String value) {
    final phone = RegExp(r'^\+998\d{9}$');
    final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return phone.hasMatch(value) || email.hasMatch(value);
  }

  String _normalizeRepresentativeContact(String value) {
    final trimmed = value.trim();
    if (trimmed.contains('@')) return trimmed;
    return trimmed.replaceAll(RegExp(r'[\s()\-]'), '');
  }

  RepresentativeInfoRequest? _representativeRequest(
    ProfileOnboardingDraft draft, {
    String? candidateContact,
  }) {
    final profileId = draft.profileServerId;
    final candidateType = draft.representedCandidateType;
    final kinshipId = draft.kinshipId;
    if (profileId == null ||
        profileId.isEmpty ||
        candidateType == null ||
        candidateType == CandidateType.representative ||
        kinshipId == null ||
        kinshipId.isEmpty) {
      return null;
    }
    return RepresentativeInfoRequest(
      profileId: profileId,
      candidateType: candidateType,
      kinshipId: kinshipId,
      candidateContact: candidateContact,
    );
  }
}
