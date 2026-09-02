// ignore_for_file: unused_element_parameter
part of '../profile_onboarding_bloc.dart';

mixin OnboardingIdentityHandler
    on Bloc<ProfileOnboardingEvent, ProfileOnboardingState> {
  OnboardingDraftRepository get _draftRepository;
  DateTime Function() get _now;
  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit, [
    Failure? failure,
  ]);
  Future<void> _cleanupDraftMedia(ProfileOnboardingDraft draft);
  OnboardingMediaService get _mediaService;
  CommitPendingAuthSessionUseCase get _commitPendingAuthSession;
  OnboardingRepository get _onboardingRepository;

  Future<void> _onStarted(
    ProfileOnboardingStarted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.loading,
        clearFailure: true,
      ),
    );
    final result = await _draftRepository.load(event.ownerUserId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (draft) async => emit(
        ProfileOnboardingState(
          status: ProfileOnboardingStatus.editing,
          draft:
              draft ??
              ProfileOnboardingDraft(
                ownerUserId: event.ownerUserId,
                updatedAt: _now().toUtc(),
              ),
        ),
      ),
    );
  }

  Future<void> _onCandidateTypeSaved(
    CandidateTypeSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final updated = draft.copyWith(candidateType: event.candidateType);
    await _save(updated, emit);
  }

  Future<void> _onCandidateTypeContinuePressed(
    CandidateTypeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.candidateType == null) return;
    if (draft!.candidateType == CandidateType.representative) {
      await _save(
        draft.copyWith(currentStep: OnboardingStep.representativeIntro),
        emit,
      );
      return;
    }
    await _save(draft.copyWith(currentStep: OnboardingStep.pledge), emit);
  }

  Future<void> _onPledgeAcceptanceChanged(
    PledgeAcceptanceChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(draft.copyWith(pledgeAcceptedTerms: event.accepted), emit);
  }

  Future<void> _onPledgeContinuePressed(
    PledgeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft?.pledgeAcceptedTerms != true) return;
    await _save(draft!.copyWith(currentStep: OnboardingStep.identity), emit);
  }

  Future<void> _onBirthDateSaved(
    BirthDateSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (!OnboardingDateValidator.isEligible(event.birthDate, _now())) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        birthDate: event.birthDate,
        currentStep: OnboardingStep.profession,
      ),
      emit,
    );
  }

  Future<void> _onStepBackRequested(
    OnboardingStepBackRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final steps = draft.candidateType == CandidateType.representative
        ? representativeOnboardingSteps
        : standardOnboardingSteps;
    var index = steps.indexOf(draft.currentStep);
    if (index <= 0) return;
    if (draft.currentStep == OnboardingStep.representativePledge &&
        !draft.candidateUsesApp) {
      index = steps.indexOf(OnboardingStep.representativeContact) + 1;
    }
    final previousStep = steps[index - 1];
    await _save(draft.copyWith(currentStep: previousStep), emit);
  }

  Future<void> _onIdentitySaved(
    IdentitySaved event,
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
        firstName: event.firstName.trim(),
        lastName: event.lastName.trim(),
        patronymic: event.patronymic.trim(),
        currentStep: OnboardingStep.birthDate,
      ),
      emit,
    );
  }

  Future<void> _onHeightSaved(
    HeightSaved event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null ||
        event.heightCm < 100 ||
        event.heightCm > 300 ||
        event.weightKg == null ||
        event.weightKg! < 20 ||
        event.weightKg! > 250) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        heightCm: event.heightCm,
        weightKg: event.weightKg,
        currentStep: OnboardingStep.location,
      ),
      emit,
    );
  }

  Future<void> _onChildrenCountChanged(
    ChildrenCountChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (draft.childrenNotLivingWithMe) {
      if (draft.childrenCount != 0) {
        await _save(draft.copyWith(childrenCount: 0), emit);
      }
      return;
    }
    final count = event.count.clamp(0, 99);
    await _save(draft.copyWith(childrenCount: count), emit);
  }

  Future<void> _onChildrenNotLivingWithMeChanged(
    ChildrenNotLivingWithMeChanged event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(
      draft.copyWith(
        childrenNotLivingWithMe: event.value,
        childrenCount: event.value ? 0 : draft.childrenCount,
      ),
      emit,
    );
  }

  Future<void> _onAboutMeContinuePressed(
    AboutMeContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final value = event.aboutMe.trim();
    await _save(
      draft.copyWith(
        aboutMe: value.isEmpty ? null : value,
        clearAboutMe: value.isEmpty,
        currentStep: OnboardingStep.voiceIntro,
      ),
      emit,
    );
  }

  Future<void> _onAboutMeSkipPressed(
    AboutMeSkipPressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    await _save(
      draft.copyWith(
        currentStep: OnboardingStep.voiceIntro,
        clearAboutMe: true,
      ),
      emit,
    );
  }

  Future<void> _onFinalizationRequested(
    ProfileOnboardingFinalizationRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (state.status == ProfileOnboardingStatus.submitting) return;
    final draft = state.draft;
    if (draft == null ||
        draft.profileServerId == null ||
        !draft.hasUploadedPhotos ||
        !draft.hasMainPhoto ||
        (draft.candidateType != CandidateType.representative &&
            draft.faceVerificationStatus != FaceVerificationStatus.matched) ||
        (draft.candidateType == CandidateType.representative &&
            !draft.hasAcceptedRepresentativeResponsibility) ||
        (draft.candidateType == CandidateType.representative &&
            (draft.representativeInfoId?.isEmpty ?? true)) ||
        (draft.candidateType == CandidateType.representative &&
            draft.candidateUsesApp &&
            !draft.consentRequestSent) ||
        !draft.pledgeAcceptedTerms) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    if (draft.aboutMe != null ||
        draft.latitude != null ||
        draft.longitude != null) {
      final details = await _onboardingRepository.updateProfileDetails(
        aboutMe: draft.aboutMe,
        latitude: draft.latitude,
        longitude: draft.longitude,
      );
      final detailsFailure = details.fold<Failure?>(
        (failure) => failure,
        (_) => null,
      );
      if (detailsFailure != null) {
        emit(
          state.copyWith(
            status: ProfileOnboardingStatus.editing,
            failure: detailsFailure,
          ),
        );
        return;
      }
    }
    final pledge = await _onboardingRepository.submitPledge(
      userId: draft.ownerUserId,
      acceptedTerms: true,
      hasSeriousBadge: true,
    );
    final pledgeFailure = pledge.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (pledgeFailure != null) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: pledgeFailure,
        ),
      );
      return;
    }
    final commit = await _commitPendingAuthSession();
    final commitFailure = commit.fold<Failure?>(
      (failure) => failure,
      (_) => null,
    );
    if (commitFailure != null) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: commitFailure,
        ),
      );
      return;
    }
    await _cleanupDraftMedia(draft);
    final profileReadyDraft = draft.copyWith(
      currentStep: draft.candidateType == CandidateType.representative
          ? OnboardingStep.representativeReady
          : OnboardingStep.profileReady,
    );
    final draftSave = await _draftRepository.save(profileReadyDraft);
    draftSave.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: profileReadyDraft,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: profileReadyDraft,
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> _onProfileReadyHomeRequested(
    ProfileReadyHomeRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (state.status == ProfileOnboardingStatus.submitting) return;
    await _draftRepository.clear();
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.completed,
        openQuestionnaire: false,
      ),
    );
  }

  Future<void> _onProfileReadyQuestionnaireRequested(
    ProfileReadyQuestionnaireRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (state.status == ProfileOnboardingStatus.submitting) return;
    await _draftRepository.clear();
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.completed,
        openQuestionnaire: true,
      ),
    );
  }

  Future<void> _onCancelled(
    ProfileOnboardingCancelled event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft != null) {
      await _cleanupDraftMedia(draft);
      await _draftRepository.clear();
    }
    await _mediaService.cancelVoiceRecording();
    await _mediaService.stopVoicePlayback();
    emit(
      const ProfileOnboardingState(status: ProfileOnboardingStatus.cancelled),
    );
  }
}
