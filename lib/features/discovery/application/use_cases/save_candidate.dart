import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repositories/discovery_repository.dart';

final class SaveCandidateUseCase {
  const SaveCandidateUseCase(this._repository);

  final DiscoveryRepository _repository;

  Future<Either<Failure, bool>> call(String id) {
    return _repository.saveCandidate(id);
  }
}
