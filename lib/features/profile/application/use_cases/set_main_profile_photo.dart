import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

final class SetMainProfilePhotoUseCase {
  const SetMainProfilePhotoUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, ProfilePhoto>> call(String photoId) =>
      _repository.setMainPhoto(photoId);
}
