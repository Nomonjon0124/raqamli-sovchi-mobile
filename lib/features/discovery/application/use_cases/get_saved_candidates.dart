import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/repositories/discovery_repository.dart';

final class GetSavedCandidatesUseCase {
  const GetSavedCandidatesUseCase(this._repository);

  final DiscoveryRepository _repository;

  Future<Either<Failure, List<Candidate>>> call() {
    return _repository.getSavedCandidates();
  }
}
