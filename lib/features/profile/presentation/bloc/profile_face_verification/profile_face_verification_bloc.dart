import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../onboarding/application/services/onboarding_media_service.dart';
import '../../../../onboarding/domain/repositories/onboarding_repository.dart';
import 'profile_face_verification_event.dart';
import 'profile_face_verification_state.dart';

final class ProfileFaceVerificationBloc
    extends Bloc<ProfileFaceVerificationEvent, ProfileFaceVerificationState> {
  ProfileFaceVerificationBloc({
    required OnboardingRepository onboardingRepository,
    required OnboardingMediaService mediaService,
  }) : _onboardingRepository = onboardingRepository,
       _mediaService = mediaService,
       super(const ProfileFaceVerificationState()) {
    on<ProfileFaceVerificationCaptured>(_onCaptured);
  }

  final OnboardingRepository _onboardingRepository;
  final OnboardingMediaService _mediaService;

  @override
  Future<void> close() async {
    await _mediaService.dispose();
    return super.close();
  }

  Future<void> _onCaptured(
    ProfileFaceVerificationCaptured event,
    Emitter<ProfileFaceVerificationState> emit,
  ) async {
    if (state.status == ProfileFaceVerificationStatus.verifying) return;

    emit(
      state.copyWith(
        status: ProfileFaceVerificationStatus.verifying,
        clearFailure: true,
      ),
    );
    String? preparedPath;
    try {
      preparedPath = await _mediaService.prepareSelfie(event.sourcePath);
      final quality = await _mediaService.checkSelfieQuality(preparedPath);
      if (!quality.isValid) {
        emit(state.copyWith(status: ProfileFaceVerificationStatus.failure));
        return;
      }

      final result = await _onboardingRepository.verifyFace(preparedPath);
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ProfileFaceVerificationStatus.failure,
            failure: failure,
          ),
        ),
        (response) => emit(
          state.copyWith(
            status: response.verified
                ? ProfileFaceVerificationStatus.success
                : ProfileFaceVerificationStatus.failure,
          ),
        ),
      );
    } on OnboardingMediaValidationException {
      emit(state.copyWith(status: ProfileFaceVerificationStatus.failure));
    } on Exception {
      emit(
        state.copyWith(
          status: ProfileFaceVerificationStatus.failure,
          failure: const Failure.unknown(),
        ),
      );
    } finally {
      await _mediaService.deletePrivateFile(event.sourcePath);
      if (preparedPath != null) {
        await _mediaService.deletePrivateFile(preparedPath);
      }
    }
  }
}
