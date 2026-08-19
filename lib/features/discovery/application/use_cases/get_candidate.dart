import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/repositories/discovery_repository.dart';

final class GetCandidateUseCase {
  const GetCandidateUseCase(this._repository);

  final DiscoveryRepository _repository;

  Future<Either<Failure, Candidate>> call(String id) {
    return _repository.getCandidate(id);
  }
}
