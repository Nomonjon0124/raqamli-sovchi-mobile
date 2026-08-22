import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../entities/candidate.dart';
import '../entities/discovery_filter.dart';

abstract interface class DiscoveryRepository {
  Future<Either<Failure, List<Candidate>>> getCandidates({
    int page = 1,
    int pageSize = 10,
    DiscoveryFilter filter = DiscoveryFilter.matches,
    double? radiusKm,
  });

  Future<Either<Failure, Candidate>> getCandidate(String id);

  Future<Either<Failure, List<Candidate>>> getSavedCandidates();

  Future<Either<Failure, bool>> saveCandidate(String id);

  Future<Either<Failure, bool>> unsaveCandidate(String id);
}
