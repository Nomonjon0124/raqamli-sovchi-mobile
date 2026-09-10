import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/profile_update_params.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfile>> getMyProfile();

  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  });

  Future<Either<Failure, UserProfile>> updateProfile(
    ProfileUpdateParams params,
  );

  Future<Either<Failure, ProfilePhoto>> uploadPhoto({
    required String profileId,
    required String filePath,
    bool isMain = true,
  });

  Future<Either<Failure, ProfilePhoto>> setMainPhoto(String photoId);

  Future<Either<Failure, void>> deletePhoto(String photoId);
}
