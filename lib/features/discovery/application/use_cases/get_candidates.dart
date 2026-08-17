import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/candidate.dart';
import '../../domain/repositories/discovery_repository.dart';

final class GetCandidatesUseCase {
  const GetCandidatesUseCase(this._repository);

  final DiscoveryRepository _repository;

  Future<Either<Failure, List<Candidate>>> call({
    int page = 1,
    int pageSize = 10,
    String? filter,
  }) {
    return _repository.getCandidates(
      page: page,
      pageSize: pageSize,
      filter: filter,
    );
  }
}
