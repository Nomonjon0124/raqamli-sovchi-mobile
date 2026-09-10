import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final class UploadProfilePhotoUseCase {
  const UploadProfilePhotoUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfilePhoto>> call({
    required String profileId,
    required String filePath,
    bool isMain = true,
  }) => _repository.uploadPhoto(
    profileId: profileId,
    filePath: filePath,
    isMain: isMain,
  );
}
