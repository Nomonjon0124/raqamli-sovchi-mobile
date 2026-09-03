import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/photo_request.dart';
import '../../domain/repositories/photo_request_repository.dart';

final class CreatePhotoRequestUseCase {
  const CreatePhotoRequestUseCase(this._repository);

  final PhotoRequestRepository _repository;

  Future<Either<Failure, PhotoRequest>> call({
    required String toProfile,
    String? note,
  }) {
    return _repository.createRequest(toProfile: toProfile, note: note);
  }
}
