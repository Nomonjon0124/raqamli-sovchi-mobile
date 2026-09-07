import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../onboarding/domain/repositories/onboarding_repository.dart';
import '../../../application/use_cases/update_profile.dart';
import '../../../application/use_cases/upload_profile_photo.dart';
import '../../../domain/entities/profile_update_params.dart';
import '../../widgets/edit/profile_reference_picker_sheet.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

final class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    required UpdateProfileUseCase updateProfile,
    required UploadProfilePhotoUseCase uploadPhoto,
    required OnboardingRepository onboardingRepository,
    ImagePicker? imagePicker,
  }) : _updateProfile = updateProfile,
       _uploadPhoto = uploadPhoto,
       _onboardingRepository = onboardingRepository,
       _imagePicker = imagePicker ?? ImagePicker(),
       super(const EditProfileState()) {
    on<EditProfileStarted>(_onStarted);
    on<EditProfileNameChanged>(_onNameChanged);
    on<EditProfileBirthYearChanged>(_onBirthYearChanged);
    on<EditProfileHeightChanged>(_onHeightChanged);
    on<EditProfileWeightChanged>(_onWeightChanged);
    on<EditProfileEducationChanged>(_onEducationChanged);
    on<EditProfileProfessionChanged>(_onProfessionChanged);
    on<EditProfileProfessionCustomSubmitted>(_onProfessionCustomSubmitted);
    on<EditProfileRegionChanged>(_onRegionChanged);
    on<EditProfileDistrictChanged>(_onDistrictChanged);
    on<EditProfileMaritalStatusChanged>(_onMaritalStatusChanged);
    on<EditProfileBioChanged>(_onBioChanged);
    on<EditProfilePhotoPickRequested>(_onPhotoPickRequested);
    on<EditProfileSubmitted>(_onSubmitted);
  }

  final UpdateProfileUseCase _updateProfile;
  final UploadProfilePhotoUseCase _uploadPhoto;
  final OnboardingRepository _onboardingRepository;
  final ImagePicker _imagePicker;

  Future<void> _onStarted(
    EditProfileStarted event,
    Emitter<EditProfileState> emit,
  ) async {
    final profile = event.profile;

    emit(
      state.copyWith(
        status: EditProfileStatus.ready,
        originalProfile: profile,
        firstName: profile.firstName,
        lastName: profile.lastName,
        birthYear: profile.birthYear ?? profile.birthDate?.year,
        height: profile.height,
        weight: profile.weight?.round(),
        educationLevelId: profile.educationLevelId,
        educationLevelName: profile.educationLevelName,
        professionId: profile.professionId,
        professionName: profile.professionName,
        regionId: profile.regionId,
        regionName: profile.regionName,
        districtId: profile.districtId,
        districtName: profile.districtName,
        maritalStatusId: profile.maritalStatusId,
        maritalStatusName: profile.maritalStatusName,
        bio: profile.bio ?? '',
        mainPhotoUrl: profile.mainPhoto?.imageUrl,
      ),
    );

    await _loadReferences(emit, profile.regionId);
  }

  Future<void> _loadReferences(
    Emitter<EditProfileState> emit,
    String? currentRegionId,
  ) async {
    final educationRes = await _onboardingRepository.getEducationLevels(1);
    final professionRes = await _onboardingRepository.getProfessions(page: 1);
    final regionRes = await _onboardingRepository.getRegions(1);
    final maritalRes = await _onboardingRepository.getMaritalStatuses(1);

    final educationItems = educationRes.fold(
      (_) => <ReferenceItem>[],
      (page) =>
          page.items.map((e) => ReferenceItem(id: e.id, name: e.name)).toList(),
    );

    final professionItems = professionRes.fold(
      (_) => <ReferenceItem>[],
      (page) =>
          page.items.map((e) => ReferenceItem(id: e.id, name: e.name)).toList(),
    );

    final regionItems = regionRes.fold(
      (_) => <ReferenceItem>[],
      (page) =>
          page.items.map((e) => ReferenceItem(id: e.id, name: e.name)).toList(),
    );

    final maritalItems = maritalRes.fold(
      (_) => <ReferenceItem>[],
      (page) =>
          page.items.map((e) => ReferenceItem(id: e.id, name: e.name)).toList(),
    );

    emit(
      state.copyWith(
        educationLevels: educationItems,
        professions: professionItems,
        regions: regionItems,
        maritalStatuses: maritalItems,
      ),
    );

    if (currentRegionId != null && currentRegionId.isNotEmpty) {
      final districtRes = await _onboardingRepository.getDistricts(
        regionId: currentRegionId,
        page: 1,
      );
      final districtItems = districtRes.fold(
        (_) => <ReferenceItem>[],
        (page) => page.items
            .map((e) => ReferenceItem(id: e.id, name: e.name))
            .toList(),
      );
      emit(state.copyWith(districts: districtItems));
    }
  }

  void _onNameChanged(
    EditProfileNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(firstName: event.firstName, lastName: event.lastName));
  }

  void _onBirthYearChanged(
    EditProfileBirthYearChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(birthYear: event.birthYear));
  }

  void _onHeightChanged(
    EditProfileHeightChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(height: event.height));
  }

  void _onWeightChanged(
    EditProfileWeightChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(weight: event.weight));
  }

  void _onEducationChanged(
    EditProfileEducationChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        educationLevelId: event.id,
        educationLevelName: event.name,
      ),
    );
  }

  void _onProfessionChanged(
    EditProfileProfessionChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(professionId: event.id, professionName: event.name));
  }

  Future<void> _onProfessionCustomSubmitted(
    EditProfileProfessionCustomSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    final name = event.name.trim();
    if (name.isEmpty) return;

    emit(state.copyWith(isCreatingProfession: true, clearFailure: true));

    final result = await _onboardingRepository.createProfession(name);

    result.fold(
      (failure) =>
          emit(state.copyWith(isCreatingProfession: false, failure: failure)),
      (profession) {
        final professions = List<ReferenceItem>.from(state.professions);
        final refItem = ReferenceItem(id: profession.id, name: profession.name);
        if (!professions.any((item) => item.id == profession.id)) {
          professions.add(refItem);
        }
        emit(
          state.copyWith(
            isCreatingProfession: false,
            professions: professions,
            professionId: profession.id,
            professionName: profession.name,
          ),
        );
      },
    );
  }

  Future<void> _onRegionChanged(
    EditProfileRegionChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        regionId: event.id,
        regionName: event.name,
        clearDistrict: true,
        districts: const [],
      ),
    );

    final districtRes = await _onboardingRepository.getDistricts(
      regionId: event.id,
      page: 1,
    );
    final districtItems = districtRes.fold(
      (_) => <ReferenceItem>[],
      (page) =>
          page.items.map((e) => ReferenceItem(id: e.id, name: e.name)).toList(),
    );
    emit(state.copyWith(districts: districtItems));
  }

  void _onDistrictChanged(
    EditProfileDistrictChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(districtId: event.id, districtName: event.name));
  }

  void _onMaritalStatusChanged(
    EditProfileMaritalStatusChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(maritalStatusId: event.id, maritalStatusName: event.name),
    );
  }

  void _onBioChanged(
    EditProfileBioChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(state.copyWith(bio: event.bio));
  }

  Future<void> _onPhotoPickRequested(
    EditProfilePhotoPickRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 85,
      );
      if (picked == null) return;

      emit(
        state.copyWith(
          localPhotoPath: picked.path,
          isUploadingPhoto: true,
          clearFailure: true,
        ),
      );

      final profileId = state.originalProfile?.id ?? '';
      if (profileId.isNotEmpty) {
        final result = await _uploadPhoto(
          profileId: profileId,
          filePath: picked.path,
        );
        result.fold(
          (failure) =>
              emit(state.copyWith(isUploadingPhoto: false, failure: failure)),
          (photo) => emit(
            state.copyWith(
              isUploadingPhoto: false,
              mainPhotoUrl: photo.imageUrl,
            ),
          ),
        );
      } else {
        emit(state.copyWith(isUploadingPhoto: false));
      }
    } catch (e) {
      emit(state.copyWith(isUploadingPhoto: false));
    }
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    if (!state.isSaveEnabled) return;

    emit(
      state.copyWith(status: EditProfileStatus.submitting, clearFailure: true),
    );

    DateTime? birthDate;
    if (state.birthYear != null) {
      final origDate = state.originalProfile?.birthDate;
      if (origDate != null) {
        birthDate = DateTime(state.birthYear!, origDate.month, origDate.day);
      } else {
        birthDate = DateTime(state.birthYear!, 1, 1);
      }
    }

    final params = ProfileUpdateParams(
      firstName: state.firstName,
      lastName: state.lastName,
      middleName: state.originalProfile?.middleName,
      birthDate: birthDate,
      height: state.height,
      weight: state.weight,
      regionId: state.regionId,
      districtId: state.districtId,
      educationLevelId: state.educationLevelId,
      professionId: state.professionId,
      maritalStatusId: state.maritalStatusId,
      bio: state.bio,
    );

    final result = await _updateProfile(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: EditProfileStatus.failure, failure: failure),
      ),
      (updated) => emit(
        state.copyWith(
          status: EditProfileStatus.success,
          updatedProfile: updated,
        ),
      ),
    );
  }
}
