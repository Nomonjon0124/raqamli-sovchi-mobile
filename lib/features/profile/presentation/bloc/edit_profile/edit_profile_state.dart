import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../domain/entities/user_profile.dart';
import '../../widgets/edit/profile_reference_picker_sheet.dart';

enum EditProfileStatus { initial, loading, ready, submitting, success, failure }

final class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.originalProfile,
    this.updatedProfile,
    this.firstName = '',
    this.lastName = '',
    this.birthYear,
    this.height,
    this.weight,
    this.educationLevelId,
    this.educationLevelName,
    this.professionId,
    this.professionName,
    this.regionId,
    this.regionName,
    this.districtId,
    this.districtName,
    this.maritalStatusId,
    this.maritalStatusName,
    this.bio = '',
    this.localPhotoPath,
    this.mainPhotoUrl,
    this.educationLevels = const [],
    this.professions = const [],
    this.regions = const [],
    this.districts = const [],
    this.maritalStatuses = const [],
    this.isUploadingPhoto = false,
    this.isCreatingProfession = false,
    this.failure,
  });

  final EditProfileStatus status;
  final UserProfile? originalProfile;
  final UserProfile? updatedProfile;
  final String firstName;
  final String lastName;
  final int? birthYear;
  final int? height;
  final int? weight;
  final String? educationLevelId;
  final String? educationLevelName;
  final String? professionId;
  final String? professionName;
  final String? regionId;
  final String? regionName;
  final String? districtId;
  final String? districtName;
  final String? maritalStatusId;
  final String? maritalStatusName;
  final String bio;
  final String? localPhotoPath;
  final String? mainPhotoUrl;

  final List<ReferenceItem> educationLevels;
  final List<ReferenceItem> professions;
  final List<ReferenceItem> regions;
  final List<ReferenceItem> districts;
  final List<ReferenceItem> maritalStatuses;

  final bool isUploadingPhoto;
  final bool isCreatingProfession;
  final Failure? failure;

  String get displayName =>
      [firstName.trim(), lastName.trim()].where((s) => s.isNotEmpty).join(' ');

  String get initials {
    final parts = [
      firstName.trim(),
      lastName.trim(),
    ].where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  bool get isSubmitting => status == EditProfileStatus.submitting;

  bool get hasUnsavedChanges {
    final profile = originalProfile;
    final originalBirthYear = profile?.birthYear ?? profile?.birthDate?.year;

    return _trimmed(firstName) != _trimmed(profile?.firstName) ||
        _trimmed(lastName) != _trimmed(profile?.lastName) ||
        birthYear != originalBirthYear ||
        height != profile?.height ||
        weight != profile?.weight?.round() ||
        educationLevelId != profile?.educationLevelId ||
        professionId != profile?.professionId ||
        regionId != profile?.regionId ||
        districtId != profile?.districtId ||
        maritalStatusId != profile?.maritalStatusId ||
        _trimmed(bio) != _trimmed(profile?.bio) ||
        (localPhotoPath?.trim().isNotEmpty ?? false);
  }

  bool get isSaveEnabled =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      hasUnsavedChanges &&
      !isUploadingPhoto &&
      status != EditProfileStatus.submitting;

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserProfile? originalProfile,
    UserProfile? updatedProfile,
    String? firstName,
    String? lastName,
    int? birthYear,
    int? height,
    int? weight,
    String? educationLevelId,
    String? educationLevelName,
    String? professionId,
    String? professionName,
    String? regionId,
    String? regionName,
    String? districtId,
    String? districtName,
    String? maritalStatusId,
    String? maritalStatusName,
    String? bio,
    String? localPhotoPath,
    String? mainPhotoUrl,
    List<ReferenceItem>? educationLevels,
    List<ReferenceItem>? professions,
    List<ReferenceItem>? regions,
    List<ReferenceItem>? districts,
    List<ReferenceItem>? maritalStatuses,
    bool? isUploadingPhoto,
    bool? isCreatingProfession,
    Failure? failure,
    bool clearFailure = false,
    bool clearDistrict = false,
    bool clearLocalPhotoPath = false,
    bool clearMainPhotoUrl = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      originalProfile: originalProfile ?? this.originalProfile,
      updatedProfile: updatedProfile ?? this.updatedProfile,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthYear: birthYear ?? this.birthYear,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      educationLevelId: educationLevelId ?? this.educationLevelId,
      educationLevelName: educationLevelName ?? this.educationLevelName,
      professionId: professionId ?? this.professionId,
      professionName: professionName ?? this.professionName,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
      districtId: clearDistrict ? null : districtId ?? this.districtId,
      districtName: clearDistrict ? null : districtName ?? this.districtName,
      maritalStatusId: maritalStatusId ?? this.maritalStatusId,
      maritalStatusName: maritalStatusName ?? this.maritalStatusName,
      bio: bio ?? this.bio,
      localPhotoPath: clearLocalPhotoPath
          ? null
          : localPhotoPath ?? this.localPhotoPath,
      mainPhotoUrl: clearMainPhotoUrl
          ? null
          : mainPhotoUrl ?? this.mainPhotoUrl,
      educationLevels: educationLevels ?? this.educationLevels,
      professions: professions ?? this.professions,
      regions: regions ?? this.regions,
      districts: districts ?? this.districts,
      maritalStatuses: maritalStatuses ?? this.maritalStatuses,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      isCreatingProfession: isCreatingProfession ?? this.isCreatingProfession,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    originalProfile,
    updatedProfile,
    firstName,
    lastName,
    birthYear,
    height,
    weight,
    educationLevelId,
    educationLevelName,
    professionId,
    professionName,
    regionId,
    regionName,
    districtId,
    districtName,
    maritalStatusId,
    maritalStatusName,
    bio,
    localPhotoPath,
    mainPhotoUrl,
    educationLevels,
    professions,
    regions,
    districts,
    maritalStatuses,
    isUploadingPhoto,
    isCreatingProfession,
    failure,
  ];
}

String _trimmed(String? value) => value?.trim() ?? '';
