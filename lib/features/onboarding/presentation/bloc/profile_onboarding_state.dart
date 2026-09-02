import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/onboarding_reference.dart';
import '../../domain/entities/profile_onboarding_draft.dart';

enum ProfileOnboardingStatus {
  initial,
  loading,
  editing,
  submitting,
  completed,
  cancelled,
}

enum ReferenceStatus { idle, loading, loaded, empty, failure }

final class ProfileOnboardingState extends Equatable {
  const ProfileOnboardingState({
    this.status = ProfileOnboardingStatus.initial,
    this.draft,
    this.professions = const [],
    this.educationLevels = const [],
    this.regions = const [],
    this.districts = const [],
    this.healthStatuses = const [],
    this.maritalStatuses = const [],
    this.kinships = const [],
    this.educationStatus = ReferenceStatus.idle,
    this.professionStatus = ReferenceStatus.idle,
    this.regionStatus = ReferenceStatus.idle,
    this.districtStatus = ReferenceStatus.idle,
    this.healthStatusStatus = ReferenceStatus.idle,
    this.maritalStatusStatus = ReferenceStatus.idle,
    this.kinshipStatus = ReferenceStatus.idle,
    this.isVoiceRecording = false,
    this.isVoicePlaying = false,
    this.isLocationLoading = false,
    this.isOtherProfessionSelected = false,
    this.openQuestionnaire = false,
    this.failure,
  });

  final ProfileOnboardingStatus status;
  final ProfileOnboardingDraft? draft;
  final List<Profession> professions;
  final List<EducationLevel> educationLevels;
  final List<Region> regions;
  final List<District> districts;
  final List<HealthStatus> healthStatuses;
  final List<MaritalStatus> maritalStatuses;
  final List<Kinship> kinships;
  final ReferenceStatus educationStatus;
  final ReferenceStatus professionStatus;
  final ReferenceStatus regionStatus;
  final ReferenceStatus districtStatus;
  final ReferenceStatus healthStatusStatus;
  final ReferenceStatus maritalStatusStatus;
  final ReferenceStatus kinshipStatus;
  final bool isVoiceRecording;
  final bool isVoicePlaying;
  final bool isLocationLoading;
  final bool isOtherProfessionSelected;
  final bool openQuestionnaire;
  final Failure? failure;

  bool get isBusy =>
      status == ProfileOnboardingStatus.loading ||
      status == ProfileOnboardingStatus.submitting;

  ProfileOnboardingState copyWith({
    ProfileOnboardingStatus? status,
    ProfileOnboardingDraft? draft,
    List<Profession>? professions,
    List<EducationLevel>? educationLevels,
    List<Region>? regions,
    List<District>? districts,
    List<HealthStatus>? healthStatuses,
    List<MaritalStatus>? maritalStatuses,
    List<Kinship>? kinships,
    ReferenceStatus? educationStatus,
    ReferenceStatus? professionStatus,
    ReferenceStatus? regionStatus,
    ReferenceStatus? districtStatus,
    ReferenceStatus? healthStatusStatus,
    ReferenceStatus? maritalStatusStatus,
    ReferenceStatus? kinshipStatus,
    bool? isVoiceRecording,
    bool? isVoicePlaying,
    bool? isLocationLoading,
    bool? isOtherProfessionSelected,
    bool? openQuestionnaire,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProfileOnboardingState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      professions: professions ?? this.professions,
      educationLevels: educationLevels ?? this.educationLevels,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      healthStatuses: healthStatuses ?? this.healthStatuses,
      maritalStatuses: maritalStatuses ?? this.maritalStatuses,
      kinships: kinships ?? this.kinships,
      educationStatus: educationStatus ?? this.educationStatus,
      professionStatus: professionStatus ?? this.professionStatus,
      regionStatus: regionStatus ?? this.regionStatus,
      districtStatus: districtStatus ?? this.districtStatus,
      healthStatusStatus: healthStatusStatus ?? this.healthStatusStatus,
      maritalStatusStatus: maritalStatusStatus ?? this.maritalStatusStatus,
      kinshipStatus: kinshipStatus ?? this.kinshipStatus,
      isVoiceRecording: isVoiceRecording ?? this.isVoiceRecording,
      isVoicePlaying: isVoicePlaying ?? this.isVoicePlaying,
      isLocationLoading: isLocationLoading ?? this.isLocationLoading,
      isOtherProfessionSelected:
          isOtherProfessionSelected ?? this.isOtherProfessionSelected,
      openQuestionnaire: openQuestionnaire ?? this.openQuestionnaire,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    draft,
    professions,
    educationLevels,
    regions,
    districts,
    healthStatuses,
    maritalStatuses,
    kinships,
    educationStatus,
    professionStatus,
    regionStatus,
    districtStatus,
    healthStatusStatus,
    maritalStatusStatus,
    kinshipStatus,
    isVoiceRecording,
    isVoicePlaying,
    isLocationLoading,
    isOtherProfessionSelected,
    openQuestionnaire,
    failure,
  ];
}
