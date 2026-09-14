import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/profile_repository.dart';

final class DeleteProfilePhotoUseCase {
  const DeleteProfilePhotoUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, void>> call(String photoId) =>
      _repository.deletePhoto(photoId);
}
