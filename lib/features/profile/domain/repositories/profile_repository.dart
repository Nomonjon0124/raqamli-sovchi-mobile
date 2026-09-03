import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, UserProfile>> getMyProfile();

  Future<Either<Failure, bool>> updateLocation({
    required double latitude,
    required double longitude,
  });
}
