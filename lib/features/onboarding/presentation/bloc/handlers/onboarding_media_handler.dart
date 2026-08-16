part of '../profile_onboarding_bloc.dart';

mixin OnboardingMediaHandler
    on Bloc<ProfileOnboardingEvent, ProfileOnboardingState> {
  OnboardingMediaService get _mediaService;
  OnboardingRepository get _onboardingRepository;
  bool get _faceVerificationInFlight;
  set _faceVerificationInFlight(bool value);

  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit,
  );

  Future<void> _onProfilePhotoPickRequested(
    ProfilePhotoPickRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || draft.profileServerId == null) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (draft.photos.length >= _maxProfilePhotos) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    try {
      final filePath = await _mediaService.pickAndPrepareProfilePhoto();
      if (filePath == null) return;
      final usedOrders = draft.photos.map((photo) => photo.order).toSet();
      final order = Iterable<int>.generate(
        _maxProfilePhotos,
        (index) => index + 1,
      ).firstWhere((value) => !usedOrders.contains(value));
      final photo = OnboardingPhotoDraft(
        localFilePath: filePath,
        order: order,
        isMain: draft.photos.isEmpty,
        uploadStatus: PhotoUploadStatus.pending,
      );
      final withPhoto = draft.copyWith(photos: [...draft.photos, photo]);
      await _save(withPhoto, emit);
    } on OnboardingMediaValidationException {
      emit(state.copyWith(failure: const Failure.validation()));
    }
  }

  Future<void> _onProfilePhotoUploadRetryRequested(
    ProfilePhotoUploadRetryRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) => _uploadPhoto(event.localFilePath, emit);

  Future<void> _uploadPhoto(
    String localFilePath,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    final profileId = draft?.profileServerId;
    if (draft == null || profileId == null || profileId.isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    final index = draft.photos.indexWhere(
      (photo) => photo.localFilePath == localFilePath,
    );
    if (index < 0) return;
    final uploading = List<OnboardingPhotoDraft>.from(draft.photos);
    uploading[index] = uploading[index].copyWith(
      uploadStatus: PhotoUploadStatus.uploading,
      clearUploadFailure: true,
    );
    await _save(draft.copyWith(photos: uploading), emit);
    if (state.status != ProfileOnboardingStatus.submitting) {
      emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
    }
    final photo = uploading[index];
    final result = await _onboardingRepository.uploadPhoto(
      profileId: profileId,
      localFilePath: photo.localFilePath,
      order: photo.order,
      isMain: photo.isMain,
    );
    await result.fold<Future<void>>(
      (failure) async {
        final failed = List<OnboardingPhotoDraft>.from(state.draft!.photos);
        final failedIndex = failed.indexWhere(
          (item) => item.localFilePath == localFilePath,
        );
        if (failedIndex >= 0) {
          failed[failedIndex] = failed[failedIndex].copyWith(
            uploadStatus: PhotoUploadStatus.failed,
            uploadFailure: failure.type.name,
          );
          await _save(state.draft!.copyWith(photos: failed), emit);
        }
      },
      (uploaded) async {
        final updated = List<OnboardingPhotoDraft>.from(state.draft!.photos);
        final uploadedIndex = updated.indexWhere(
          (item) => item.localFilePath == localFilePath,
        );
        if (uploadedIndex < 0) return;
        updated[uploadedIndex] = updated[uploadedIndex].copyWith(
          serverId: uploaded.id,
          imageUrl: uploaded.imageUrl,
          isMain: uploaded.isMain,
          uploadStatus: PhotoUploadStatus.uploaded,
          clearUploadFailure: true,
        );
        await _save(
          state.draft!.copyWith(
            photos: updated,
            mainPhotoServerId: uploaded.isMain
                ? uploaded.id
                : state.draft!.mainPhotoServerId,
          ),
          emit,
        );
        await _reconcilePhotos(emit);
      },
    );
  }

  Future<void> _reconcilePhotos(Emitter<ProfileOnboardingState> emit) async {
    final result = await _onboardingRepository.getPhotos();
    await result.fold<Future<void>>((_) async {}, (photos) async {
      final draft = state.draft;
      if (draft == null) return;
      final updated = draft.photos
          .map((local) {
            final remote = local.serverId == null
                ? null
                : photos
                      .where((photo) => photo.id == local.serverId)
                      .firstOrNull;
            return remote == null
                ? local
                : local.copyWith(
                    imageUrl: remote.imageUrl,
                    isMain: remote.isMain,
                    uploadStatus: PhotoUploadStatus.uploaded,
                  );
          })
          .toList(growable: false);
      final main = photos.where((photo) => photo.isMain).firstOrNull;
      await _save(
        draft.copyWith(photos: updated, mainPhotoServerId: main?.id),
        emit,
      );
    });
  }

  Future<void> _onProfilePhotoMainSelected(
    ProfilePhotoMainSelected event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    if (event.serverId == draft.mainPhotoServerId) return;
    emit(
      state.copyWith(
        status: ProfileOnboardingStatus.submitting,
        clearFailure: true,
      ),
    );
    final result = await _onboardingRepository.setMainPhoto(event.serverId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (photo) async {
        final updated = draft.photos
            .map((item) => item.copyWith(isMain: item.serverId == photo.id))
            .toList(growable: false);
        await _save(
          draft.copyWith(photos: updated, mainPhotoServerId: photo.id),
          emit,
        );
      },
    );
  }

  Future<void> _onProfilePhotoRemoveRequested(
    ProfilePhotoRemoveRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    final photo = draft.photos
        .where((item) => item.localFilePath == event.localFilePath)
        .firstOrNull;
    if (photo == null) return;
    if (photo.serverId != null) {
      final result = await _onboardingRepository.deletePhoto(photo.serverId!);
      final failure = result.fold<Failure?>((value) => value, (_) => null);
      if (failure != null) {
        emit(state.copyWith(failure: failure));
        return;
      }
    }
    await _mediaService.deletePrivateFile(photo.localFilePath);
    final remaining = draft.photos
        .where((item) => item.localFilePath != event.localFilePath)
        .toList(growable: true);
    if (remaining.isNotEmpty && remaining.every((item) => !item.isMain)) {
      remaining[0] = remaining[0].copyWith(isMain: true);
    }
    final main = remaining.where((item) => item.isMain).firstOrNull;
    await _save(
      draft.copyWith(
        photos: remaining.toList(growable: false),
        mainPhotoServerId: main?.serverId,
        clearMainPhoto: main?.serverId == null,
      ),
      emit,
    );
  }

  Future<void> _onVoiceRecordingStarted(
    VoiceRecordingStarted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    try {
      await _mediaService.startVoiceRecording();
      emit(state.copyWith(isVoiceRecording: true, clearFailure: true));
    } on OnboardingMediaValidationException {
      emit(state.copyWith(failure: const Failure.validation()));
    }
  }

  Future<void> _onVoiceIntroStepRequested(
    VoiceIntroStepRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) => _continueAfterPhotos(emit);

  Future<void> _onProfilePhotosContinuePressed(
    ProfilePhotosContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) => _continueAfterPhotos(emit);

  Future<void> _continueAfterPhotos(
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || draft.photos.isEmpty) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    if (!draft.hasUploadedPhotos || !draft.hasMainPhoto) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.submitting,
          clearFailure: true,
        ),
      );
      for (final photo in draft.photos) {
        final currentDraft = state.draft;
        if (currentDraft == null) return;
        final currentPhoto = currentDraft.photos
            .where((item) => item.localFilePath == photo.localFilePath)
            .firstOrNull;
        if (currentPhoto == null ||
            currentPhoto.uploadStatus == PhotoUploadStatus.uploaded) {
          continue;
        }
        await _uploadPhoto(photo.localFilePath, emit);
        if (state.status != ProfileOnboardingStatus.submitting) {
          emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
        }
        final uploadedPhoto = state.draft?.photos
            .where((item) => item.localFilePath == photo.localFilePath)
            .firstOrNull;
        if (uploadedPhoto?.uploadStatus == PhotoUploadStatus.failed) {
          emit(state.copyWith(status: ProfileOnboardingStatus.editing));
          return;
        }
      }
    }
    final updatedDraft = state.draft;
    if (updatedDraft == null ||
        !updatedDraft.hasUploadedPhotos ||
        !updatedDraft.hasMainPhoto) {
      emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: const Failure.validation(),
        ),
      );
      return;
    }
    await _save(
      updatedDraft.copyWith(currentStep: OnboardingStep.mainPhoto),
      emit,
    );
  }

  Future<void> _onMainPhotoContinuePressed(
    MainPhotoContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !draft.hasUploadedPhotos || !draft.hasMainPhoto) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    await _save(
      draft.copyWith(
        currentStep: draft.candidateType == CandidateType.representative
            ? OnboardingStep.aboutMe
            : OnboardingStep.faceVerification,
      ),
      emit,
    );
  }

  Future<void> _onVoiceRecordingStopped(
    VoiceRecordingStopped event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null) return;
    try {
      final voice = await _mediaService.stopVoiceRecording();
      emit(state.copyWith(isVoiceRecording: false));
      if (voice == null) return;
      if (draft.voiceIntroMetadata != null) {
        await _mediaService.deletePrivateFile(
          draft.voiceIntroMetadata!.localFilePath,
        );
      }
      await _save(draft.copyWith(voiceIntroMetadata: voice), emit);
    } on OnboardingMediaValidationException {
      emit(
        state.copyWith(
          isVoiceRecording: false,
          status: ProfileOnboardingStatus.editing,
          failure: const Failure.validation(),
        ),
      );
    }
  }

  Future<void> _onVoicePlaybackRequested(
    VoicePlaybackRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final voice = state.draft?.voiceIntroMetadata;
    if (voice == null) return;
    if (state.isVoicePlaying) {
      await _mediaService.stopVoicePlayback();
      emit(state.copyWith(isVoicePlaying: false));
      return;
    }
    emit(state.copyWith(isVoicePlaying: true));
    try {
      await _mediaService.playVoice(voice.localFilePath);
    } finally {
      if (!isClosed) emit(state.copyWith(isVoicePlaying: false));
    }
  }

  Future<void> _onVoiceIntroContinuePressed(
    VoiceIntroContinuePressed event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isVoiceRecording) return;
    await _continueFromVoice(draft, emit);
  }

  Future<void> _onVoiceIntroSkipped(
    VoiceIntroSkipped event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || state.isVoiceRecording) return;
    await _mediaService.stopVoicePlayback();
    if (draft.voiceIntroMetadata != null) {
      await _mediaService.deletePrivateFile(
        draft.voiceIntroMetadata!.localFilePath,
      );
    }
    await _save(
      draft.copyWith(
        currentStep: OnboardingStep.locationPermission,
        clearVoiceIntro: true,
      ),
      emit,
    );
  }

  Future<void> _onVoiceIntroDeleted(
    VoiceIntroDeleted event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    final voice = draft?.voiceIntroMetadata;
    if (draft == null || voice == null || state.isVoiceRecording) return;
    await _mediaService.stopVoicePlayback();
    await _mediaService.deletePrivateFile(voice.localFilePath);
    await _save(draft.copyWith(clearVoiceIntro: true), emit);
  }

  Future<void> _continueFromVoice(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final voice = draft.voiceIntroMetadata;
    if (voice == null || voice.uploaded) {
      await _save(
        draft.copyWith(currentStep: OnboardingStep.locationPermission),
        emit,
      );
      return;
    }
    emit(state.copyWith(status: ProfileOnboardingStatus.submitting));
    final result = await _onboardingRepository.updateVoiceIntro(
      voice.localFilePath,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure,
        ),
      ),
      (_) => _save(
        state.draft!.copyWith(
          voiceIntroMetadata: voice.copyWith(uploaded: true),
          currentStep: OnboardingStep.locationPermission,
        ),
        emit,
      ),
    );
  }

  Future<void> _onFaceVerificationRequested(
    FaceVerificationRequested event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    final draft = state.draft;
    if (draft == null || !draft.hasMainPhoto || _faceVerificationInFlight) {
      return;
    }
    await _save(
      draft.copyWith(faceVerificationStatus: FaceVerificationStatus.notStarted),
      emit,
    );
  }

  Future<void> _onFaceVerificationPageOpened(
    FaceVerificationPageOpened event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (_faceVerificationInFlight) return;
    await _reconcilePhotos(emit);
  }

  Future<void> _onFaceSelfieCaptured(
    FaceSelfieCaptured event,
    Emitter<ProfileOnboardingState> emit,
  ) async {
    if (_faceVerificationInFlight) return;
    final draft = state.draft;
    if (draft == null || !draft.hasMainPhoto) {
      emit(state.copyWith(failure: const Failure.validation()));
      return;
    }
    _faceVerificationInFlight = true;
    String? selfiePath;
    try {
      selfiePath = await _mediaService.prepareSelfie(event.sourcePath);
      final quality = await _mediaService.checkSelfieQuality(selfiePath);
      if (!quality.isValid) {
        await _save(
          draft.copyWith(
            faceVerificationStatus: FaceVerificationStatus.retryableFailure,
          ),
          emit,
        );
        return;
      }
      await _save(
        draft.copyWith(
          faceVerificationStatus: FaceVerificationStatus.verifying,
        ),
        emit,
      );
      final result = await _onboardingRepository.verifyFace(selfiePath);
      await result.fold<Future<void>>(
        (failure) => _save(
          state.draft!.copyWith(
            faceVerificationStatus: failure.type == FailureType.forbidden
                ? FaceVerificationStatus.blocked
                : FaceVerificationStatus.retryableFailure,
          ),
          emit,
        ),
        (response) => _save(
          state.draft!.copyWith(
            currentStep: response.verified
                ? OnboardingStep.aboutMe
                : OnboardingStep.faceVerification,
            faceVerificationStatus: response.verified
                ? FaceVerificationStatus.matched
                : FaceVerificationStatus.retryableFailure,
          ),
          emit,
        ),
      );
    } on OnboardingMediaValidationException {
      await _save(
        state.draft!.copyWith(
          faceVerificationStatus: FaceVerificationStatus.retryableFailure,
        ),
        emit,
      );
    } finally {
      _faceVerificationInFlight = false;
      await _mediaService.deletePrivateFile(event.sourcePath);
      if (selfiePath != null) await _mediaService.deletePrivateFile(selfiePath);
    }
  }
}
