import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../application/services/profile_photo_picker.dart';
import '../../application/use_cases/delete_profile_photo.dart';
import '../../application/use_cases/get_my_profile.dart';
import '../../application/use_cases/set_main_profile_photo.dart';
import '../../application/use_cases/upload_profile_photo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetMyProfileUseCase getMyProfile,
    UploadProfilePhotoUseCase? uploadPhoto,
    SetMainProfilePhotoUseCase? setMainPhoto,
    DeleteProfilePhotoUseCase? deletePhoto,
    ProfilePhotoPicker? photoPicker,
  }) : _getMyProfile = getMyProfile,
       _uploadPhoto = uploadPhoto,
       _setMainPhoto = setMainPhoto,
       _deletePhoto = deletePhoto,
       _photoPicker = photoPicker,
       super(const ProfileState()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileRefreshRequested>(_onRefreshRequested);
    on<ProfilePhotoPickRequested>(_onPhotoPickRequested);
    on<ProfilePhotoSetMainRequested>(_onPhotoSetMainRequested);
    on<ProfilePhotoDeleteRequested>(_onPhotoDeleteRequested);
  }

  final GetMyProfileUseCase _getMyProfile;
  final UploadProfilePhotoUseCase? _uploadPhoto;
  final SetMainProfilePhotoUseCase? _setMainPhoto;
  final DeleteProfilePhotoUseCase? _deletePhoto;
  final ProfilePhotoPicker? _photoPicker;

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ProfileStatus.loading,
        isRefreshing: false,
        clearFailure: true,
      ),
    );
    await _load(emit);
  }

  Future<void> _onRefreshRequested(
    ProfileRefreshRequested event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(isRefreshing: true, clearFailure: true));
    await _load(emit);
  }

  Future<void> _load(Emitter<ProfileState> emit) async {
    final result = await _getMyProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: state.profile == null
              ? ProfileStatus.failure
              : ProfileStatus.success,
          failure: failure,
          isRefreshing: false,
        ),
      ),
      (profile) =>
          emit(ProfileState(status: ProfileStatus.success, profile: profile)),
    );
  }

  Future<void> _onPhotoPickRequested(
    ProfilePhotoPickRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = state.profile;
    final uploadPhoto = _uploadPhoto;
    if (profile == null ||
        uploadPhoto == null ||
        profile.photos.length >= 4 ||
        state.isPhotoActionInProgress) {
      return;
    }

    final photoPicker = _photoPicker;
    if (photoPicker == null) return;

    final pickedPath = await _pickPhoto(photoPicker, event.source, emit);
    if (pickedPath == null) return;

    emit(state.copyWith(isPhotoActionInProgress: true, clearFailure: true));
    final result = await uploadPhoto(
      profileId: profile.id,
      filePath: pickedPath,
      isMain: profile.photos.isEmpty,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(isPhotoActionInProgress: false, failure: failure),
      ),
      (_) async {
        emit(state.copyWith(isPhotoActionInProgress: false));
        await _load(emit);
      },
    );
  }

  Future<String?> _pickPhoto(
    ProfilePhotoPicker photoPicker,
    ProfilePhotoSource source,
    Emitter<ProfileState> emit,
  ) async {
    try {
      return await photoPicker.pick(source);
    } on ProfilePhotoPickerException {
      emit(
        state.copyWith(
          isPhotoActionInProgress: false,
          failure: const Failure.unknown(),
        ),
      );
      return null;
    }
  }

  Future<void> _onPhotoSetMainRequested(
    ProfilePhotoSetMainRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final setMainPhoto = _setMainPhoto;
    if (setMainPhoto == null || state.isPhotoActionInProgress) return;
    emit(state.copyWith(isPhotoActionInProgress: true, clearFailure: true));
    final result = await setMainPhoto(event.photoId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(isPhotoActionInProgress: false, failure: failure),
      ),
      (_) async {
        emit(state.copyWith(isPhotoActionInProgress: false));
        await _load(emit);
      },
    );
  }

  Future<void> _onPhotoDeleteRequested(
    ProfilePhotoDeleteRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final deletePhoto = _deletePhoto;
    if (deletePhoto == null || state.isPhotoActionInProgress) return;
    emit(state.copyWith(isPhotoActionInProgress: true, clearFailure: true));
    final result = await deletePhoto(event.photoId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(isPhotoActionInProgress: false, failure: failure),
      ),
      (_) async {
        emit(state.copyWith(isPhotoActionInProgress: false));
        await _load(emit);
      },
    );
  }
}
