import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/application/use_cases/commit_pending_auth_session.dart';
import '../../application/onboarding_date_validator.dart';
import '../../application/services/onboarding_location_service.dart';
import '../../application/services/onboarding_media_service.dart';
import '../../domain/entities/candidate_type.dart';
import '../../domain/entities/profile_onboarding_draft.dart';
import '../../domain/entities/profile_onboarding_models.dart';
import '../../domain/repositories/onboarding_draft_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'profile_onboarding_event.dart';
import 'profile_onboarding_state.dart';

part 'handlers/onboarding_identity_handler.dart';
part 'handlers/onboarding_media_handler.dart';
part 'handlers/onboarding_reference_handler.dart';
part 'handlers/onboarding_representative_handler.dart';

const _maxProfilePhotos = 5;

final class ProfileOnboardingBloc
    extends Bloc<ProfileOnboardingEvent, ProfileOnboardingState>
    with
        OnboardingIdentityHandler,
        OnboardingMediaHandler,
        OnboardingReferenceHandler,
        OnboardingRepresentativeHandler {
  ProfileOnboardingBloc({
    required OnboardingRepository onboardingRepository,
    required OnboardingDraftRepository draftRepository,
    required OnboardingMediaService mediaService,
    required OnboardingLocationService locationService,
    required CommitPendingAuthSessionUseCase commitPendingAuthSession,
    DateTime Function()? now,
  }) : _onboardingRepository = onboardingRepository,
       _draftRepository = draftRepository,
       _mediaService = mediaService,
       _locationService = locationService,
       _commitPendingAuthSession = commitPendingAuthSession,
       _now = now ?? DateTime.now,
       super(const ProfileOnboardingState()) {
    on<ProfileOnboardingStarted>(_onStarted);
    on<CandidateTypeSaved>(_onCandidateTypeSaved);
    on<CandidateTypeContinuePressed>(_onCandidateTypeContinuePressed);
    on<RepresentativeIntroContinuePressed>(
      _onRepresentativeIntroContinuePressed,
    );
    on<RepresentativeIdentitySaved>(_onRepresentativeIdentitySaved);
    on<KinshipsRequested>(_onKinshipsRequested);
    on<RepresentativeRelationSaved>(_onRepresentativeRelationSaved);
    on<RepresentativeRelationContinuePressed>(
      _onRepresentativeRelationContinuePressed,
    );
    on<RepresentedCandidateTypeSaved>(_onRepresentedCandidateTypeSaved);
    on<RepresentedCandidateTypeContinuePressed>(
      _onRepresentedCandidateTypeContinuePressed,
    );
    on<PledgeAcceptanceChanged>(_onPledgeAcceptanceChanged);
    on<PledgeContinuePressed>(_onPledgeContinuePressed);
    on<BirthDateSaved>(_onBirthDateSaved);
    on<OnboardingStepBackRequested>(_onStepBackRequested);
    on<IdentitySaved>(_onIdentitySaved);
    on<EducationLevelsRequested>(_onEducationLevelsRequested);
    on<EducationLevelSaved>(_onEducationLevelSaved);
    on<EducationContinuePressed>(_onEducationContinuePressed);
    on<HeightSaved>(_onHeightSaved);
    on<RegionsRequested>(_onRegionsRequested);
    on<RegionSaved>(_onRegionSaved);
    on<DistrictsRequested>(_onDistrictsRequested);
    on<DistrictSaved>(_onDistrictSaved);
    on<HealthStatusesRequested>(_onHealthStatusesRequested);
    on<LocationContinuePressed>(_onLocationContinuePressed);
    on<HealthStatusSaved>(_onHealthStatusSaved);
    on<HealthStatusContinuePressed>(_onHealthStatusContinuePressed);
    on<MaritalStatusesRequested>(_onMaritalStatusesRequested);
    on<MaritalStatusSaved>(_onMaritalStatusSaved);
    on<MaritalStatusContinuePressed>(_onMaritalStatusContinuePressed);
    on<ChildrenCountChanged>(_onChildrenCountChanged);
    on<ChildrenNotLivingWithMeChanged>(_onChildrenNotLivingWithMeChanged);
    on<ProfileBootstrapRequested>(_onProfileBootstrapRequested);
    on<ProfilePhotoPickRequested>(_onProfilePhotoPickRequested);
    on<ProfilePhotoUploadRetryRequested>(_onProfilePhotoUploadRetryRequested);
    on<ProfilePhotoMainSelected>(_onProfilePhotoMainSelected);
    on<ProfilePhotoRemoveRequested>(_onProfilePhotoRemoveRequested);
    on<VoiceIntroStepRequested>(_onVoiceIntroStepRequested);
    on<ProfilePhotosContinuePressed>(_onProfilePhotosContinuePressed);
    on<MainPhotoContinuePressed>(_onMainPhotoContinuePressed);
    on<VoiceRecordingStarted>(_onVoiceRecordingStarted);
    on<VoiceRecordingStopped>(_onVoiceRecordingStopped);
    on<VoiceIntroContinuePressed>(_onVoiceIntroContinuePressed);
    on<VoiceIntroSkipped>(_onVoiceIntroSkipped);
    on<VoiceIntroDeleted>(_onVoiceIntroDeleted);
    on<VoicePlaybackRequested>(_onVoicePlaybackRequested);
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<RepresentativeContactSubmitted>(_onRepresentativeContactSubmitted);
    on<RepresentativeCandidateDoesNotUseApp>(
      _onRepresentativeCandidateDoesNotUseApp,
    );
    on<RepresentativeConsentAcknowledged>(_onRepresentativeConsentAcknowledged);
    on<RepresentativeResponsibilityChanged>(
      _onRepresentativeResponsibilityChanged,
    );
    on<RepresentativePledgeContinuePressed>(
      _onRepresentativePledgeContinuePressed,
    );
    on<FaceVerificationPageOpened>(_onFaceVerificationPageOpened);
    on<FaceVerificationRequested>(_onFaceVerificationRequested);
    on<FaceSelfieCaptured>(_onFaceSelfieCaptured);
    on<AboutMeContinuePressed>(_onAboutMeContinuePressed);
    on<AboutMeSkipPressed>(_onAboutMeSkipPressed);
    on<ProfileOnboardingFinalizationRequested>(_onFinalizationRequested);
    on<ProfileReadyHomeRequested>(_onProfileReadyHomeRequested);
    on<ProfileReadyQuestionnaireRequested>(
      _onProfileReadyQuestionnaireRequested,
    );
    on<ProfileOnboardingCancelled>(_onCancelled);
  }

  @override
  final OnboardingRepository _onboardingRepository;
  @override
  final OnboardingDraftRepository _draftRepository;
  @override
  final OnboardingMediaService _mediaService;
  @override
  final OnboardingLocationService _locationService;
  @override
  final CommitPendingAuthSessionUseCase _commitPendingAuthSession;
  @override
  final DateTime Function() _now;

  @override
  int _educationPage = 0;
  @override
  int _regionPage = 0;
  @override
  int _districtPage = 0;
  @override
  int _healthStatusPage = 0;
  @override
  int _maritalStatusPage = 0;
  @override
  int _kinshipPage = 0;
  @override
  String? _districtRegionRequest;
  @override
  String _districtSearch = '';
  @override
  bool _faceVerificationInFlight = false;

  @override
  bool _isDivorcedStatus(String name) {
    return name.trim().toLowerCase() == 'ajrashgan';
  }

  @override
  Future<void> _save(
    ProfileOnboardingDraft draft,
    Emitter<ProfileOnboardingState> emit, [
    Failure? failure,
  ]) async {
    final result = await _draftRepository.save(draft);
    result.fold(
      (draftFailure) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          failure: failure ?? draftFailure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProfileOnboardingStatus.editing,
          draft: draft,
          failure: failure,
          clearFailure: failure == null,
        ),
      ),
    );
  }

  @override
  Future<void> _cleanupDraftMedia(ProfileOnboardingDraft draft) async {
    for (final photo in draft.photos) {
      await _mediaService.deletePrivateFile(photo.localFilePath);
    }
    final voice = draft.voiceIntroMetadata;
    if (voice != null) {
      await _mediaService.deletePrivateFile(voice.localFilePath);
    }
  }

  @override
  Future<void> close() async {
    await _mediaService.dispose();
    return super.close();
  }
}
