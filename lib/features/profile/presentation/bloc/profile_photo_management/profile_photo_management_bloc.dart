import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../application/services/profile_photo_picker.dart';
import '../../../application/use_cases/delete_profile_photo.dart';
import '../../../application/use_cases/get_my_profile.dart';
import '../../../application/use_cases/set_main_profile_photo.dart';
import '../../../application/use_cases/upload_profile_photo.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_photo_management_event.dart';
import 'profile_photo_management_state.dart';

final class ProfilePhotoManagementBloc
    extends Bloc<ProfilePhotoManagementEvent, ProfilePhotoManagementState> {
  ProfilePhotoManagementBloc({
    required GetMyProfileUseCase getMyProfile,
    required UploadProfilePhotoUseCase uploadPhoto,
    required SetMainProfilePhotoUseCase setMainPhoto,
    required DeleteProfilePhotoUseCase deletePhoto,
    required ProfilePhotoPicker photoPicker,
  }) : _getMyProfile = getMyProfile,
       _uploadPhoto = uploadPhoto,
       _setMainPhoto = setMainPhoto,
       _deletePhoto = deletePhoto,
       _photoPicker = photoPicker,
       super(const ProfilePhotoManagementState()) {
    on<ProfilePhotoManagementStarted>(_onStarted);
    on<ProfilePhotoManagementPickRequested>(_onPickRequested);
    on<ProfilePhotoManagementSetMainRequested>(_onSetMainRequested);
    on<ProfilePhotoManagementDeleteRequested>(_onDeleteRequested);
    on<ProfilePhotoManagementVerificationOpened>(
      (event, emit) => emit(state.copyWith(verificationPending: false)),
    );
    on<ProfilePhotoManagementVerificationCompleted>(
      (event, emit) => emit(state.copyWith(verificationRequired: false)),
    );
  }

  final GetMyProfileUseCase _getMyProfile;
  final UploadProfilePhotoUseCase _uploadPhoto;
  final SetMainProfilePhotoUseCase _setMainPhoto;
  final DeleteProfilePhotoUseCase _deletePhoto;
  final ProfilePhotoPicker _photoPicker;

  void _onStarted(
    ProfilePhotoManagementStarted event,
    Emitter<ProfilePhotoManagementState> emit,
  ) {
    emit(
      state.copyWith(
        status: ProfilePhotoManagementStatus.ready,
        profile: event.profile,
        photos: event.profile.photos,
        clearFailure: true,
      ),
    );
  }

  Future<void> _onPickRequested(
    ProfilePhotoManagementPickRequested event,
    Emitter<ProfilePhotoManagementState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null || state.isBusy) return;
    final replacing = event.replacePhotoId == null
        ? null
        : _findPhoto(event.replacePhotoId!);
    if (replacing == null && state.photos.length >= 5) return;

    String? path;
    try {
      path = await _photoPicker.pick(event.source);
    } on ProfilePhotoPickerException {
      emit(
        state.copyWith(
          status: ProfilePhotoManagementStatus.failure,
          failure: const Failure.unknown(),
        ),
      );
      return;
    }
    if (path == null) return;

    emit(state.copyWith(isBusy: true, clearFailure: true));
    final result = await _uploadPhoto(
      profileId: profile.id,
      filePath: path,
      isMain: replacing?.isMain ?? state.photos.isEmpty,
    );
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfilePhotoManagementStatus.failure,
          isBusy: false,
          failure: failure,
        ),
      ),
      (_) async {
        if (replacing != null) {
          final deleteResult = await _deletePhoto(replacing.id);
          final deleteFailure = deleteResult.fold<Failure?>(
            (failure) => failure,
            (_) => null,
          );
          if (deleteFailure != null) {
            emit(
              state.copyWith(
                status: ProfilePhotoManagementStatus.failure,
                isBusy: false,
                failure: deleteFailure,
              ),
            );
            await _reload(emit);
            return;
          }
        }
        await _reload(emit);
        emit(
          state.copyWith(
            status: ProfilePhotoManagementStatus.ready,
            isBusy: false,
            verificationPending: true,
            verificationRequired: true,
          ),
        );
      },
    );
  }

  Future<void> _onSetMainRequested(
    ProfilePhotoManagementSetMainRequested event,
    Emitter<ProfilePhotoManagementState> emit,
  ) async {
    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true, clearFailure: true));
    final result = await _setMainPhoto(event.photoId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfilePhotoManagementStatus.failure,
          isBusy: false,
          failure: failure,
        ),
      ),
      (_) async {
        await _reload(emit);
        emit(
          state.copyWith(
            isBusy: false,
            verificationPending: true,
            verificationRequired: true,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteRequested(
    ProfilePhotoManagementDeleteRequested event,
    Emitter<ProfilePhotoManagementState> emit,
  ) async {
    if (state.isBusy) return;
    emit(state.copyWith(isBusy: true, clearFailure: true));
    final result = await _deletePhoto(event.photoId);
    await result.fold<Future<void>>(
      (failure) async => emit(
        state.copyWith(
          status: ProfilePhotoManagementStatus.failure,
          isBusy: false,
          failure: failure,
        ),
      ),
      (_) async {
        await _reload(emit);
        emit(state.copyWith(isBusy: false));
      },
    );
  }

  ProfilePhoto? _findPhoto(String id) {
    for (final photo in state.photos) {
      if (photo.id == id) return photo;
    }
    return null;
  }

  Future<bool> _reload(Emitter<ProfilePhotoManagementState> emit) async {
    final result = await _getMyProfile();
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: ProfilePhotoManagementStatus.failure,
            failure: failure,
          ),
        );
        return false;
      },
      (profile) {
        emit(
          state.copyWith(
            status: ProfilePhotoManagementStatus.ready,
            profile: profile,
            photos: profile.photos,
          ),
        );
        return true;
      },
    );
  }
}
