import '../../../../core/errors/either.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/match_request.dart';
import '../../domain/repositories/match_request_repository.dart';

final class GetMatchRequestsUseCase {
  const GetMatchRequestsUseCase(this._repository);

  final MatchRequestRepository _repository;

  Future<Either<Failure, List<MatchRequest>>> call({
    String? fromProfile,
    String? toProfile,
    MatchRequestStatus? status,
  }) {
    return _repository.getRequests(
      fromProfile: fromProfile,
      toProfile: toProfile,
      status: status,
    );
  }
}
